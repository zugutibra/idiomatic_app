import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:idiomatic_app/core/errors/failures.dart';

/// Base contract every use case implements: given [Params], produce a
/// `Type` or a [Failure].
abstract class UseCase<ReturnType, Params> {
  Future<Either<Failure, ReturnType>> call(Params params);
}

/// Marker type for use cases that take no parameters.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object> get props => [];
}
