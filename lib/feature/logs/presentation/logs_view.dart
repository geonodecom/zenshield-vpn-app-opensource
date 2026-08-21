import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/feature/logs/presentation/logs_bloc.dart';
import 'package:zenshield/feature/logs/presentation/state/logs_state.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';

class LogsView extends StatelessWidget {
  const LogsView({super.key});

  static const routeName = '/logs';

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();

    return BlocProvider(
      create: (context) => LogsBloc(),
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

        return Center(
          child: Text(
            'No logs found',
            style: appTextStyles.interRegular16(
              color: appColors.grayLighter,
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
        ],
      ),
    );
  }
}
