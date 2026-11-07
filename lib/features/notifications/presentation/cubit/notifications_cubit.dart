import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillswap/features/notifications/data/notifications_repository.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repository;
  StreamSubscription? _subscription;

  NotificationsCubit(this._repository) : super(const NotificationsState()) {
    loadNotifications();
  }

  void loadNotifications() {
    emit(state.copyWith(status: NotificationsStatus.loading));
    _subscription?.cancel();
    _subscription = _repository.getNotifications().listen(
      (list) {
        emit(state.copyWith(
          status: NotificationsStatus.success,
          notifications: list,
        ));
      },
      onError: (err) {
        emit(state.copyWith(
          status: NotificationsStatus.error,
          errorMessage: err.toString(),
        ));
      },
    );
  }

  void setFilter(String filter) {
    emit(state.copyWith(activeFilter: filter));
  }

  Future<void> markAsRead(String id) async {
    await _repository.markAsRead(id);
  }

  Future<void> markAllAsRead() async {
    await _repository.markAllAsRead();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
