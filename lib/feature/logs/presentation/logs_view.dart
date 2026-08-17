import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/core/managers/geonode_curl_log_manager.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/feature/logs/presentation/logs_bloc.dart';
import 'package:zenshield/feature/logs/presentation/state/logs_state.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';
import 'package:talker_flutter/talker_flutter.dart';

class LogsView extends StatelessWidget {
  const LogsView({super.key});

  static const routeName = '/logs';

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();

    return BlocProvider(
      create: (context) => LogsBloc(
        logger: getIt<Talker>(),
        geonodeCurlLogManager: getIt<GeonodeCurlLogManager>(),
      ),
      child: Scaffold(
        backgroundColor: appColors.white,
        body: SafeArea(
          child: Column(
            children: [
              _Header(),
              Expanded(
                child: _LogsContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogsContent extends StatelessWidget {
  const _LogsContent();

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();

    return BlocBuilder<LogsBloc, LogsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final curlLog = state.curlLog;

        if (curlLog == null || curlLog.isEmpty) {
          return Center(
            child: Text(
              'No curl log found',
              style: appTextStyles.interRegular16(
                color: appColors.grayLighter,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: SelectableText(
              curlLog,
              style: appTextStyles.interRegular14(
                color: appColors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final logsBloc = context.watch<LogsBloc>();
    final logsState = logsBloc.state;
    final hasCurlLog =
        logsState.curlLog != null && logsState.curlLog!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Assets.images.chevronLeft.image(
                width: 24,
                height: 24,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Logs',
              style: appTextStyles.interSemiBold16(
                color: appColors.black,
              ),
            ),
          ),
          if (hasCurlLog)
            GestureDetector(
              onTap: () {
                final curlLog = logsState.curlLog!;
                Clipboard.setData(ClipboardData(text: curlLog));
              },
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(
                  Icons.copy,
                  size: 24,
                  color: appColors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
