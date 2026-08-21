import 'dart:math';

import 'package:country_picker/country_picker.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/feature/servers/data/model/vpn_configuration/vpn_configuration.dart';
import 'package:zenshield/feature/servers/data/server_grouping.dart';
import 'package:zenshield/feature/servers/domain/repositories/servers_repository.dart';
import 'package:zenshield/core/widgets/black_circular_progress_indicator.dart';
import 'package:zenshield/core/widgets/items/selectable_list_item.dart';
import 'package:zenshield/core/widgets/searchable_list.dart';
import 'package:zenshield/core/widgets/rounded_flag.dart';
import 'package:zenshield/feature/app/presentation/app_bloc.dart';
import 'package:zenshield/feature/servers/presentation/servers_bloc.dart';
import 'package:zenshield/feature/servers/presentation/servers_side_effect.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/core/utils/string_utils.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/l10n/app_localizations.dart';

class ServersView extends StatefulWidget {
  const ServersView({super.key});

  static const routeName = '/servers';

  @override
  State<ServersView> createState() => _ServersViewState();

  static Future<T?> show<T>(BuildContext context) {
    return showCupertinoModalBottomSheet<T>(
      context: context,
      topRadius: const Radius.circular(28),
      clipBehavior: Clip.antiAlias,
      builder: (context) =>
          FractionallySizedBox(heightFactor: 0.95, child: ServersView()),
    );
  }
}

class _ServersViewState extends State<ServersView> {
  late final ServersBloc _serversBloc;

  @override
  void initState() {
    super.initState();
    final appBloc = context.read<AppBloc>();
    final connectionStatus = appBloc.state.connectionStatus;
    _serversBloc = ServersBloc(
      connectionStatus: connectionStatus,
      serversRepository: getIt<AbstractServersRepository>(),
      eventBus: getIt<EventBus>(),
      logger: getIt<Talker>(),
      preferences: getIt<Preferences>(),
    );
  }

  @override
  void dispose() {
    _serversBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBloc = context.read<AppBloc>();
    return BlocProvider.value(
      value: _serversBloc,
      child: BlocProvider.value(
        value: appBloc,
        child: BlocSideEffectListener<ServersBloc, ServersSideEffect>(
          listener: (context, sideEffect) async {
            switch (sideEffect) {
              case NavigateToHome():
                Navigator.of(context).pop();
            }
          },
          child: const _ServersModalContent(),
        ),
      ),
    );
  }
}

class _ServersModalContent extends StatefulWidget {
  const _ServersModalContent();

  @override
  State<_ServersModalContent> createState() => _ServersModalContentState();
}

