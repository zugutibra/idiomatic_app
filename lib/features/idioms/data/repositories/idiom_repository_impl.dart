import 'package:fpdart/fpdart.dart';

import 'package:idiomatic_app/core/errors/exceptions.dart';
import 'package:idiomatic_app/core/errors/failures.dart';
import 'package:idiomatic_app/features/idioms/data/datasources/idiom_remote_datasource.dart';
import 'package:idiomatic_app/features/idioms/domain/entities/idiom.dart';
import 'package:idiomatic_app/features/idioms/domain/entities/review_result.dart';
import 'package:idiomatic_app/features/idioms/domain/repositories/idiom_repository.dart';
import 'package:idiomatic_app/features/quiz/domain/entities/quiz_question.dart';

class IdiomRepositoryImpl implements IdiomRepository {
  IdiomRepositoryImpl(this.remoteDataSource);

  final IdiomRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<Idiom>>> listIdioms({String? topic}) async {
    try {
      return Right(await remoteDataSource.listIdioms(topic: topic));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Idiom>>> getDueIdioms({String? topic}) async {
    try {
      return Right(await remoteDataSource.getDueIdioms(topic: topic));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, DateTime?>> getNextDueAt({String? topic}) async {
    try {
      return Right(await remoteDataSource.getNextDueAt(topic: topic));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ReviewResult>> submitReview({required int idiomId, required bool correct}) async {
    try {
      return Right(await remoteDataSource.submitReview(idiomId: idiomId, correct: correct));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, QuizQuestion>> getQuizOptions(int idiomId) async {
    try {
      return Right(await remoteDataSource.getQuizOptions(idiomId));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
