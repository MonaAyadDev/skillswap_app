import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/di/service_locator.dart';
import 'package:skillswap/core/localization/app_translations.dart';
import 'package:skillswap/core/models/request_model.dart';
import 'package:skillswap/core/routes/routes.dart';
import '../cubit/requests_cubit.dart';
import '../cubit/requests_state.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RequestsCubit>(),
      child: const _RequestsView(),
    );
  }
}

class _RequestsView extends StatefulWidget {
  const _RequestsView();

  @override
  State<_RequestsView> createState() => _RequestsViewState();
}

class _RequestsViewState extends State<_RequestsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.surfaceOf(context),
        elevation: 0,
        title: Text(
          context.tr('swap_requests'),
          style: TextStyle(
            color: AppColors.textPrimaryOf(context),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.read<RequestsCubit>().loadRequests(),
            icon: Icon(Icons.refresh_rounded, color: AppColors.textPrimaryOf(context)),
            tooltip: 'Refresh',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: BlocBuilder<RequestsCubit, RequestsState>(
            builder: (context, state) {
              return TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondaryOf(context),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(context.tr('tab_pending')),
                        if (state.pendingRequests.isNotEmpty) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${state.pendingRequests.length}',
                              style: const TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(context.tr('tab_accepted')),
                        if (state.acceptedRequests.isNotEmpty) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${state.acceptedRequests.length}',
                              style: const TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Tab(text: context.tr('tab_sent')),
                  Tab(text: context.tr('tab_completed')),
                ],
              );
            },
          ),
        ),
      ),
      body: BlocBuilder<RequestsCubit, RequestsState>(
        builder: (context, state) {
          if (state.status == RequestsStatus.loading && state.requests.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildList(context, state.pendingRequests, isPending: true),
              _buildList(context, state.acceptedRequests, isAccepted: true),
              _buildList(context, state.sentRequests, isSent: true),
              _buildList(context, state.completedRequests, isCompleted: true),
            ],
          );
        },
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<RequestModel> list, {
    bool isPending = false,
    bool isAccepted = false,
    bool isSent = false,
    bool isCompleted = false,
  }) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSoftOf(context),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.swap_horizontal_circle_outlined,
                  size: 36,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isPending
                    ? context.tr('no_pending_req')
                    : isAccepted
                        ? (context.isArabic ? 'لا توجد تبادلات نشطة حالياً' : 'No active swaps yet')
                        : isSent
                            ? (context.isArabic ? 'لا توجد طلبات مرسلة' : 'No sent requests')
                            : (context.isArabic ? 'لا توجد تبادلات مكتملة بعد' : 'No completed swaps yet'),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryOf(context),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.isArabic
                    ? 'استكشف المهارات وأرسل طلبات تبادل مع الآخرين للبدء!'
                    : 'Explore users and send exchange requests to get started!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondaryOf(context), fontSize: 13),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => context.go(AppRoutes.discover),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                icon: const Icon(Icons.search_rounded, size: 18),
                label: Text(context.tr('discover_skills')),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final req = list[index];
        return _RequestCard(
          request: req,
          isPending: isPending,
          isAccepted: isAccepted,
          isSent: isSent,
          isCompleted: isCompleted,
        );
      },
    );
  }
}

class _RequestCard extends StatelessWidget {
  final RequestModel request;
  final bool isPending;
  final bool isAccepted;
  final bool isSent;
  final bool isCompleted;

  const _RequestCard({
    required this.request,
    this.isPending = false,
    this.isAccepted = false,
    this.isSent = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final otherName = isSent
        ? (request.toUserName.isNotEmpty ? request.toUserName : 'Swap Partner')
        : (request.fromUserName.isNotEmpty ? request.fromUserName : 'Skill Seeker');

    final initials = otherName
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderOf(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.isDark(context)
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : AppColors.primaryLight,
                child: Text(
                  initials.isNotEmpty ? initials : 'SP',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      otherName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryOf(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isSent
                          ? (context.isArabic ? 'أرسلت طلب تبادل' : 'Sent exchange request')
                          : (context.isArabic ? 'طلب تبادل مهارة معك' : 'Requested a skill exchange'),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondaryOf(context),
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(context),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoftOf(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.school_outlined, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      '${context.tr('they_teach')} ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.textPrimaryOf(context),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        request.skillToTeach,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Divider(height: 1, color: AppColors.dividerOf(context)),
                ),
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, size: 16, color: AppColors.info),
                    const SizedBox(width: 6),
                    Text(
                      '${context.tr('they_learn')} ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.textPrimaryOf(context),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        request.skillToLearn,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.info,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (request.message.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              '"${request.message}"',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondaryOf(context),
                fontSize: 13,
              ),
            ),
          ],
          const SizedBox(height: 16),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (request.status) {
      case RequestStatus.accepted:
        bg = AppColors.successLight;
        fg = AppColors.success;
        label = context.isArabic ? 'نشط' : 'Active';
        break;
      case RequestStatus.completed:
        bg = AppColors.infoLight;
        fg = AppColors.info;
        label = context.isArabic ? 'مكتمل' : 'Completed';
        break;
      case RequestStatus.rejected:
        bg = AppColors.errorLight;
        fg = AppColors.error;
        label = context.isArabic ? 'مرفوض' : 'Declined';
        break;
      default:
        bg = AppColors.warningLight;
        fg = AppColors.warning;
        label = context.isArabic ? 'معلق' : 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (isPending) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                context.read<RequestsCubit>().declineRequest(request.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.isArabic ? 'تم رفض الطلب' : 'Request declined')),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.borderOf(context)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 11),
              ),
              child: Text(context.tr('decline')),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                context.read<RequestsCubit>().acceptRequest(request.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.isArabic
                          ? 'تم قبول الطلب! يمكنك الآن بدء المحادثة.'
                          : 'Request accepted! You can now chat.',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 11),
              ),
              child: Text(context.tr('accept_and_swap')),
            ),
          ),
        ],
      );
    }

    if (isAccepted) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                context.push(AppRoutes.chat.replaceFirst(':matchId', request.id));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 11),
              ),
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 17),
              label: Text(context.tr('open_chat')),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            tooltip: context.isArabic ? 'تحديد كمكتمل' : 'Mark as Completed',
            onPressed: () {
              context.read<RequestsCubit>().completeRequest(request.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.isArabic ? 'تم تمييز التبادل كمكتمل بنجاح!' : 'Swap marked as completed!',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.check_circle_outline, color: AppColors.success),
          ),
        ],
      );
    }

    if (isCompleted) {
      return Row(
        children: [
          const Icon(Icons.verified_rounded, color: AppColors.success, size: 18),
          const SizedBox(width: 6),
          Text(
            context.isArabic ? 'اكتمل التبادل بنجاح' : 'Exchange Successfully Finished',
            style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.isArabic ? 'تم إرسال التقييم! شكراً لك.' : 'Review submitted! Thank you.'),
                ),
              );
            },
            child: Text(
              context.tr('leave_review'),
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    }

    return Text(
      context.isArabic ? 'بانتظار رد الشريك...' : 'Waiting for partner response...',
      style: TextStyle(
        color: AppColors.textMutedOf(context),
        fontSize: 12,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
