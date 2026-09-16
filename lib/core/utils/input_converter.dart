import 'package:fpdart/fpdart.dart';

import 'package:idiomatic_app/core/errors/failures.dart';

/// Example shared utility: parses a string into a non-negative integer,
/// returning a [Failure] instead of throwing on bad input.
class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String input) {
    try {
      final value = int.parse(input);
      if (value < 0) throw const FormatException();
      return Right(value);
    } on FormatException {
      return const Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure() : super('Invalid input: must be a non-negative integer');
}
