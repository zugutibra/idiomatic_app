import 'package:fpdart/fpdart.dart';

import 'package:idiomatic_app/core/errors/failures.dart';
import 'package:idiomatic_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signup({
    required String email,
    required String password,
    required String displayName,
    required String nativeLanguage,
  });

  Future<Either<Failure, User>> login({required String email, required String password});

  Future<User?> currentCachedUser();

  Future<void> logout();
}
