import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:idiomatic_app/core/usecases/usecase.dart';
import 'package:idiomatic_app/features/progress/domain/usecases/get_progress_stats.dart';
import 'package:idiomatic_app/features/progress/presentation/bloc/progress_state.dart';

class ProgressCubit extends Cubit<ProgressCubitState> {
  ProgressCubit(this._getProgressStats) : super(const ProgressCubitState());

  final GetProgressStats _getProgressStats;

  Future<void> load() async {
    // If we already have data on screen, refresh silently in the background
    // instead of blanking the page out with a spinner.
    if (state.status == ProgressStatus.loaded) {
      emit(state.copyWith(isRefreshing: true));
    } else {
      emit(state.copyWith(status: ProgressStatus.loading));
    }

    final result = await _getProgressStats(const NoParams());
    result.match(
      (failure) => emit(
        state.status == ProgressStatus.loaded
            // Keep showing stale data if a silent refresh fails.
            ? state.copyWith(isRefreshing: false)
            : state.copyWith(status: ProgressStatus.error, errorMessage: failure.message),
      ),
      (stats) => emit(state.copyWith(status: ProgressStatus.loaded, stats: stats, isRefreshing: false)),
    );
  }
}
