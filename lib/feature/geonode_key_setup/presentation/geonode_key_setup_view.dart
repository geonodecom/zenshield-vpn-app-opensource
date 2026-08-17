import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zenshield/core/managers/geonode_sdk_manager.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/feature/home/presentation/home_view.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';

/// Shown once bandwidth sharing is accepted, only when the build doesn't
/// already ship its own GEONODE_API_KEY / platform app ID — lets a
/// self-hosted build supply its own Geonode SDK credentials at runtime
/// instead of at compile time. See [Preferences.shouldPromptGeonodeKeySetup].
class GeonodeKeySetupView extends StatefulWidget {
  const GeonodeKeySetupView({super.key});

  static const routeName = '/geonode_key_setup';

  @override
  State<GeonodeKeySetupView> createState() => _GeonodeKeySetupViewState();
}

class _GeonodeKeySetupViewState extends State<GeonodeKeySetupView> {
  final _formKey = GlobalKey<FormState>();
  final _apiKeyController = TextEditingController();
  final _appIdController = TextEditingController();
  final _preferences = getIt<Preferences>();
  bool _isSaving = false;

  /// The env var name for the current platform's app ID/key — see the
  /// `geonode*` constants in `CommonConstants`.
  String get _appIdFieldLabel {
    if (Platform.isWindows) return 'GEONODE_SDK_API_KEY_WINDOWS';
    if (Platform.isMacOS) return 'GEONODE_SDK_API_KEY_MACOS';
    if (Platform.isIOS) return 'GEONODE_APP_ID_IOS';
    return 'GEONODE_APP_ID_ANDROID';
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _appIdController.dispose();
    super.dispose();
  }

  Future<void> _navigateHome() async {
    if (!mounted) return;
    await Navigator.of(context).pushReplacementNamed(HomeView.routeName);
  }

  Future<void> _onSkip() async {
    await _preferences.setGeonodeKeysLastDeclinedDate(
      Preferences.todayDateString(),
    );
    await _navigateHome();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    await _preferences.setGeonodeApiKeyOverride(_apiKeyController.text.trim());
    await _preferences.setGeonodeAppIdOverride(_appIdController.text.trim());

    final authUseCase = getIt<AbstractAuthUserUseCase>();
    if (await authUseCase.isAuthorized()) {
      final userId = await authUseCase.getUserId();
      if (userId != null && userId.isNotEmpty) {
        await getIt<AbstractGeonodeSdkManager>().connectForUser(userId);
      }
    }

    await _navigateHome();
  }

  InputDecoration _fieldDecoration(AppColors appColors, String label) {
    final radius = BorderRadius.circular(24);
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: appColors.background,
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: appColors.grayUltraLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: appColors.grayUltraLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: appColors.black, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: appColors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();

    return Scaffold(
      backgroundColor: appColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 32),
                      Center(
                        child: Container(
                          width: 76,
                          height: 76,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: appColors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Assets.images.appLogo.image(
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Geonode SDK Setup',
                        textAlign: TextAlign.center,
                        style: appTextStyles
                            .helveticaNeueBold24(color: appColors.black)
                            .copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Enter your Geonode API key and app ID to enable '
                        'bandwidth sharing.',
                        textAlign: TextAlign.center,
                        style: appTextStyles
                            .interRegular14(color: appColors.grayLight)
                            .copyWith(fontSize: 13),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _apiKeyController,
                        style: appTextStyles.interRegular14(
                          color: appColors.black,
                        ),
                        decoration: _fieldDecoration(
                          appColors,
                          'GEONODE_API_KEY',
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? 'Required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _appIdController,
                        style: appTextStyles.interRegular14(
                          color: appColors.black,
                        ),
                        decoration: _fieldDecoration(
                          appColors,
                          _appIdFieldLabel,
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? 'Required'
                            : null,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 57,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(29),
                      ),
                      elevation: 0,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Save',
                            style: appTextStyles.nunitoSansBold18(
                              color: appColors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _isSaving ? null : _onSkip,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Skip for now',
                      textAlign: TextAlign.center,
                      style: appTextStyles.interMedium14(
                        color: appColors.grayLight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
