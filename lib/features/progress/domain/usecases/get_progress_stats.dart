import 'package:fpdart/fpdart.dart';

import 'package:idiomatic_app/core/errors/failures.dart';
import 'package:idiomatic_app/core/usecases/usecase.dart';
import 'package:idiomatic_app/features/progress/domain/entities/progress_stats.dart';
import 'package:idiomatic_app/features/progress/domain/repositories/progress_repository.dart';

class GetProgressStats implements UseCase<ProgressStats, NoParams> {
  GetProgressStats(this.repository);

  final ProgressRepository repository;

  @override
  Future<Either<Failure, ProgressStats>> call(NoParams params) {
    return repository.getStats();
  }
}