class _ServersModalContentState extends State<_ServersModalContent> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final serversBloc = context.watch<ServersBloc>();
    final serversState = serversBloc.state;
    final appBloc = context.watch<AppBloc>();
    final appState = appBloc.state;

    return Material(
      child: serversState.when(
        initial:
            (
              servers,
              filteredServers,
              isLoading,
              isSearchActive,
              searchQuery,
            ) => _Loading(),
        loaded:
            (
              servers,
              filteredServers,
              isLoading,
              isSearchActive,
              searchQuery,
              pinned,
            ) {
              final currentServers = serversState.isSearchActive
                  ? serversState.filteredServers
                  : serversState.servers;

              final systemServers = currentServers
                  .where((s) => s.configuration is SystemVpnConfiguration)
                  .toList();

              final serversByCountryAndCity =
                  ServerGrouping.groupByCountryAndCity(
                    systemServers
                        .map((s) => s.configuration as SystemVpnConfiguration)
                        .toList(),
                  );

              final selectedConfig = appState.selectedServer;
              final selectedCountryCode = selectedConfig?.region.countryCode;
              final selectedCity = selectedConfig is SystemVpnConfiguration
                  ? selectedConfig.city
                  : null;

              final entries = serversByCountryAndCity.entries.toList();
              final sortedEntries = [...entries]
                ..sort((a, b) {
                  final aParts = ServerGrouping.parseCountryCityKey(a.key);
                  final bParts = ServerGrouping.parseCountryCityKey(b.key);
                  final countryA =
                      CountryLocalizations.of(context)?.countryName(
                        countryCode: aParts.countryCode.toUpperCase(),
                      ) ??
                      aParts.countryCode;
                  final countryB =
                      CountryLocalizations.of(context)?.countryName(
                        countryCode: bParts.countryCode.toUpperCase(),
                      ) ??
                      bParts.countryCode;
                  final cmpCountry = countryA.toLowerCase().compareTo(
                    countryB.toLowerCase(),
                  );
                  if (cmpCountry != 0) return cmpCountry;
                  return aParts.city.toLowerCase().compareTo(
                    bParts.city.toLowerCase(),
                  );
                });

              // "Auto select" only makes sense against the full list, not a
              // search result, and only appears at the top of the list.
              final showAutoOption = !isSearchActive;
              final autoOffset = showAutoOption ? 1 : 0;

              return SearchableList(
                title: 'Servers',
                searchController: _searchController,
                searchHintText:
                    l10n?.serversSearchLocation ?? 'Search location',
                onSearchChanged: (value) {
                  serversBloc.add(SearchTextChangedEvent(value));
                },
                onClose: () => Navigator.of(context).pop(),
                itemCount: sortedEntries.length + autoOffset,
                itemBuilder: (context, index) {
                  if (showAutoOption && index == 0) {
                    return SelectableListItem(
                      icon: Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors().grayBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.bolt_rounded,
                          size: 20,
                          color: AppColors().black,
                        ),
                      ),
                      title: l10n?.serversAutoSelect ?? 'Auto select',
                      isSelected: !pinned,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        serversBloc.add(const AutoSelectRequestedEvent());
                      },
                      isShowChevron: true,
                    );
                  }
                  final entry = sortedEntries[index - autoOffset];
                  final keyParts = ServerGrouping.parseCountryCityKey(
                    entry.key,
                  );
                  final firstServer =
                      entry.value.first as SystemVpnConfiguration;
                  final countryCode = keyParts.countryCode.toLowerCase();
                  final rawCountryName =
                      CountryLocalizations.of(context)?.countryName(
                        countryCode: keyParts.countryCode.toUpperCase(),
                      ) ??
                      keyParts.countryCode;
                  final displayCountry = StringUtils.capitalizeFirst(
                    rawCountryName,
                  );
                  final displayCity = StringUtils.capitalizeFirst(
                    keyParts.city,
                  );
                  final itemName = displayCity.isEmpty
                      ? displayCountry
                      : '$displayCountry, $displayCity';
                  final flagUrl = firstServer.region.flagImage;
                  // A country only reads as "selected" while the user is
                  // pinned to it — in auto mode "Auto select" alone should
                  // show the checkmark, not this too, or the two would
                  // contradict each other.
                  final isSelected =
                      pinned &&
                      selectedCountryCode != null &&
                      selectedCountryCode.trim().toUpperCase() ==
                          keyParts.countryCode.toUpperCase() &&
                      (selectedCity ?? '').trim().toLowerCase() ==
                          keyParts.city.toLowerCase();

                  return SelectableListItem(
                    icon: RoundedFlag(
                      countryCode: countryCode,
                      flagUrl: flagUrl,
                      size: 36,
                    ),
                    title: itemName,
                    isSelected: isSelected,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      final serversInGroup = entry.value;
                      final server =
                          serversInGroup[Random().nextInt(
                            serversInGroup.length,
                          )];
                      serversBloc.add(
                        ServerSelectedEvent(
                          appState.selectedServer?.ip,
                          appState.selectedServer?.region.countryCode,
                          appState.connectionStatus,
                          server,
                        ),
                      );
                    },
                    isShowChevron: true,
                  );
                },
              );
            },
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    return Container(
      decoration: BoxDecoration(color: appColors.white),
      child: const Center(child: BlackCircularProgressIndicator()),
    );
  }
}
