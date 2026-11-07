import 'package:equatable/equatable.dart';
import 'package:skillswap/core/models/notification_model.dart';

enum NotificationsStatus { initial, loading, success, error }

class NotificationsState extends Equatable {
  final NotificationsStatus status;
  final List<NotificationModel> notifications;
  final String activeFilter; // 'all', 'request', 'message'
  final String? errorMessage;

  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.activeFilter = 'all',
    this.errorMessage,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<NotificationModel> get filteredNotifications {
    if (activeFilter == 'all') return notifications;
    return notifications.where((n) => n.type == activeFilter).toList();
  }

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationModel>? notifications,
    String? activeFilter,
    String? errorMessage,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      activeFilter: activeFilter ?? this.activeFilter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        notifications,
        activeFilter,
        errorMessage,
      ];
}
