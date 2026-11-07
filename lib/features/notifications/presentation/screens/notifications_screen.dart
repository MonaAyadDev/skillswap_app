import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/di/service_locator.dart';
import 'package:skillswap/core/localization/app_translations.dart';
import 'package:skillswap/core/models/notification_model.dart';
import 'package:skillswap/core/routes/routes.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationsCubit>(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.surfaceOf(context),
        elevation: 0,
        title: Text(
          context.isArabic ? 'الإشعارات' : 'Notifications',
          style: TextStyle(
            color: AppColors.textPrimaryOf(context),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimaryOf(context)),
        actions: [
          BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              if (state.unreadCount == 0) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => context.read<NotificationsCubit>().markAllAsRead(),
                child: Text(
                  context.isArabic ? 'تحديد الكل كمقروء' : 'Mark all read',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Pills
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      _buildFilterChip(context, context.isArabic ? 'الكل' : 'All', 'all', state.activeFilter == 'all'),
                      const SizedBox(width: 8),
                      _buildFilterChip(context, context.isArabic ? 'الطلبات' : 'Requests', 'request', state.activeFilter == 'request'),
                      const SizedBox(width: 8),
                      _buildFilterChip(context, context.isArabic ? 'الرسائل' : 'Messages', 'message', state.activeFilter == 'message'),
                    ],
                  ),
                );
              },
            ),

            Divider(height: 1, color: AppColors.dividerOf(context)),

            // Notifications List
            Expanded(
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  final list = state.filteredNotifications;

                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSoftOf(context),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_none_rounded,
                              size: 40,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.isArabic ? 'لا توجد إشعارات هنا' : 'No notifications here',
                            style: TextStyle(
                              color: AppColors.textPrimaryOf(context),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.isArabic ? 'أنت على اطلاع دائم بكافة التبادلات!' : 'You are all caught up on your exchanges!',
                            style: TextStyle(color: AppColors.textSecondaryOf(context), fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: list.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      indent: 72,
                      color: AppColors.dividerOf(context),
                    ),
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return _NotificationTile(notification: item);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    String filterValue,
    bool isSelected,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        context.read<NotificationsCubit>().setFilter(filterValue);
      },
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surfaceOf(context),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimaryOf(context),
        fontWeight: FontWeight.w600,
        fontSize: 12.5,
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;
    Color iconBg;

    switch (notification.type) {
      case 'request':
        icon = Icons.swap_horiz_rounded;
        iconColor = AppColors.primary;
        iconBg = AppColors.primarySoft;
        break;
      case 'message':
        icon = Icons.chat_bubble_outline_rounded;
        iconColor = AppColors.info;
        iconBg = AppColors.infoLight;
        break;
      case 'review':
        icon = Icons.star_rounded;
        iconColor = AppColors.warning;
        iconBg = AppColors.warningLight;
        break;
      default:
        icon = Icons.notifications_active_outlined;
        iconColor = AppColors.primary;
        iconBg = AppColors.primarySoft;
    }

    String timeAgo = 'Just now';
    if (notification.createdAt != null) {
      final diff = DateTime.now().difference(notification.createdAt!);
      if (diff.inMinutes < 60) {
        timeAgo = '${diff.inMinutes}m ago';
      } else if (diff.inHours < 24) {
        timeAgo = '${diff.inHours}h ago';
      } else {
        timeAgo = '${diff.inDays}d ago';
      }
    }

    return InkWell(
      onTap: () {
        context.read<NotificationsCubit>().markAsRead(notification.id);

        if (notification.type == 'request') {
          context.push(AppRoutes.requests);
        } else if (notification.type == 'message') {
          context.push(AppRoutes.chat.replaceFirst(
            ':matchId',
            notification.relatedId.isNotEmpty ? notification.relatedId : 'match_1',
          ));
        } else if (notification.type == 'match') {
          context.push(AppRoutes.matches);
        }
      },
      child: Container(
        color: notification.isRead
            ? Colors.transparent
            : (AppColors.isDark(context)
                ? AppColors.primary.withValues(alpha: 0.15)
                : AppColors.primarySoft.withValues(alpha: 0.4)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.isDark(context) ? iconBg.withValues(alpha: 0.2) : iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                      fontSize: 14.5,
                      color: AppColors.textPrimaryOf(context),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.text,
                    style: TextStyle(
                      color: AppColors.textSecondaryOf(context),
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      color: AppColors.textMutedOf(context),
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead) ...[
              const SizedBox(width: 8),
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
