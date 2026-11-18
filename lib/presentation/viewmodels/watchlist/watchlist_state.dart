import 'package:equatable/equatable.dart';
import '../../../domain/entities/drama.dart';

sealed class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

final class WatchlistInitial extends WatchlistState {
  const WatchlistInitial();
}

final class WatchlistLoading extends WatchlistState {
  const WatchlistLoading();
}

final class WatchlistLoaded extends WatchlistState {
  final List<Drama> visibleDramas;
  final String query;
  final int completedCount;
  final int watchingCount;

  const WatchlistLoaded({
    required this.visibleDramas,
    required this.query,
    required this.completedCount,
    required this.watchingCount,
  });

  @override
  List<Object?> get props => [
    visibleDramas,
    query,
    completedCount,
    watchingCount,
  ];
}

final class WatchlistError extends WatchlistState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}