import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:zenshield/core/managers/analytics_events.dart';
import 'package:zenshield/core/managers/analytics_manager.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/l10n/app_localizations.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';
import 'package:zenshield/feature/protocols/data/model/protocol/protocol.dart';
import 'package:zenshield/core/models/protocols.dart';
import 'package:zenshield/feature/app/presentation/app_bloc.dart';
import 'package:zenshield/feature/protocols/presentation/protocols_bloc.dart';
import 'package:zenshield/core/utils/mixins.dart';

class ProtocolsView extends StatefulWidget {
  const ProtocolsView({super.key});

  static const String routeName = '/protocols';

  @override
  State<ProtocolsView> createState() => _ProtocolsViewState();

  static Future<T?> show<T>(BuildContext context) {
    final analyticsManager = getIt<AbstractAnalyticsManager>();
    analyticsManager.sendEvent(AnalyticsEventNames.app_opened, null);

    return showCupertinoModalBottomSheet<T>(
      context: context,
      topRadius: const Radius.circular(28),
      clipBehavior: Clip.antiAlias,
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: const ProtocolsView(),
      ),
    );
  }
}

class _ProtocolsViewState extends State<ProtocolsView> {
  late final ProtocolsBloc _protocolsBloc;

  @override
  void initState() {
    super.initState();
    _protocolsBloc = ProtocolsBloc();
  }

  @override
  void dispose() {
    _protocolsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBloc = context.read<AppBloc>();

    return BlocProvider.value(
      value: _protocolsBloc,
      child: BlocProvider.value(
        value: appBloc,
        child: _ProtocolsModalContent(),
      ),
    );
  }
}

class _ProtocolsModalContent extends StatefulWidget {
  const _ProtocolsModalContent();

  @override
  State<_ProtocolsModalContent> createState() => _ProtocolsModalContentState();
}

class _ProtocolsModalContentState extends State<_ProtocolsModalContent>
    with AnalyticsEventSender {
  @override
  AbstractAnalyticsManager get analyticsManager =>
      getIt<AbstractAnalyticsManager>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();

    final appBloc = context.read<AppBloc>();
    final appState = appBloc.state;
    final currentProtocol = appState.protocol;
    final protocolsBloc = context.watch<ProtocolsBloc>();
    final protocols = protocolsBloc.state.filteredProtocols;

    return Material(
      color: appColors.white,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: appColors.grayUltraLight,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n?.settingsVPNProtocolSelection ?? 'VPN Protocol',
                      style: appTextStyles
                          .interSemiBold16(color: appColors.black)
                          .copyWith(fontSize: 18),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: appColors.grayBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: appColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: protocols.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final protocol = protocols[index];
                  final isSelected = protocol.type == currentProtocol;

                  return _ProtocolTile(
                    title: _protocolTitle(protocol: protocol, l10n: l10n),
                    icon: _protocolIcon(protocol.type),
                    isSelected: isSelected,
                    isRecommended: protocol.isBest,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      sendAnalyticsEvent(
                        AnalyticsEventNames.protocol_changed,
                        protocol.type.name.asAnalyticsParam('protocol'),
                      );
                      appBloc.add(SelectProtocolEvent(protocol.type));
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _protocolIcon(Protocols type) {
    switch (type) {
      case Protocols.auto:
        return Icons.bolt_rounded;
      case Protocols.wireguard:
        return Icons.vpn_key_rounded;
      case Protocols.vless:
      case Protocols.vmess:
      case Protocols.trojan:
      case Protocols.shadowsocks:
        return Icons.security_rounded;
    }
  }

  String _protocolTitle({
    required Protocol protocol,
    required AppLocalizations? l10n,
  }) {
    return protocol.type == Protocols.auto
        ? (l10n?.settingsVPNProtocolAutomatic ?? 'Automatic')
        : protocol.type.displayName;
  }
}

class _ProtocolTile extends StatelessWidget {
  const _ProtocolTile({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.isRecommended,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final bool isRecommended;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? appColors.black : appColors.background,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? appColors.black : appColors.grayUltraLight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.12)
                    : appColors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? appColors.white : appColors.black,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: appTextStyles.interSemiBold16(
                        color: isSelected ? appColors.white : appColors.black,
                      ),
                    ),
                  ),
                  if (isRecommended) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.15)
                            : appColors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Recommended',
                        style: appTextStyles
                            .interRegular11(
                              color: isSelected
                                  ? appColors.white
                                  : appColors.black,
                            )
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
              size: 22,
              color: isSelected ? appColors.white : appColors.grayVeryLight,
            ),
          ],
        ),
      ),
    );
  }
}
