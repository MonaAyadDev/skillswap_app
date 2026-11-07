import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillswap/features/matches/data/matches_repository.dart';
import 'matches_state.dart';

class MatchesCubit extends Cubit<MatchesState> {
  final MatchesRepository _repository;
  StreamSubscription? _subscription;

  MatchesCubit(this._repository) : super(const MatchesState()) {
    loadMatches();
  }

  void loadMatches() {
    emit(state.copyWith(status: MatchesStatus.loading));
    _subscription?.cancel();
    _subscription = _repository.getMatches().listen(
      (matches) {
        emit(state.copyWith(
          status: MatchesStatus.success,
          matches: matches,
        ));
      },
      onError: (err) {
        emit(state.copyWith(
          status: MatchesStatus.error,
          errorMessage: err.toString(),
        ));
      },
    );
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setFilterCategory(String? category) {
    emit(state.copyWith(filterCategory: category));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
