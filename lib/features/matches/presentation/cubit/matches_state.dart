import 'package:equatable/equatable.dart';
import 'package:skillswap/core/models/match_model.dart';

enum MatchesStatus { initial, loading, success, error }

class MatchesState extends Equatable {
  final MatchesStatus status;
  final List<MatchModel> matches;
  final String searchQuery;
  final String? filterCategory;
  final String? errorMessage;

  const MatchesState({
    this.status = MatchesStatus.initial,
    this.matches = const [],
    this.searchQuery = '',
    this.filterCategory,
    this.errorMessage,
  });

  List<MatchModel> get filteredMatches {
    final query = searchQuery.trim().toLowerCase();
    return matches.where((match) {
      final matchesQuery = query.isEmpty ||
          match.partnerName.toLowerCase().contains(query) ||
          match.partnerSkill.toLowerCase().contains(query) ||
          match.skillsExchanged.any((s) => s.toLowerCase().contains(query));

      final matchesFilter = filterCategory == null ||
          filterCategory == 'All' ||
          match.skillsExchanged.any((s) => s.toLowerCase().contains(filterCategory!.toLowerCase())) ||
          match.partnerSkill.toLowerCase().contains(filterCategory!.toLowerCase());

      return matchesQuery && matchesFilter;
    }).toList();
  }

  MatchesState copyWith({
    MatchesStatus? status,
    List<MatchModel>? matches,
    String? searchQuery,
    String? filterCategory,
    String? errorMessage,
  }) {
    return MatchesState(
      status: status ?? this.status,
      matches: matches ?? this.matches,
      searchQuery: searchQuery ?? this.searchQuery,
      filterCategory: filterCategory ?? this.filterCategory,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        matches,
        searchQuery,
        filterCategory,
        errorMessage,
      ];
}
