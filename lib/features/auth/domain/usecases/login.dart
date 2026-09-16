import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:idiomatic_app/core/errors/failures.dart';
import 'package:idiomatic_app/core/usecases/usecase.dart';
import 'package:idiomatic_app/features/auth/domain/entities/user.dart';
import 'package:idiomatic_app/features/auth/domain/repositories/auth_repository.dart';

class Login implements UseCase<User, LoginParams> {
  Login(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(email: params.email, password: params.password);
  }
}

class LoginParams extends Equatable {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
