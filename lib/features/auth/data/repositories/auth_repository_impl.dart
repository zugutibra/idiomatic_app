import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';

import 'package:idiomatic_app/core/errors/exceptions.dart';
import 'package:idiomatic_app/core/errors/failures.dart';
import 'package:idiomatic_app/core/storage/token_storage.dart';
import 'package:idiomatic_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:idiomatic_app/features/auth/data/models/user_model.dart';
import 'package:idiomatic_app/features/auth/domain/entities/user.dart';
import 'package:idiomatic_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
    required this._secureStorage,
  });

  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;
  final FlutterSecureStorage _secureStorage;

  static const _userKey = 'cached_user';

  @override
  Future<Either<Failure, User>> signup({
    required String email,
    required String password,
    required String displayName,
    required String nativeLanguage,
  }) async {
    try {
      final result = await remoteDataSource.signup(
        email: email,
        password: password,
        displayName: displayName,
        nativeLanguage: nativeLanguage,
      );
      await _persist(result);
      return Right(result.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.login(
        email: email,
        password: password,
      );
      await _persist(result);
      return Right(result.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  Future<void> _persist(AuthTokenResponse result) async {
    await tokenStorage.saveToken(result.accessToken);
    await _secureStorage.write(
      key: _userKey,
      value: jsonEncode({
        'id': result.user.id,
        'email': result.user.email,
        'display_name': result.user.displayName,
        'native_language': result.user.nativeLanguage,
      }),
    );
  }

  @override
  Future<User?> currentCachedUser() async {
    final raw = await _secureStorage.read(key: _userKey);
    if (raw == null) return null;
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> logout() async {
    await tokenStorage.clearToken();
    await _secureStorage.delete(key: _userKey);
  }
}
