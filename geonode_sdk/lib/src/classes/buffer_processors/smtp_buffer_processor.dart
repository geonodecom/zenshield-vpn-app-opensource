// ignore_for_file: non_constant_identifier_names, overridden_fields

import 'dart:typed_data';
import 'package:dart_peer_repo/src/classes/buffer_processors/buffer_processor.dart';
import 'package:dart_peer_repo/src/shared/global.dart';

class SmtpBufferProcessor extends BufferProcessor {
  String _buffer = '';
  @override
  final int MAX_BUFFER_SIZE = 10 * 1024 * 1024; // 10 MB
  bool _active = true;

  @override
  void concat(List<int> data) {
    if (data.isEmpty) return;
    _buffer += String.fromCharCodes(data);

    if (_buffer.length > MAX_BUFFER_SIZE) {
      if (getIsDebug) {
        logPrint('SmtpBufferProcessor size exceeds maximum allowed size');
      }
      resetBuffer();
      return;
    }
  }

  /// Stops the processing.
  void stop() {
    _active = false;
  }

  @override
  void process(void Function(Uint8List message) callback) {
    int offset = 0;
    int bufferLength = _buffer.length;

    while (offset < bufferLength && _active) {
      int crlfIndex = _buffer.indexOf('\r\n', offset);
      if (crlfIndex == -1) break;

      String line = _buffer.substring(offset, crlfIndex);
      offset = crlfIndex + 2; // Skip past '\r\n'

      if (isEndOfResponse(line)) {
        String message = _buffer.substring(0, offset);
        // convert message.codeUnits to Uint8List
        Uint8List messageUint8List = Uint8List.fromList(message.codeUnits);
        callback(messageUint8List);
        _buffer = _buffer.substring(offset);
        offset = 0;
        bufferLength = _buffer.length;
      }
    }

    // Trim processed data from the buffer
    if (offset > 0) {
      _buffer = _buffer.substring(offset);
    }
  }

  @override
  void resetBuffer() {
    _buffer = '';
  }

  @override
  void flush(void Function(Uint8List segment) callback) {
    if (_buffer.isEmpty) return;

    Uint8List remaining = Uint8List.fromList(_buffer.codeUnits);
    callback(remaining);
    resetBuffer();
  }

  /// Determines if the line indicates the end of an SMTP response.
  bool isEndOfResponse(String line) {
    RegExp responseCodePattern = RegExp(r'^(\d{3})(\s|-)');
    Match? responseCodeMatch = responseCodePattern.firstMatch(line);
    if (responseCodeMatch != null) {
      String separator = responseCodeMatch.group(2)!;
      return separator == ' ';
    }
    return true;
  }
}
