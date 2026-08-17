// ignore_for_file: non_constant_identifier_names, overridden_fields

import 'dart:typed_data';
import 'package:dart_peer_repo/src/classes/buffer_processors/buffer_processor.dart';
import 'package:dart_peer_repo/src/shared/global.dart';

class HttpsBufferProcessor extends BufferProcessor {
  List<Uint8List> buffers = [];
  int totalLength = 0;
  final int HEADER_LENGTH = 5;
  final int MAX_RECORD_LENGTH = 16384 + 2048;
  @override
  final int MAX_BUFFER_SIZE = 10 * 1024 * 1024;

  @override
  void concat(Uint8List? data) {
    if (data == null) return;
    totalLength += data.length;
    if (totalLength > MAX_BUFFER_SIZE) {
      if (getIsDebug) {
        logPrint('HttpsBuffer size exceeds maximum allowed size');
      }
      resetBuffer();
      return;
    }
    buffers.add(data);
  }

  @override
  void process(void Function(Uint8List record) callback) {
    Uint8List buffer = Uint8List(totalLength);
    int pos = 0;
    for (var b in buffers) {
      buffer.setRange(pos, pos + b.length, b);
      pos += b.length;
    }
    int offset = 0;

    while (buffer.length - offset >= HEADER_LENGTH) {
      var header = readRecordHeader(buffer, offset);
      if (header == null) break;

      if ((header['length'] ?? -1) > MAX_RECORD_LENGTH) {
        if (getIsDebug) {
          logPrint('Record length exceeds maximum allowed size');
        }
        resetBuffer();
        return;
      }

      int totalRecordLength = HEADER_LENGTH + (header['length'] ?? -1);
      if (buffer.length - offset < totalRecordLength) break;

      Uint8List record = buffer.sublist(offset, offset + totalRecordLength);
      offset += totalRecordLength;

      callback(record);
    }

    if (offset > 0) {
      Uint8List remainingData = buffer.sublist(offset);
      buffers = [remainingData];
      totalLength = remainingData.length;
    } else {
      buffers = [buffer];
      totalLength = buffer.length;
    }
  }

  @override
  void resetBuffer() {
    buffers.clear();
    totalLength = 0;
  }

  @override
  void flush(void Function(Uint8List segment) callback) {
    if (totalLength == 0) return;

    Uint8List buffer = Uint8List(totalLength);
    int pos = 0;
    for (var b in buffers) {
      buffer.setRange(pos, pos + b.length, b);
      pos += b.length;
    }

    if (buffer.isNotEmpty) {
      callback(buffer);
    }

    resetBuffer();
  }

  Map<String, int>? readRecordHeader(Uint8List? buffer, int offset) {
    if (buffer == null) return null;
    if (buffer.length - offset < HEADER_LENGTH) return null;

    int contentType = buffer[offset];
    int version = (buffer[offset + 1] << 8) | buffer[offset + 2];
    int length = (buffer[offset + 3] << 8) | buffer[offset + 4];

    return {
      'contentType': contentType,
      'version': version,
      'length': length,
    };
  }
}
