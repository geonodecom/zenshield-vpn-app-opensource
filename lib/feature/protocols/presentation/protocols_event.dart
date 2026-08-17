part of 'protocols_bloc.dart';

sealed class ProtocolsEvent {
  const ProtocolsEvent();

  List<Object> get props => [];
}

class SearchTextChangedEvent extends ProtocolsEvent {
  const SearchTextChangedEvent(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}
