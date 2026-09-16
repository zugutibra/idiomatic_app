import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:idiomatic_app/core/errors/failures.dart';
import 'package:idiomatic_app/core/usecases/usecase.dart';
import 'package:idiomatic_app/features/idioms/domain/entities/idiom.dart';
import 'package:idiomatic_app/features/idioms/domain/repositories/idiom_repository.dart';

class GetDueIdioms implements UseCase<List<Idiom>, GetDueIdiomsParams> {
  GetDueIdioms(this.repository);

  final IdiomRepository repository;

  @override
  Future<Either<Failure, List<Idiom>>> call(GetDueIdiomsParams params) {
    return repository.getDueIdioms(topic: params.topic);
  }
}

class GetDueIdiomsParams extends Equatable {
  const GetDueIdiomsParams({this.topic});

  final String? topic;

  @override
  List<Object?> get props => [topic];
}
