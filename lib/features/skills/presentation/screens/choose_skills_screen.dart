import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/di/service_locator.dart';
import 'package:skillswap/core/routes/routes.dart';
import 'package:skillswap/core/widgets/app_button.dart';
import 'package:skillswap/core/widgets/error_view.dart';
import 'package:skillswap/core/widgets/loading_indicator.dart';
import 'package:skillswap/features/skills/presentation/widget/skill_section.dart';
import '../cubit/choose_skills_cubit.dart';
import '../cubit/choose_skills_state.dart';

class ChooseSkillsScreen extends StatelessWidget {
  const ChooseSkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChooseSkillsCubit>()..load(),
      child: const _ChooseSkillsView(),
    );
  }
}

class _ChooseSkillsView extends StatelessWidget {
  const _ChooseSkillsView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChooseSkillsCubit>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Choose your skills', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: BlocConsumer<ChooseSkillsCubit, ChooseSkillsState>(
          listener: (context, state) {
            if (state.status == ChooseSkillsStatus.saved) {
              context.go(AppRoutes.home);
            } else if (state.status == ChooseSkillsStatus.ready &&
                state.message != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message!)));
            }
          },
          builder: (context, state) {
            if (state.status == ChooseSkillsStatus.loading) {
              return const LoadingIndicator();
            }
            if (state.status == ChooseSkillsStatus.error) {
              return ErrorView(
                message: state.message ?? 'Something went wrong',
                onRetry: cubit.load,
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                     SkillSection(
                        title: 'I can teach',
                        subtitle: 'Skills you can teach others',
                        icon: Icons.school_outlined,
                        color: AppColors.primary,
                        skills: state.skills,
                        selected: state.teach,
                        onToggle: cubit.toggleTeach,
                      ),
                      const SizedBox(height: 32),
                      SkillSection(
                        title: 'I want to learn',
                        subtitle: 'Skills you would like to learn',
                        icon: Icons.lightbulb_outline,
                        color: AppColors.info,
                        skills: state.skills,
                        selected: state.learn,
                        onToggle: cubit.toggleLearn,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!state.canSave)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Pick at least one skill in each section',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ),
                      AppButton(
                        text: 'Save Skills',
                        isLoading: state.status == ChooseSkillsStatus.saving,
                        onPressed: state.canSave ? cubit.save : null,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
