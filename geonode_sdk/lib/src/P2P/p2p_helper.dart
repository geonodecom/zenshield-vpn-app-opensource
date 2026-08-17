import 'dart:io';
import 'dart:typed_data';

import 'package:dart_peer_repo/src/shared/global.dart';

class P2PHelper {
  closeSocket(RawSocket socket, String socketName) async {
    if (getIsDebug) {
      logPrint('close socket $socketName');
    }
    socket.close();
  }

  bool isSocketWriteSuccessful(List<int> buffer, int count) {
    return buffer.length == count;
  }

  int writeToSocket(RawSocket socket, Uint8List data, String socketName) {
    _logSocketData('SEND', socketName, data);

    if (getIsDebug) {
      logPrint('writing to $socketName, data count ${data.length}');
    }

    try {
      int bytesWritten = socket.write(data);
      print(
          '[GeoNode Status] Socket $socketName: sent ${data.length} bytes, written: $bytesWritten');
      return bytesWritten;
    } catch (e) {
      print(
          '[GeoNode Status] Socket $socketName: ERROR writing ${data.length} bytes - $e');
      if (getIsDebug) {
        logPrint('error writing to socket => $socketName => $e');
      }
      return 0;
    } finally {}
  }

  void _logSocketData(String direction, String socketName, Uint8List data) {
    try {
      String textData;
      try {
        textData = String.fromCharCodes(data);
        textData = textData
            .replaceAll('\x00', '\\0')
            .replaceAll('\n', '\\n')
            .replaceAll('\r', '\\r')
            .replaceAll('\t', '\\t');

        if (textData.length > 200) {
          textData = textData.substring(0, 200) + '...';
        }
      } catch (e) {
        textData = '<binary data: ${data.length} bytes>';
      }

      print(
          '[GeoNode Status] $direction $socketName: "$textData" (${data.length} bytes)');
    } catch (e) {
      print(
          '[GeoNode Status] $direction $socketName: <error logging data> (${data.length} bytes)');
    }
  }
}
