import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:idiomatic_app/core/errors/failures.dart';
import 'package:idiomatic_app/core/usecases/usecase.dart';
import 'package:idiomatic_app/features/auth/domain/entities/user.dart';
import 'package:idiomatic_app/features/auth/domain/repositories/auth_repository.dart';

class Signup implements UseCase<User, SignupParams> {
  Signup(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, User>> call(SignupParams params) {
    return repository.signup(
      email: params.email,
      password: params.password,
      displayName: params.displayName,
      nativeLanguage: params.nativeLanguage,
    );
  }
}

class SignupParams extends Equatable {
  const SignupParams({
    required this.email,
    required this.password,
    required this.displayName,
    required this.nativeLanguage,
  });

  final String email;
  final String password;
  final String displayName;
  final String nativeLanguage;

  @override
  List<Object> get props => [email, password, displayName, nativeLanguage];
}
