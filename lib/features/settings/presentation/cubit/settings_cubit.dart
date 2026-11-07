import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillswap/core/errors/failure.dart';
import 'package:skillswap/features/settings/data/settings_repository.dart';

enum SettingsStatus {
  idle,
  loading,
  passwordChanged,
  accountDeleted,
  loggedOut,
  error,
}

class SettingsState extends Equatable {
  final SettingsStatus status;
  final String? message;
  const SettingsState({this.status = SettingsStatus.idle, this.message});

  @override
  List<Object?> get props => [status, message];
}

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repository;
  SettingsCubit(this._repository) : super(const SettingsState());

  Future<void> changePassword(String current, String newPassword) =>
      _run(
        () => _repository.changePassword(
          currentPassword: current,
          newPassword: newPassword,
        ),
        SettingsStatus.passwordChanged,
      );

  Future<void> deleteAccount(String password) => _run(
        () => _repository.deleteAccount(password: password),
        SettingsStatus.accountDeleted,
      );

  Future<void> logout() =>
      _run(_repository.logout, SettingsStatus.loggedOut);

  Future<void> _run(Future<void> Function() action, SettingsStatus done) async {
    emit(const SettingsState(status: SettingsStatus.loading));
    try {
      await action();
      emit(SettingsState(status: done));
    } on Failure catch (f) {
      emit(SettingsState(status: SettingsStatus.error, message: f.message));
    }
  }
}