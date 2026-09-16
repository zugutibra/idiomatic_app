import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:idiomatic_app/core/usecases/usecase.dart';
import 'package:idiomatic_app/features/idioms/domain/entities/topic.dart';
import 'package:idiomatic_app/features/idioms/domain/usecases/get_idioms.dart';
import 'package:idiomatic_app/features/idioms/presentation/bloc/browse_state.dart';
import 'package:idiomatic_app/features/progress/domain/usecases/get_progress_stats.dart';

class BrowseCubit extends Cubit<BrowseState> {
  BrowseCubit({required this._getIdioms, required this._getProgressStats})
    : super(const BrowseState());

  final GetIdioms _getIdioms;
  final GetProgressStats _getProgressStats;

  Future<void> load() async {
    // If we already have data on screen, refresh silently in the background
    // instead of blanking the page out with a spinner.
    if (state.status == BrowseStatus.loaded) {
      emit(state.copyWith(isRefreshing: true));
    } else {
      emit(state.copyWith(status: BrowseStatus.loading));
    }

    final idiomsResult = await _getIdioms(const GetIdiomsParams());
    final statsResult = await _getProgressStats(const NoParams());

    final counts = <String, int>{};
    idiomsResult.match((_) {}, (idioms) {
      for (final idiom in idioms) {
        counts[idiom.topic] = (counts[idiom.topic] ?? 0) + 1;
      }
    });

    final pctByTopic = <String, int>{};
    statsResult.match((_) {}, (stats) {
      for (final t in stats.topics) {
        pctByTopic[t.topic] = t.pct;
      }
    });

    final topics = TopicDef.all
        .where((t) => (counts[t.id] ?? 0) > 0)
        .map(
          (t) => BrowseTopicVm(
            id: t.id,
            label: t.label,
            count: counts[t.id] ?? 0,
            pct: pctByTopic[t.id] ?? 0,
          ),
        )
        .toList();

    emit(state.copyWith(status: BrowseStatus.loaded, topics: topics, isRefreshing: false));
  }
}
