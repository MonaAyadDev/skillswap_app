import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/di/service_locator.dart';
import 'package:skillswap/features/requests/presentation/cubit/requests_cubit.dart';

class SendRequestScreen extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const SendRequestScreen({super.key, this.initialData});

  @override
  State<SendRequestScreen> createState() => _SendRequestScreenState();
}

class _SendRequestScreenState extends State<SendRequestScreen> {
  late String _targetUserId;
  late String _targetUserName;
  late List<String> _targetSkills;
  late List<String> _mySkills;

  String? _selectedSkillToTeach;
  String? _selectedSkillToLearn;
  String _selectedFrequency = '1 session / week (1 hr)';
  final TextEditingController _messageController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _frequencyOptions = [
    '1 session / week (1 hr)',
    '2 sessions / week (2 hrs)',
    'Bi-weekly check-ins',
    'Project-based collaboration',
    'Casual Q&A whenever needed',
  ];

  @override
  void initState() {
    super.initState();
    final data = widget.initialData ?? {};
    _targetUserId = data['userId'] ?? 'alex-morgan';
    _targetUserName = data['userName'] ?? 'Alex Morgan';
    _targetSkills = List<String>.from(
      data['teachSkills'] ?? ['UI/UX Design', 'Figma Systems', 'User Research'],
    );
    _mySkills = List<String>.from(
      data['mySkills'] ?? ['Flutter Development', 'Dart', 'State Management (Bloc)'],
    );

    if (_targetSkills.isNotEmpty) _selectedSkillToLearn = _targetSkills.first;
    if (_mySkills.isNotEmpty) _selectedSkillToTeach = _mySkills.first;
    _messageController.text =
        'Hi $_targetUserName! I would love to do a skill exchange with you. Let me know if you would like to connect!';
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_selectedSkillToTeach == null || _selectedSkillToLearn == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select skills to offer and learn')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final requestsCubit = sl<RequestsCubit>();
      await requestsCubit.sendRequest(
        toUserId: _targetUserId,
        toUserName: _targetUserName,
        skillToLearn: _selectedSkillToLearn!,
        skillToTeach: _selectedSkillToTeach!,
        message: '${_messageController.text.trim()} [Frequency: $_selectedFrequency]',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.success,
            content: Text('Swap request sent to $_targetUserName!'),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.surfaceOf(context),
        elevation: 0,
        title: const Text(
          'Send Swap Request',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Target User Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderOf(context)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.primarySoft,
                      child: Text(
                        _targetUserName.isNotEmpty ? _targetUserName[0] : 'U',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _targetUserName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Proposed Skill Exchange Partner',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Exchange Preview Graphic
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primarySoft,
                      AppColors.infoLight,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(Icons.school_rounded, color: AppColors.primary),
                          const SizedBox(height: 4),
                          const Text(
                            'You Teach',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _selectedSkillToTeach ?? 'Select skill',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.swap_horiz_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(Icons.lightbulb_rounded, color: AppColors.info),
                          const SizedBox(height: 4),
                          const Text(
                            'They Teach',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _selectedSkillToLearn ?? 'Select skill',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.info,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Section 1: Skill to offer
              const Text(
                'Skill you want to teach them',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderOf(context)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedSkillToTeach,
                    hint: const Text('Choose a skill you can teach'),
                    items: _mySkills.map((s) {
                      return DropdownMenuItem(value: s, child: Text(s));
                    }).toList(),
                    onChanged: (val) {
                      setState(() => _selectedSkillToTeach = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Section 2: Skill to learn
              Text(
                'Skill you want to learn from $_targetUserName',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderOf(context)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedSkillToLearn,
                    hint: const Text('Choose a skill to learn'),
                    items: _targetSkills.map((s) {
                      return DropdownMenuItem(value: s, child: Text(s));
                    }).toList(),
                    onChanged: (val) {
                      setState(() => _selectedSkillToLearn = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Section 3: Preferred Frequency
              const Text(
                'Session Frequency & Format',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderOf(context)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedFrequency,
                    items: _frequencyOptions.map((f) {
                      return DropdownMenuItem(value: f, child: Text(f));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedFrequency = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Section 4: Personal Message
              const Text(
                'Add a personal message',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _messageController,
                maxLines: 4,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surfaceOf(context),
                  hintText: 'Introduce yourself and what goals you hope to reach together...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.borderOf(context)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.borderOf(context)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Send button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.send_rounded),
                  label: Text(
                    _isSubmitting ? 'Sending Request...' : 'Send Swap Request',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
