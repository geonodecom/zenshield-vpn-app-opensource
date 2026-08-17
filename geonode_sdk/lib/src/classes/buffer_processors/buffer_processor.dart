// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';

abstract class BufferProcessor {
  /// Maximum buffer size allowed for all processors
  final int MAX_BUFFER_SIZE = 10 * 1024 * 1024; // 10 MB

  /// Adds data to the processor's internal buffer
  void concat(Uint8List data);

  /// Processes the internal buffer, invoking the provided callback for each processed segment
  void process(void Function(Uint8List segment) callback);

  /// Resets the internal buffer to an empty state
  void resetBuffer();

  /// Flushes remaining data in buffer on connection close
  void flush(void Function(Uint8List segment) callback);
}
