import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillswap/core/errors/failure.dart';
import 'package:skillswap/features/profile/data/user_repository.dart';
import 'package:skillswap/features/skills/data/skills_repository.dart';
import 'choose_skills_state.dart';

class ChooseSkillsCubit extends Cubit<ChooseSkillsState> {
  final SkillsRepository _skillsRepository;
  final UserRepository _userRepository;

  ChooseSkillsCubit(this._skillsRepository, this._userRepository)
      : super(const ChooseSkillsState());

  Future<void> load() async {
    emit(state.copyWith(status: ChooseSkillsStatus.loading));
    try {
      final skills = await _skillsRepository.getSkills();
      emit(state.copyWith(status: ChooseSkillsStatus.ready, skills: skills));
    } on Failure catch (f) {
      emit(state.copyWith(status: ChooseSkillsStatus.error, message: f.message));
    }
  }

  void toggleTeach(String name) {
    final teach = {...state.teach};
    final learn = {...state.learn};
    if (!teach.remove(name)) {
      teach.add(name);
      learn.remove(name); 
    }
    emit(state.copyWith(teach: teach, learn: learn));
  }

  void toggleLearn(String name) {
    final teach = {...state.teach};
    final learn = {...state.learn};
    if (!learn.remove(name)) {
      learn.add(name);
      teach.remove(name);
    }
    emit(state.copyWith(teach: teach, learn: learn));
  }

Future<void> save() async {
    if (!state.canSave) return;
    emit(state.copyWith(status: ChooseSkillsStatus.saving));
    try {
      // بنجيب الـ uid الحالي مباشرة من الـ UserRepository
      final userId = _userRepository.currentUid;
      
      await _skillsRepository.updateSkills(
        userId: userId,
        teachSkills: state.teach.toList(),
        learnSkills: state.learn.toList(),
      );
      emit(state.copyWith(status: ChooseSkillsStatus.saved));
    } on Failure catch (f) {
      emit(state.copyWith(status: ChooseSkillsStatus.ready, message: f.message));
    }
  }
}