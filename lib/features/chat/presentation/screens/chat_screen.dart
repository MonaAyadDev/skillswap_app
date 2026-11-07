import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/di/service_locator.dart';
import 'package:skillswap/core/localization/app_translations.dart';
import 'package:skillswap/core/models/message_model.dart';
import 'package:skillswap/features/chat/data/chat_repository.dart';

class ChatScreen extends StatefulWidget {
  final String matchId;
  const ChatScreen({super.key, required this.matchId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatRepository _chatRepo = sl<ChatRepository>();
  final String _currentUserId = sl<FirebaseAuth>().currentUser?.uid ?? 'current_user';

  String get _partnerDisplayName {
    if (widget.matchId.contains('alex-morgan') || widget.matchId == 'match_1' || widget.matchId == 'req_1') {
      return 'Alex Morgan';
    }
    if (widget.matchId.contains('jordan-lee') || widget.matchId == 'match_2' || widget.matchId == 'req_2') {
      return 'Jordan Lee';
    }
    if (widget.matchId.contains('sam-rivera') || widget.matchId == 'match_3' || widget.matchId == 'req_3') {
      return 'Sam Rivera';
    }
    if (widget.matchId.contains('taylor-kim') || widget.matchId == 'match_4' || widget.matchId == 'req_4') {
      return 'Taylor Kim';
    }
    return 'Swap Partner';
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    _chatRepo.sendMessage(
      matchId: widget.matchId,
      senderId: _currentUserId,
      text: text,
    );
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final partnerName = _partnerDisplayName;
    final initials = partnerName
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join();

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.surfaceOf(context),
        elevation: 0.5,
        leadingWidth: 40,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 19,
                  backgroundColor: AppColors.isDark(context)
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : AppColors.primarySoft,
                  child: Text(
                    initials.isNotEmpty ? initials : 'P',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.online,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    partnerName,
                    style: TextStyle(
                      color: AppColors.textPrimaryOf(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    context.tr('online_status'),
                    style: const TextStyle(
                      color: AppColors.online,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined, color: AppColors.primary),
            tooltip: context.isArabic ? 'بدء مكالمة فيديو' : 'Start Video Session',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.isArabic
                        ? 'جارٍ بدء جلسة الفيديو المباشرة...'
                        : 'Starting swap video call session...',
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.textPrimaryOf(context)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Swap Agreement Header Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.isDark(context)
                ? AppColors.primary.withValues(alpha: 0.2)
                : AppColors.primarySoft,
            child: Row(
              children: [
                const Icon(Icons.handshake_outlined, color: AppColors.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr('exchange_proposal_active'),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                      ),
                      Text(
                        'You Teach: Flutter  ⇄  $partnerName: UI/UX Design',
                        style: TextStyle(
                          color: AppColors.textSecondaryOf(context),
                          fontSize: 11.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceOf(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '1 hr / wk',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Message Stream
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: _chatRepo.getMessages(widget.matchId),
              builder: (context, snapshot) {
                final messages = snapshot.data ?? [];
                if (messages.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSoftOf(context),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 36,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            context.tr('say_hi'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimaryOf(context),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.isArabic
                                ? 'خططا لجلسة التبادل الأولى وتبادلا الأفكار والأهداف.'
                                : 'Plan your first session and introduce what you want to achieve.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textSecondaryOf(context), fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == _currentUserId;
                    final timeStr = msg.createdAt != null
                        ? DateFormat('hh:mm a').format(msg.createdAt!)
                        : 'Now';

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.76,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isMe ? AppColors.primary : AppColors.surfaceOf(context),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isMe ? 16 : 4),
                            bottomRight: Radius.circular(isMe ? 4 : 16),
                          ),
                          border: isMe ? null : Border.all(color: AppColors.borderOf(context)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.text,
                              style: TextStyle(
                                color: isMe ? Colors.white : AppColors.textPrimaryOf(context),
                                fontSize: 14.5,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  timeStr,
                                  style: TextStyle(
                                    color: isMe ? Colors.white70 : AppColors.textMutedOf(context),
                                    fontSize: 10.5,
                                  ),
                                ),
                                if (isMe) ...[
                                  const SizedBox(width: 4),
                                  const Icon(Icons.done_all_rounded, size: 14, color: Colors.white70),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Message Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceOf(context),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.attach_file_rounded, color: AppColors.iconOf(context)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.isArabic ? 'إرفاق ملف درس أو ملاحظات' : 'Attach lesson file or notes'),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSoftOf(context),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        style: TextStyle(color: AppColors.textPrimaryOf(context)),
                        decoration: InputDecoration(
                          hintText: context.tr('type_message'),
                          hintStyle: TextStyle(color: AppColors.textMutedOf(context), fontSize: 14),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
