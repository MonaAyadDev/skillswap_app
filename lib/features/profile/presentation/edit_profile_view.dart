import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/models/user_model.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key, required this.initialUser});

  final UserModel initialUser;

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _countryController;
  late final TextEditingController _bioController;
  late final TextEditingController _teachSkillController;
  late final TextEditingController _learnSkillController;
  late List<String> _teachSkills;
  late List<String> _learnSkills;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialUser.name);
    _countryController = TextEditingController(text: widget.initialUser.country);
    _bioController = TextEditingController(text: widget.initialUser.bio);
    _teachSkillController = TextEditingController();
    _learnSkillController = TextEditingController();
    _teachSkills = [...widget.initialUser.teachSkills];
    _learnSkills = [...widget.initialUser.learnSkills];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    _bioController.dispose();
    _teachSkillController.dispose();
    _learnSkillController.dispose();
    super.dispose();
  }

  void _addSkill(TextEditingController controller, List<String> skills) {
    final skill = controller.text.trim();
    if (skill.isEmpty || skills.any((existing) => existing.toLowerCase() == skill.toLowerCase())) {
      return;
    }
    setState(() {
      skills.add(skill);
      controller.clear();
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final original = widget.initialUser;
    context.pop(
      UserModel(
        uid: original.uid,
        name: _nameController.text.trim(),
        bio: _bioController.text.trim(),
        country: _countryController.text.trim(),
        photoUrl: original.photoUrl,
        teachSkills: List.unmodifiable(_teachSkills),
        learnSkills: List.unmodifiable(_learnSkills),
        ratingAvg: original.ratingAvg,
        ratingCount: original.ratingCount,
        createdAt: original.createdAt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth >= 700 ? 32.0 : 20.0;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      16,
                      horizontalPadding,
                      32,
                    ),
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: 'Full name',
                        hint: 'Enter your name',
                        icon: Icons.person_outline_rounded,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _countryController,
                        label: 'Country',
                        hint: 'Where are you based?',
                        icon: Icons.location_on_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _bioController,
                        label: 'Bio',
                        hint: 'Tell others a little about yourself',
                        icon: Icons.notes_rounded,
                        maxLines: 4,
                        maxLength: 300,
                      ),
                      const SizedBox(height: 24),
                      _buildSkillEditor(
                        title: 'Skills I can teach',
                        hint: 'Add a skill you can teach',
                        controller: _teachSkillController,
                        skills: _teachSkills,
                        onAdd: () =>
                            _addSkill(_teachSkillController, _teachSkills),
                      ),
                      const SizedBox(height: 24),
                      _buildSkillEditor(
                        title: 'Skills I want to learn',
                        hint: 'Add a skill you want to learn',
                        controller: _learnSkillController,
                        skills: _learnSkills,
                        onAdd: () =>
                            _addSkill(_learnSkillController, _learnSkills),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _save,
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      maxLength: maxLength,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: maxLines == 1
            ? Icon(icon, color: AppColors.textMuted)
            : Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: Icon(icon, color: AppColors.textMuted),
              ),
        alignLabelWithHint: maxLines > 1,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSkillEditor({
    required String title,
    required String hint,
    required TextEditingController controller,
    required List<String> skills,
    required VoidCallback onAdd,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onAdd(),
                decoration: InputDecoration(
                  hintText: hint,
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: onAdd,
              tooltip: 'Add skill',
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                fixedSize: const Size(48, 48),
              ),
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        if (skills.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) {
              return Chip(
                label: Text(skill),
                backgroundColor: AppColors.primarySoft,
                labelStyle: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
                deleteIconColor: AppColors.primary,
                onDeleted: () => setState(() => skills.remove(skill)),
                side: BorderSide.none,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
