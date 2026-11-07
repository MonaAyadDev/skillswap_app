import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/models/user_model.dart';
import 'package:skillswap/features/profile/presentation/widgets/build_text_field.dart';
import 'package:skillswap/features/profile/presentation/widgets/skill_editor_widget.dart';

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
    if (skill.isEmpty ||
        skills.any((existing) => existing.toLowerCase() == skill.toLowerCase())) {
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
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
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
                      BuildTextField(
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
                      BuildTextField(
                        controller: _countryController,
                        label: 'Country',
                        hint: 'Where are you based?',
                        icon: Icons.location_on_outlined,
                      ),
                      const SizedBox(height: 16),
                      BuildTextField(
                        controller: _bioController,
                        label: 'Bio',
                        hint: 'Tell others a little about yourself',
                        icon: Icons.notes_rounded,
                        maxLines: 4,
                        maxLength: 300,
                      ),
                      const SizedBox(height: 24),
                      SkillEditorWidget(
                        title: 'Skills I can teach',
                        hint: 'Add a skill you can teach',
                        controller: _teachSkillController,
                        skills: _teachSkills,
                        onAdd: () => _addSkill(_teachSkillController, _teachSkills),
                        onRemove: (skill) {
                          setState(() {
                            _teachSkills.remove(skill);
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      SkillEditorWidget(
                        title: 'Skills I want to learn',
                        hint: 'Add a skill you want to learn',
                        controller: _learnSkillController,
                        skills: _learnSkills,
                        onAdd: () => _addSkill(_learnSkillController, _learnSkills),
                        onRemove: (skill) {
                          setState(() {
                            _learnSkills.remove(skill);
                          });
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textOnPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: _save,
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
}
