import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:idiomatic_app/core/network/api_config.dart';
import 'package:idiomatic_app/core/storage/token_storage.dart';

/// Builds the shared Dio instance: base URL + a JWT-attaching interceptor.
class DioClient {
  DioClient(this._tokenStorage) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        contentType: 'application/json',
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.readToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint(
            '[HTTP] ${response.requestOptions.method} '
            '${response.requestOptions.uri} -> ${response.statusCode}\n'
            '${response.data}',
          );
          handler.next(response);
        },
        onError: (error, handler) {
          debugPrint(
            '[HTTP] ${error.requestOptions.method} '
            '${error.requestOptions.uri} -> ${error.response?.statusCode}\n'
            '${error.response?.data ?? error.message}',
          );
          handler.next(error);
        },
      ),
    );
  }

  final TokenStorage _tokenStorage;
  late final Dio dio;
}
