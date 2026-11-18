import 'package:equatable/equatable.dart';
import '../../../domain/entities/drama.dart';

sealed class DramaDetailState extends Equatable {
  const DramaDetailState();

  @override
  List<Object?> get props => [];
}

final class DramaDetailLoaded extends DramaDetailState {
  final Drama drama;

  const DramaDetailLoaded(this.drama);

  @override
  List<Object?> get props => [drama];
}

final class DramaDetailError extends DramaDetailState {
  final String message;

  const DramaDetailError(this.message);

  @override
  List<Object?> get props => [message];
}