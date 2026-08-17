part of 'servers_bloc.dart';

sealed class ServersEvent {
  const ServersEvent();

  List<Object?> get props => [];
}

class InitialEvent extends ServersEvent {
  const InitialEvent();

  @override
  List<Object?> get props => [];
}

class ServerSelectedEvent extends ServersEvent {
  const ServerSelectedEvent(
    this.currentServerId,
    this.currentCountryCode,
    this.connectionStatus,
    this.server,
  );

  final String? currentServerId;
  final String? currentCountryCode;
  final ConnectionStatus connectionStatus;
  final VpnConfiguration server;

  @override
  List<Object?> get props => [
        currentServerId,
        currentCountryCode,
        connectionStatus,
        server,
      ];
}

/// User tapped "Auto select" — give up any manually pinned country and let
/// the tunnel pick the best server across all countries again.
class AutoSelectRequestedEvent extends ServersEvent {
  const AutoSelectRequestedEvent();

  @override
  List<Object?> get props => [];
}

class SearchTextChangedEvent extends ServersEvent {
  const SearchTextChangedEvent(this.searchText);
  final String searchText;

  @override
  List<Object?> get props => [searchText];
}
