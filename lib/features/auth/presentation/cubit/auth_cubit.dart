import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillswap/core/errors/failure.dart';
import 'package:skillswap/features/auth/data/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  AuthCubit(this._repository) : super(const AuthInitial());

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());
    try {
      await _repository.login(email: email, password: password);
      emit(const AuthSuccess());
    } on Failure catch (f) {
      emit(AuthError(f.message));
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    emit(const AuthLoading());
    try {
      await _repository.signUp(name: name, email: email, password: password);
      emit(const AuthSuccess());
    } on Failure catch (f) {
      emit(AuthError(f.message));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(const AuthLoading());
    try {
      await _repository.resetPassword(email);
      emit(const AuthResetSent());
    } on Failure catch (f) {
      emit(AuthError(f.message));
    }
  }
}