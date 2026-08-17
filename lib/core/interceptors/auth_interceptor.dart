import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:zenshield/core/api/api.dart';
import 'package:zenshield/config/constants/secure_storage_keys.dart';

@Injectable()
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.secureStorage});
  final FlutterSecureStorage secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path != Api.endpoints.initialize) {
      final token =
          await secureStorage.read(key: SecureStorageKeys.accessToken);

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}
