import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/feature/protocols/presentation/protocols_side_effect.dart';
import 'package:zenshield/feature/protocols/presentation/state/protocols_state.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

part 'protocols_event.dart';

class ProtocolsBloc extends SideEffectBloc<ProtocolsEvent, ProtocolsState,
    ProtocolsSideEffect> {
  ProtocolsBloc() : super(ProtocolsState.initial()) {
    on<SearchTextChangedEvent>(_onSearchTextChanged);
  }

  void _onSearchTextChanged(
    SearchTextChangedEvent event,
    Emitter<ProtocolsState> emit,
  ) {
    final query = event.query.trim().toLowerCase();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          filteredProtocols: state.protocols,
        ),
      );
      return;
    }

    final filteredProtocols = state.protocols.where((protocol) {
      return protocol.type.displayName.toLowerCase().contains(query);
    }).toList();

    emit(
      state.copyWith(
        filteredProtocols: filteredProtocols,
      ),
    );
  }
}
