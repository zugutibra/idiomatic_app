import 'package:equatable/equatable.dart';

import 'package:idiomatic_app/features/progress/domain/entities/progress_stats.dart';

enum ProgressStatus { initial, loading, loaded, error }

class ProgressCubitState extends Equatable {
  const ProgressCubitState({this.status = ProgressStatus.initial, this.stats, this.errorMessage});

  final ProgressStatus status;
  final ProgressStats? stats;
  final String? errorMessage;

  ProgressCubitState copyWith({ProgressStatus? status, ProgressStats? stats, String? errorMessage}) {
    return ProgressCubitState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, stats, errorMessage];
}
