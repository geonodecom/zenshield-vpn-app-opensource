import 'dart:io';

List<int> toBufArr(String addr) {
  List<int> bufArr = List<int>.filled(16, 0);
  if (!isIPv6(addr)) return bufArr;

  int index = 0;
  int dColonIndex = -1;
  int ipv4Index = -1;
  String groupStr = '';

  for (int i = 0; i < addr.length; i++) {
    if (addr.codeUnitAt(i) == 58) {
      // 58 is ':'
      if (groupStr.isNotEmpty) {
        int byte2 = int.parse(groupStr, radix: 16);
        bufArr[index++] = byte2 >> 8;
        bufArr[index++] = byte2 & 0xff;
        groupStr = '';
      }

      if (addr.codeUnitAt(i + 1) == 58) {
        dColonIndex = index;
        i++;
      }
    } else if (addr.codeUnitAt(i) == 46) {
      // 46 is '.'
      if (ipv4Index == -1) ipv4Index = index;
      if (groupStr.isNotEmpty) {
        int byte1 = int.parse(groupStr);
        bufArr[index++] = byte1;
        groupStr = '';
      }
    } else {
      groupStr += addr[i];
    }
  }

  if (groupStr.isNotEmpty) {
    if (ipv4Index > -1) {
      int byte1 = int.parse(groupStr);
      bufArr[index++] = byte1;
    } else {
      int byte2 = int.parse(groupStr, radix: 16);
      bufArr[index++] = byte2 >> 8;
      bufArr[index++] = byte2 & 0xff;
    }
    groupStr = '';
  }

  if (dColonIndex > -1) {
    int offset = 16 - index;
    for (int i = index - 1; i >= dColonIndex; i--) {
      bufArr[i + offset] = bufArr[i];
      bufArr[i] = 0x00;
    }
  }

  return bufArr;
}

bool isIPv6(String addr) {
  try {
    InternetAddress address = InternetAddress(addr);
    return address.type == InternetAddressType.IPv6;
  } catch (e) {
    return false;
  }
}

String toStr(List<int> buf) {
  assert(buf.length == 16);

  List<String> dwArr = [];
  for (int i = 0; i < 16; i += 2) {
    int dw = (buf[i] << 8) | buf[i + 1];
    dwArr.add(dw.toRadixString(16));
  }
  return dwArr.join(':');
}
