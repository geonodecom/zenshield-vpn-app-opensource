import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class AbstractLoginErrorMessageUseCase {
  String getShortMessage(Object error);
}

@LazySingleton(as: AbstractLoginErrorMessageUseCase)
class LoginErrorMessageUseCase implements AbstractLoginErrorMessageUseCase {
  @override
  String getShortMessage(Object error) {
    if (error is DioException) {
      final status = error.response?.statusCode;
      final serverData = error.response?.data;
      final message = error.message;

      if (serverData is Map<String, dynamic>) {
        final errorObj = serverData['error'];
        if (errorObj is Map<String, dynamic>) {
          final code = errorObj['code']?.toString();
          final data = errorObj['data']?.toString();
          final desc = errorObj['desc']?.toString();
          final picked = data ?? desc ?? code;
          if (picked != null && picked.trim().isNotEmpty) {
            return status != null ? 'http_$status:$picked' : picked;
          }
        }
      }

      if (message != null && message.trim().isNotEmpty) {
        return status != null ? 'http_$status:$message' : message;
      }

      return status != null ? 'http_$status' : error.type.name;
    }

    final raw = error.toString().trim();
    return raw.isEmpty ? 'unknown_error' : raw;
  }
}
