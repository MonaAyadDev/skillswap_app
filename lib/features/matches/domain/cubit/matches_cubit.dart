import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:skillswap/core/models/match_model.dart';
import 'package:skillswap/features/matches/data/matches_repo.dart';
import 'package:skillswap/features/matches/data/models/matchItem_model.dart';

part 'matches_state.dart';

class MatchesCubit extends Cubit<MatchesState> {
  MatchesCubit(this.matchesRepository) : super(MatchesInitial());

  final MatchesRepository matchesRepository;
  StreamSubscription<List<MatchModel>>? _sub;

  void watchMatches() {
    emit(MatchesLoading());

    final myId = FirebaseAuth.instance.currentUser!.uid;

    _sub?.cancel();
    _sub = matchesRepository.watchMatches().listen((matches) async {
      final items = <MatchItem>[];

      for (final match in matches) {
        final otherId = match.userIds.firstWhere((id) => id != myId);

        final other = await matchesRepository.getUser(otherId);

        if (other != null) items.add(MatchItem(match, other));
      }

      emit(MatchesSuccess(items));
    }, onError: (e) => emit(MatchesError(e.toString())));
  }
}
