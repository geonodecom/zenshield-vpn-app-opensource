import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/core/utils/platform_utils.dart';
import 'package:zenshield/feature/agreements/domain/useCase/agreement_use_case.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/feature/desktop_updater/domain/useCase/desktop_updater_use_case.dart';
import 'package:zenshield/feature/vpn_connection/domain/repositories/vpn_manager.dart';
import 'package:zenshield/feature/app_update/presentation/app_update_side_effect.dart';
import 'package:zenshield/feature/app_update/presentation/state/app_update_state.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

part 'app_update_event.dart';

class AppUpdateBloc
    extends SideEffectBloc<AppUpdateEvent, AppUpdateState, AppUpdateSideEffect>
    with WidgetsBindingObserver {
  AppUpdateBloc({
    AppUpdateEvent? startEvent,
    required AbstractAuthUserUseCase authUseCase,
    required AbstractDesktopUpdaterUseCase desktopUpdaterUseCase,
    required AbstractAgreementUseCase agreementUseCase,
    required AbstractVpnManager vpnManager,
    required Talker logger,
  }) : _authUseCase = authUseCase,
       _desktopUpdaterUseCase = desktopUpdaterUseCase,
       _vpnManager = vpnManager,
       _agreementUseCase = agreementUseCase,
       _logger = logger,
       _skipConfirmPrompt = startEvent != null,
       super(const AppUpdateState.checking()) {
    if (PlatformUtils.isDesktop || Platform.isAndroid) {
      _setupDesktopUpdaterListeners();
    }
    if (Platform.isAndroid) {
      WidgetsBinding.instance.addObserver(this);
    }

    on<InitialEvent>(_onInitial);
    on<CheckForUpdatesEvent>(_onCheckForUpdates);
    on<UpdateAvailableEvent>(_onUpdateAvailable);
    on<StartUpdateEvent>(_onStartUpdate);
    on<RetryUpdateEvent>(_onRetryUpdate);
    on<SkipUpdateEvent>(_onSkipUpdate);
    on<DownloadProgressEvent>(_onDownloadProgress);
    on<InstallProgressEvent>(_onInstallProgress);
    on<UpdateCompletedEvent>(_onUpdateCompleted);
    on<DownloadFailedEvent>(_onDownloadFailed);
    on<AppResumedEvent>(_onAppResumed);

    if (startEvent != null) {
      add(startEvent);
    } else {
      add(const InitialEvent());
    }
  }

  // Dependencies
  final AbstractAuthUserUseCase _authUseCase;
  final AbstractDesktopUpdaterUseCase _desktopUpdaterUseCase;
  final AbstractVpnManager _vpnManager;
  final AbstractAgreementUseCase _agreementUseCase;
  final Talker _logger;
  final bool _skipConfirmPrompt;

  bool _confirmDispatched = false;

  void _setupDesktopUpdaterListeners() {
    _desktopUpdaterUseCase.addListener(_onDesktopUpdaterChanged);
  }

  Future<void> _onDesktopUpdaterChanged() async {
    if (isClosed) return;

    try {
      final isUpdateInProgress = state.maybeWhen(
        downloading: (_) => true,
        installing: (_) => true,
        restarting: () => true,
        orElse: () => false,
      );
      if (!_skipConfirmPrompt &&
          _desktopUpdaterUseCase.needUpdate &&
          !_desktopUpdaterUseCase.isDownloading &&
          !_desktopUpdaterUseCase.isDownloaded &&
          !isUpdateInProgress &&
          !_confirmDispatched) {
        _confirmDispatched = true;
        add(const UpdateAvailableEvent());
      }

      if (_desktopUpdaterUseCase.isDownloading) {
        add(
          DownloadProgressEvent(
            progress: _desktopUpdaterUseCase.downloadProgress,
          ),
        );
      }

      if (_desktopUpdaterUseCase.isDownloaded) {
        final isRestarting = state.maybeWhen(
          restarting: () => true,
          orElse: () => false,
        );
        if (!isRestarting) {
          if (Platform.isAndroid) {
            //await Permission.notification.request();
          }
          add(const UpdateCompletedEvent());
        }
      }

      final wasDownloading = state.maybeWhen(
        downloading: (_) => true,
        installing: (_) => true,
        orElse: () => false,
      );
      if (wasDownloading &&
          !_desktopUpdaterUseCase.isDownloading &&
          !_desktopUpdaterUseCase.isDownloaded &&
          _desktopUpdaterUseCase.downloadHadError) {
        add(const DownloadFailedEvent());
      }
    } catch (e) {
      _logger.error(e);
    }
  }

  @override
  Future<void> close() async {
    _desktopUpdaterUseCase.removeListener(_onDesktopUpdaterChanged);
    if (Platform.isAndroid) {
      WidgetsBinding.instance.removeObserver(this);
    }
    return super.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    if (appState == AppLifecycleState.resumed) {
      add(const AppResumedEvent());
    }
  }

  Future<void> _onAppResumed(
    AppResumedEvent event,
    Emitter<AppUpdateState> emit,
  ) async {
    // On Android, the OS installer takes over the foreground while it runs,
    // which tears down the OTA plugin's event stream — so we can come back
    // here with no idea whether the install actually succeeded or failed.
    // Re-check reality instead of leaving the UI frozen on "Downloading".
    final isStuckAfterInstallHandoff = state.maybeWhen(
      downloading: (progress) => progress >= 1.0,
      orElse: () => false,
    );
    if (!isStuckAfterInstallHandoff || isClosed) return;

    final succeeded = await _desktopUpdaterUseCase.hasUpdateSucceeded();
    if (isClosed || emit.isDone) return;

    if (succeeded) {
      await _navigateToNextScreen();
    } else {
      _logger.warning(
        '[AppUpdate] Resumed after handing off to the OS installer with no '
        'outcome reported — treating as a failed install.',
      );
      emit(
        AppUpdateState.error(
          isMandatory: _desktopUpdaterUseCase.isMandatory,
          isInstallFailure: true,
        ),
      );
    }
  }

  Future<void> _onInitial(
    InitialEvent event,
    Emitter<AppUpdateState> emit,
  ) async {
    add(const CheckForUpdatesEvent());
  }

  Future<void> _onUpdateAvailable(
    UpdateAvailableEvent event,
    Emitter<AppUpdateState> emit,
  ) async {
    if (!isClosed && !emit.isDone) {
      emit(
        AppUpdateState.confirm(
          isMandatory: _desktopUpdaterUseCase.isMandatory,
          version: _desktopUpdaterUseCase.appVersion,
        ),
      );
    }
  }

  Future<void> _onCheckForUpdates(
    CheckForUpdatesEvent event,
    Emitter<AppUpdateState> emit,
  ) async {
    if (!isClosed && !emit.isDone) {
      emit(const AppUpdateState.checking());
    }

    if ((PlatformUtils.isDesktop || Platform.isAndroid) && !isClosed) {
      const maxRetries = 4;
      const retryDelay = Duration(seconds: 5);

      for (int attempt = 0; attempt < maxRetries; attempt++) {
        try {
          if (isClosed || emit.isDone) return;
          await _desktopUpdaterUseCase.initializeUpdater();
          await _desktopUpdaterUseCase.checkVersion();

          if (isClosed || emit.isDone) return;
          await Future.delayed(const Duration(milliseconds: 500));

          if (!isClosed && !emit.isDone) {
            if (!_desktopUpdaterUseCase.needUpdate) {
              await _navigateToNextScreen();
            }
          }
          return;
        } catch (e) {
          _logger.error(e);
          final isLastAttempt = attempt == maxRetries - 1;
          if (isLastAttempt) {
            if (!isClosed && !emit.isDone) {
              emit(
                AppUpdateState.error(
                  isMandatory: _desktopUpdaterUseCase.isMandatory,
                ),
              );
            }
          } else {
            await Future.delayed(retryDelay);
          }
        }
      }
    } else {
      await Future.delayed(const Duration(seconds: 2));
      emit(const AppUpdateState.downloading(progress: 0.0));
      for (double progress = 0.0; progress <= 1.0; progress += 0.1) {
        await Future.delayed(const Duration(milliseconds: 300));
        emit(AppUpdateState.downloading(progress: progress));
      }
      emit(const AppUpdateState.installing(progress: 0.0));
      for (double progress = 0.0; progress <= 1.0; progress += 0.1) {
        await Future.delayed(const Duration(milliseconds: 300));
        emit(AppUpdateState.installing(progress: progress));
      }
      emit(const AppUpdateState.restarting());
      await Future.delayed(const Duration(seconds: 2));
      produceSideEffect(const NavigateToSplash());
    }
  }

  Future<void> _onStartUpdate(
    StartUpdateEvent event,
    Emitter<AppUpdateState> emit,
  ) async {
    final isUpdateInProgress = state.maybeWhen(
      downloading: (_) => true,
      installing: (_) => true,
      restarting: () => true,
      orElse: () => false,
    );
    if (isUpdateInProgress) return;

    if ((PlatformUtils.isDesktop || Platform.isAndroid) && !isClosed) {
      try {
        if (isClosed) return;

        emit(const AppUpdateState.downloading(progress: 0.0));
        await _desktopUpdaterUseCase.initializeUpdater();
        await _desktopUpdaterUseCase.checkVersion();
        await _desktopUpdaterUseCase.downloadUpdate();

        if (isClosed || emit.isDone) return;
        await Future.delayed(const Duration(milliseconds: 500));

        if (!isClosed && !emit.isDone) {
          if (!_desktopUpdaterUseCase.needUpdate) {
            await _navigateToNextScreen();
          }
        }
      } catch (e) {
        _logger.error(e);
        if (!isClosed) {
          emit(
            AppUpdateState.error(
              isMandatory: _desktopUpdaterUseCase.isMandatory,
            ),
          );
        }
      }
    } else {
      emit(const AppUpdateState.downloading(progress: 0.0));
      for (double progress = 0.0; progress <= 1.0; progress += 0.1) {
        await Future.delayed(const Duration(milliseconds: 300));
        emit(AppUpdateState.downloading(progress: progress));
      }
      emit(const AppUpdateState.installing(progress: 0.0));
      for (double progress = 0.0; progress <= 1.0; progress += 0.1) {
        await Future.delayed(const Duration(milliseconds: 300));
        emit(AppUpdateState.installing(progress: progress));
      }
      emit(const AppUpdateState.restarting());
      await Future.delayed(const Duration(seconds: 2));
      produceSideEffect(const NavigateToSplash());
    }
  }

  Future<void> _navigateToNextScreen() async {
    final isAuthorized = await _authUseCase.isAuthorized();

    if (!isAuthorized) {
      produceSideEffect(NavigateToAuth());
      return;
    }

    final hasPendingAgreements = await _agreementUseCase.hasPendingAgreements();

    if (!hasPendingAgreements) {
      produceSideEffect(NavigateToHome());
      return;
    }

    produceSideEffect(NavigateToOnboarding());
  }

  Future<void> _onDownloadProgress(
    DownloadProgressEvent event,
    Emitter<AppUpdateState> emit,
  ) async {
    final isRestarting = state.maybeWhen(
      restarting: () => true,
      orElse: () => false,
    );
    if (isRestarting) return;
    emit(AppUpdateState.downloading(progress: event.progress));
  }

  Future<void> _onInstallProgress(
    InstallProgressEvent event,
    Emitter<AppUpdateState> emit,
  ) async {
    final isRestarting = state.maybeWhen(
      restarting: () => true,
      orElse: () => false,
    );
    if (isRestarting) return;
    emit(AppUpdateState.installing(progress: event.progress));
  }

  Future<void> _onUpdateCompleted(
    UpdateCompletedEvent event,
    Emitter<AppUpdateState> emit,
  ) async {
    final isRestarting = state.maybeWhen(
      restarting: () => true,
      orElse: () => false,
    );
    if (isRestarting) return;

    emit(const AppUpdateState.restarting());
    await Future.delayed(const Duration(seconds: 2));

    if ((PlatformUtils.isDesktop || Platform.isAndroid) && !isClosed) {
      if (PlatformUtils.isDesktop) {
        try {
          await _vpnManager.disableVpn();
        } catch (e) {
          _logger.error(e);
        }
      }

      await _desktopUpdaterUseCase.restartApp();

      // On desktop the hand-off replaces this process, so control never comes
      // back here. Still running means the installer never took over — say so
      // instead of parking the UI on "Restarting Zenshield" forever.
      //
      // macOS is the one platform that returns before it is gone, because
      // NSApplication.terminate() is asynchronous — wait out the shutdown so a
      // successful hand-off is never mistaken for a failed one.
      await Future.delayed(const Duration(seconds: 3));

      if (PlatformUtils.isDesktop && !isClosed && !emit.isDone) {
        _logger.error(
          '[AppUpdate] restartApp() returned without restarting — the '
          'installer hand-off failed.',
        );
        emit(
          AppUpdateState.error(
            isMandatory: _desktopUpdaterUseCase.isMandatory,
            isInstallFailure: true,
          ),
        );
      }
    } else {
      produceSideEffect(const NavigateToSplash());
    }
  }

  Future<void> _onDownloadFailed(
    DownloadFailedEvent event,
    Emitter<AppUpdateState> emit,
  ) async {
    emit(
      AppUpdateState.error(
        isMandatory: _desktopUpdaterUseCase.isMandatory,
        isInstallFailure: _desktopUpdaterUseCase.isInstallFailure,
      ),
    );
  }

  Future<void> _onRetryUpdate(
    RetryUpdateEvent event,
    Emitter<AppUpdateState> emit,
  ) async {
    if (_desktopUpdaterUseCase.needUpdate) {
      add(const StartUpdateEvent());
    } else {
      add(const CheckForUpdatesEvent());
    }
  }

  Map<String, dynamic> getDiagnostics() {
    return {
      'state': state.toString(),
      'isClosed': isClosed,
      'needUpdate': _desktopUpdaterUseCase.needUpdate,
      'isDownloading': _desktopUpdaterUseCase.isDownloading,
      'isDownloaded': _desktopUpdaterUseCase.isDownloaded,
      'downloadProgress': _desktopUpdaterUseCase.downloadProgress,
      'appVersion': _desktopUpdaterUseCase.appVersion,
      'isMandatory': _desktopUpdaterUseCase.isMandatory,
    };
  }

  Future<void> _onSkipUpdate(
    SkipUpdateEvent event,
    Emitter<AppUpdateState> emit,
  ) async {
    await _navigateToNextScreen();
  }
}
