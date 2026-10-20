import 'package:skillswap/core/models/match_model.dart';
import 'package:skillswap/core/models/user_model.dart';

class MatchItem {
  final MatchModel match;
  final UserModel other;

  MatchItem(this.match, this.other);
}
