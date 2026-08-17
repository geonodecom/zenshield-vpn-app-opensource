import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenshield/core/models/protocols.dart';

part 'protocol.freezed.dart';

@freezed
class Protocol with _$Protocol {
  const factory Protocol({
    required Protocols type,
    required bool isBest,
    required bool isSelected,
    required bool isAvailable,
  }) = _Protocol;
}
