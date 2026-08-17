import 'dart:async';

import 'package:zenshield/feature/user_info/data/model/user_info.dart';

abstract class AbstractUserInfoUseCase {
  Future<UserInfo> getUserInfo();
}
