import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillswap/core/errors/failure.dart';
import 'package:skillswap/features/profile/data/user_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository _repository;
  ProfileCubit(this._repository) : super(const ProfileInitial());

  Future<void> createProfile({
    required String name,
    required String bio,
    required String country,
  }) async {
    emit(const ProfileLoading());
    try {
      await _repository.createProfile(name: name, bio: bio, country: country);
      emit(const ProfileSaved());
    } on Failure catch (f) {
      emit(ProfileError(f.message));
    }
  }
}