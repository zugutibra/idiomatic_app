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
  const BrowseState({this.status = BrowseStatus.initial, this.topics = const [], this.errorMessage});

  final BrowseStatus status;
  final List<BrowseTopicVm> topics;
  final String? errorMessage;

  BrowseState copyWith({BrowseStatus? status, List<BrowseTopicVm>? topics, String? errorMessage}) {
    return BrowseState(
      status: status ?? this.status,
      topics: topics ?? this.topics,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, topics, errorMessage];
}
