part of 'matches_cubit.dart';

sealed class MatchesState extends Equatable {
  const MatchesState();

  @override
  List<Object> get props => [];
}

final class MatchesInitial extends MatchesState {}

final class MatchesLoading extends MatchesState {}

final class MatchesSuccess extends MatchesState {
  const MatchesSuccess(this.items);
  final List<MatchItem> items;

  @override
  List<Object> get props => [items];
}

final class MatchesError extends MatchesState {
  const MatchesError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
