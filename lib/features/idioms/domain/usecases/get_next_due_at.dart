import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:idiomatic_app/core/errors/failures.dart';
import 'package:idiomatic_app/core/usecases/usecase.dart';
import 'package:idiomatic_app/features/idioms/domain/repositories/idiom_repository.dart';

class GetNextDueAt implements UseCase<DateTime?, GetNextDueAtParams> {
  GetNextDueAt(this.repository);

  final IdiomRepository repository;

  @override
  Future<Either<Failure, DateTime?>> call(GetNextDueAtParams params) {
    return repository.getNextDueAt(topic: params.topic);
  }
}

class GetNextDueAtParams extends Equatable {
  const GetNextDueAtParams({this.topic});

  final String? topic;

  @override
  List<Object?> get props => [topic];
}
