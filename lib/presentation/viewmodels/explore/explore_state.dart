import 'package:equatable/equatable.dart';
import '../../../domain/entities/drama.dart';

sealed class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object?> get props => [];
}

final class ExploreInitial extends ExploreState {
  const ExploreInitial();
}

final class ExploreLoading extends ExploreState {
  const ExploreLoading();
}

final class ExploreLoaded extends ExploreState {
  final List<Drama> dramas;
  final String selectedCategory;
  final String searchQuery;
  final List<String> categories;

  const ExploreLoaded({
    required this.dramas,
    required this.selectedCategory,
    required this.searchQuery,
    required this.categories,
  });

  @override
  List<Object?> get props => [dramas, selectedCategory, searchQuery, categories];
}

final class ExploreError extends ExploreState {
  final String message;

  const ExploreError(this.message);

  @override
  List<Object?> get props => [message];
}