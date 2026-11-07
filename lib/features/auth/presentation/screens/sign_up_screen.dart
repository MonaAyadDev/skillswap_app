import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/constants/images_app.dart';
import 'package:skillswap/core/di/service_locator.dart';
import 'package:skillswap/core/routes/routes.dart';
import 'package:skillswap/core/utils/validators.dart';
import 'package:skillswap/core/widgets/app_button.dart';
import 'package:skillswap/core/widgets/app_text_field.dart';
import 'package:skillswap/core/widgets/back_arrow.dart';
import 'package:skillswap/features/auth/presentation/widgets/build_social_button.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _agreeToTerms = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please agree to terms and conditions')),
        );
        return;
      }
      context.read<AuthCubit>().signUp(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.go(AppRoutes.profileSetup);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BackArrow(),
                    const SizedBox(height: 16),
                    const Text(
                      'Create Your Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Start sharing your skills and learning something new with vetted peers.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Full Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AppTextField(
                      label: 'Jordan Rivera',
                      controller: _nameController,
                      prefixIcon: Icons.person_outline,
                      validator: (v) => Validators.required(v, 'Name'),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AppTextField(
                      label: 'jordan@university.edu or work email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AppTextField(
                      label: 'MasterSkill2024!',
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AppTextField(
                      label: 'MasterSkill2024!',
                      controller: _confirmController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                      validator: (v) => v != _passwordController.text
                          ? 'Passwords do not match'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: _agreeToTerms,
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _agreeToTerms = value ?? false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Wrap(
                            children: [
                              const Text(
                                'I agree to SkillSwap\'s ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Terms of Service',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Text(
                                ' and ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Community Guidelines',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Text(
                                '.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      text: 'Create Account →',
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: const [
                        Expanded(
                          child: Divider(
                            color: AppColors.border,
                            thickness: 0.5,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR SIGN UP WITH',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppColors.border,
                            thickness: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        BuildSocialButton(
                          assetPath: AppImages.google,
                          label: 'Google',
                          isSvg: true,
                          onTap: () {},
                        ),
                        BuildSocialButton(
                          assetPath: AppImages.apple,
                          label: 'Apple',
                          isSvg: false,
                          onTap: () {},
                        ),
                        BuildSocialButton(
                          assetPath: AppImages.linkedin,
                          label: 'LinkedIn',
                          isSvg: true,
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.login),
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
