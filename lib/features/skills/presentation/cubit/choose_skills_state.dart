import 'package:equatable/equatable.dart';
import 'package:skillswap/core/models/models.dart';

enum ChooseSkillsStatus { loading, ready, saving, saved, error }

class ChooseSkillsState extends Equatable {
  final ChooseSkillsStatus status;
  final List<SkillModel> skills;
  final Set<String> teach;
  final Set<String> learn;
  final String? message;

  const ChooseSkillsState({
    this.status = ChooseSkillsStatus.loading,
    this.skills = const [],
    this.teach = const {},
    this.learn = const {},
    this.message,
  });

  /// لازم مهارة على الأقل في كل قسم
  bool get canSave => teach.isNotEmpty && learn.isNotEmpty;

  /// message بتتصفّر (null) لو مبعتيهاش، عشان رسالة الخطأ متفضلش
  ChooseSkillsState copyWith({
    ChooseSkillsStatus? status,
    List<SkillModel>? skills,
    Set<String>? teach,
    Set<String>? learn,
    String? message,
  }) {
    return ChooseSkillsState(
      status: status ?? this.status,
      skills: skills ?? this.skills,
      teach: teach ?? this.teach,
      learn: learn ?? this.learn,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, skills, teach, learn, message];
}
