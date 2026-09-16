import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:idiomatic_app/core/errors/failures.dart';
import 'package:idiomatic_app/core/usecases/usecase.dart';
import 'package:idiomatic_app/features/idioms/domain/entities/idiom.dart';
import 'package:idiomatic_app/features/idioms/domain/repositories/idiom_repository.dart';

class GetIdioms implements UseCase<List<Idiom>, GetIdiomsParams> {
  GetIdioms(this.repository);

  final IdiomRepository repository;

  @override
  Future<Either<Failure, List<Idiom>>> call(GetIdiomsParams params) {
    return repository.listIdioms(topic: params.topic);
  }
}

class GetIdiomsParams extends Equatable {
  const GetIdiomsParams({this.topic});

  final String? topic;

  @override
  List<Object?> get props => [topic];
}
