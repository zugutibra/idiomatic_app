import 'package:equatable/equatable.dart';

class BrowseTopicVm extends Equatable {
  const BrowseTopicVm({required this.id, required this.label, required this.count, required this.pct});

  final String id;
  final String label;
  final int count;
  final int pct;

  @override
  List<Object?> get props => [id, label, count, pct];
}

enum BrowseStatus { initial, loading, loaded, error }

class BrowseState extends Equatable {
  const BrowseState({
    this.status = BrowseStatus.initial,
    this.topics = const [],
    this.errorMessage,
    this.isRefreshing = false,
  });

  final BrowseStatus status;
  final List<BrowseTopicVm> topics;
  final String? errorMessage;

  /// True while a background reload is in flight and there's already data
  /// on screen — the UI should keep showing [topics] instead of a spinner.
  final bool isRefreshing;

  BrowseState copyWith({
    BrowseStatus? status,
    List<BrowseTopicVm>? topics,
    String? errorMessage,
    bool? isRefreshing,
  }) {
    return BrowseState(
      status: status ?? this.status,
      topics: topics ?? this.topics,
      errorMessage: errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [status, topics, errorMessage, isRefreshing];
}
