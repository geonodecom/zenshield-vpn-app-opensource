import 'dart:typed_data';

import 'package:injectable/injectable.dart';

typedef MessageHandler = void Function(Uint8List message);

@injectable
class MessageBuffer {
  var _buffer = Uint8List(0);
  int? _expectedLength;

  void addData(
    Uint8List data,
    MessageHandler onMessage,
  ) {
    _buffer = Uint8List.fromList([..._buffer, ...data]);
    while (true) {
      if (_expectedLength == null) {
        if (_buffer.length < 4) return;
        final lengthBytes = ByteData.sublistView(_buffer, 0, 4);
        _expectedLength = lengthBytes.getInt32(0, Endian.big);
        _buffer = _buffer.sublist(4);
      }
      if (_buffer.length < _expectedLength!) return;
      final message = _buffer.sublist(0, _expectedLength);
      onMessage(message);
      _buffer = _buffer.sublist(_expectedLength!);
      _expectedLength = null;
      if (_buffer.isEmpty) break;
    }
  }

  void clear() {
    _buffer = Uint8List(0);
    _expectedLength = null;
  }
}
