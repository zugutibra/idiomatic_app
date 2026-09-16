import 'package:fpdart/fpdart.dart';

import 'package:idiomatic_app/core/errors/exceptions.dart';
import 'package:idiomatic_app/core/errors/failures.dart';
import 'package:idiomatic_app/features/progress/data/datasources/progress_remote_datasource.dart';
import 'package:idiomatic_app/features/progress/domain/entities/progress_stats.dart';
import 'package:idiomatic_app/features/progress/domain/repositories/progress_repository.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  ProgressRepositoryImpl(this.remoteDataSource);

  final ProgressRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, ProgressStats>> getStats() async {
    try {
      return Right(await remoteDataSource.getStats());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
