import 'package:equatable/equatable.dart';

import 'package:idiomatic_app/features/progress/domain/entities/progress_stats.dart';

enum ProgressStatus { initial, loading, loaded, error }

class ProgressCubitState extends Equatable {
  const ProgressCubitState({
    this.status = ProgressStatus.initial,
    this.stats,
    this.errorMessage,
    this.isRefreshing = false,
  });

  final ProgressStatus status;
  final ProgressStats? stats;
  final String? errorMessage;

  /// True while a background reload is in flight and there's already data
  /// on screen — the UI should keep showing [stats] instead of a spinner.
  final bool isRefreshing;

  ProgressCubitState copyWith({
    ProgressStatus? status,
    ProgressStats? stats,
    String? errorMessage,
    bool? isRefreshing,
  }) {
    return ProgressCubitState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      errorMessage: errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [status, stats, errorMessage, isRefreshing];
}
