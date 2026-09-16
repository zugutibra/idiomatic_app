import 'package:fpdart/fpdart.dart';

import 'package:idiomatic_app/core/errors/failures.dart';
import 'package:idiomatic_app/features/progress/domain/entities/progress_stats.dart';

abstract class ProgressRepository {
  Future<Either<Failure, ProgressStats>> getStats();
}
