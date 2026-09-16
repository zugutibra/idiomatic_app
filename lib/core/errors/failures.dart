import 'package:equatable/equatable.dart';

/// Base class for all domain-level failures. Repositories return
/// `Either<Failure, T>` instead of throwing so callers must handle errors
/// explicitly.
abstract class Failure extends Equatable {
  const Failure([this.message = 'Something went wrong']);

  final String message;

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message]);
}
