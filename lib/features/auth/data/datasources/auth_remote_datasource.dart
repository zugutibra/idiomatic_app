import 'package:dio/dio.dart';

import 'package:idiomatic_app/core/errors/exceptions.dart';
import 'package:idiomatic_app/features/auth/data/models/user_model.dart';

class AuthTokenResponse {
  const AuthTokenResponse(this.accessToken, this.user);

  final String accessToken;
  final UserModel user;
}

abstract class AuthRemoteDataSource {
  Future<AuthTokenResponse> signup({
    required String email,
    required String password,
    required String displayName,
    required String nativeLanguage,
  });

  Future<AuthTokenResponse> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this.dio);

  final Dio dio;

  @override
  Future<AuthTokenResponse> signup({
    required String email,
    required String password,
    required String displayName,
    required String nativeLanguage,
  }) async {
    try {
      final response = await dio.post('/auth/signup', data: {
        'email': email,
        'password': password,
        'display_name': displayName,
        'native_language': nativeLanguage,
      });
      return AuthTokenResponse(
        response.data['access_token'] as String,
        UserModel.fromJson(response.data['user'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ServerException(_messageFrom(e));
    }
  }

  @override
  Future<AuthTokenResponse> login({required String email, required String password}) async {
    try {
      final response = await dio.post('/auth/login', data: {'email': email, 'password': password});
      return AuthTokenResponse(
        response.data['access_token'] as String,
        UserModel.fromJson(response.data['user'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ServerException(_messageFrom(e));
    }
  }

  String _messageFrom(DioException e) {
    final detail = e.response?.data is Map ? e.response?.data['detail'] : null;
    if (detail is String) return detail;
    if (detail is List && detail.isNotEmpty) {
      final messages = detail
          .map((item) => item is Map ? item['msg']?.toString() : item.toString())
          .whereType<String>();
      if (messages.isNotEmpty) return messages.join(', ');
    }
    return e.message ?? 'Something went wrong';
  }
}
