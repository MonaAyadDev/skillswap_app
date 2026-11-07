import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/constants/images_app.dart';
import 'package:skillswap/core/di/service_locator.dart';
import 'package:skillswap/core/localization/app_translations.dart';
import 'package:skillswap/core/localization/locale_cubit.dart';
import 'package:skillswap/core/routes/routes.dart';
import 'package:skillswap/core/theme/theme_cubit.dart';
import '../cubit/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsCubit>(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatefulWidget {
  const _SettingsView();

  @override
  State<_SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<_SettingsView> {
  bool _pushNotifications = true;
  bool _soundsEnabled = true;

  Future<void> _changePassword(BuildContext context) async {
    final current = TextEditingController();
    final next = TextEditingController();
    final isArabic = context.isArabic;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceOf(ctx),
        title: Text(
          context.tr('change_password'),
          style: TextStyle(
            color: AppColors.textPrimaryOf(ctx),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: current,
              obscureText: true,
              style: TextStyle(color: AppColors.textPrimaryOf(ctx)),
              decoration: InputDecoration(
                labelText: context.tr('current_password'),
                labelStyle: TextStyle(color: AppColors.textSecondaryOf(ctx)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: next,
              obscureText: true,
              style: TextStyle(color: AppColors.textPrimaryOf(ctx)),
              decoration: InputDecoration(
                labelText: context.tr('new_password'),
                labelStyle: TextStyle(color: AppColors.textSecondaryOf(ctx)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              context.tr('cancel'),
              style: TextStyle(color: AppColors.textSecondaryOf(ctx)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(80, 40),
            ),
            child: Text(context.tr('save')),
          ),
        ],
      ),
    );

    final currentText = current.text;
    final nextText = next.text;
    current.dispose();
    next.dispose();

    if (ok != true || !mounted) return;
    if (currentText.isEmpty || nextText.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic
                ? 'يجب ألا تقل كلمة المرور الجديدة عن 6 أحرف'
                : 'New password must be at least 6 characters',
          ),
        ),
      );
      return;
    }
    context.read<SettingsCubit>().changePassword(currentText, nextText);
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final password = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceOf(ctx),
        title: Text(
          context.tr('delete_account'),
          style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.tr('delete_account_warning'),
              style: TextStyle(color: AppColors.textSecondaryOf(ctx), fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: password,
              obscureText: true,
              style: TextStyle(color: AppColors.textPrimaryOf(ctx)),
              decoration: InputDecoration(
                labelText: context.tr('current_password'),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              context.tr('cancel'),
              style: TextStyle(color: AppColors.textSecondaryOf(ctx)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              minimumSize: const Size(80, 40),
            ),
            child: Text(context.tr('confirm')),
          ),
        ],
      ),
    );

    final text = password.text;
    password.dispose();
    if (ok != true || text.isEmpty || !mounted) return;
    context.read<SettingsCubit>().deleteAccount(text);
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = sl<ThemeCubit>();
    final localeCubit = sl<LocaleCubit>();

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.surfaceOf(context),
        elevation: 0,
        title: Text(
          context.tr('settings_title'),
          style: TextStyle(
            color: AppColors.textPrimaryOf(context),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimaryOf(context)),
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          switch (state.status) {
            case SettingsStatus.loggedOut:
            case SettingsStatus.accountDeleted:
              context.go(AppRoutes.login);
              break;
            case SettingsStatus.passwordChanged:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.isArabic
                        ? 'تم تغيير كلمة المرور بنجاح'
                        : 'Password changed successfully',
                  ),
                ),
              );
              break;
            case SettingsStatus.error:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message!)),
              );
              break;
            default:
              break;
          }
        },
        builder: (context, state) {
          final loading = state.status == SettingsStatus.loading;

          return Column(
            children: [
              if (loading) const LinearProgressIndicator(color: AppColors.primary),
              Expanded(
                child: IgnorePointer(
                  ignoring: loading,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    children: [
                      // ==========================================
                      // 1. SECTION: THEME MODE (وضح الداكن والفاتح)
                      // ==========================================
                      _buildSectionTitle(context, context.tr('appearance'), Icons.palette_outlined),
                      const SizedBox(height: 12),
                      BlocBuilder<ThemeCubit, ThemeMode>(
                        bloc: themeCubit,
                        builder: (context, mode) {
                          final isDark = mode == ThemeMode.dark;
                          return Row(
                            children: [
                              // Light Mode Card
                              Expanded(
                                child: _buildThemeCard(
                                  context: context,
                                  title: context.tr('theme_light'),
                                  subtitle: context.isArabic ? 'واجهة نهارية' : 'Bright interface',
                                  iconPath: AppImages.sun,
                                  fallbackIcon: Icons.wb_sunny_rounded,
                                  isSelected: !isDark,
                                  previewBgColor: const Color(0xFFF8F9FF),
                                  previewCardColor: Colors.white,
                                  accentColor: const Color(0xFF630ED4),
                                  onTap: () => themeCubit.setDark(false),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Dark Mode Card
                              Expanded(
                                child: _buildThemeCard(
                                  context: context,
                                  title: context.tr('theme_dark'),
                                  subtitle: context.isArabic ? 'واجهة ليلية' : 'Night contrast',
                                  iconPath: AppImages.moon,
                                  fallbackIcon: Icons.nightlight_round,
                                  isSelected: isDark,
                                  previewBgColor: const Color(0xFF0F0D17),
                                  previewCardColor: const Color(0xFF1B1726),
                                  accentColor: const Color(0xFF8B47FF),
                                  onTap: () => themeCubit.setDark(true),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // ==========================================
                      // 2. SECTION: LANGUAGE (ترجمة انجليزي / عربي)
                      // ==========================================
                      _buildSectionTitle(context, context.tr('language_section'), Icons.translate_rounded),
                      const SizedBox(height: 12),
                      BlocBuilder<LocaleCubit, Locale>(
                        bloc: localeCubit,
                        builder: (context, locale) {
                          final isArabic = locale.languageCode == 'ar';

                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.surfaceOf(context),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.borderOf(context)),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primarySoft,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.language_rounded,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            context.tr('app_language'),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: AppColors.textPrimaryOf(context),
                                            ),
                                          ),
                                          Text(
                                            isArabic ? 'العربية (RTL)' : 'English (LTR)',
                                            style: TextStyle(
                                              color: AppColors.textSecondaryOf(context),
                                              fontSize: 12.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildLanguageOption(
                                        context: context,
                                        flag: '🇺🇸',
                                        title: 'English',
                                        isSelected: !isArabic,
                                        onTap: () => localeCubit.setEnglish(),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _buildLanguageOption(
                                        context: context,
                                        flag: '🇸🇦',
                                        title: 'العربية',
                                        isSelected: isArabic,
                                        onTap: () => localeCubit.setArabic(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // ==========================================
                      // 3. SECTION: NOTIFICATIONS & CONTROLS
                      // ==========================================
                      _buildSectionTitle(context, context.tr('notifications_section'), Icons.tune_rounded),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceOf(context),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderOf(context)),
                        ),
                        child: Column(
                          children: [
                            SwitchListTile(
                              secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.primary),
                              title: Text(
                                context.tr('push_notifications'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimaryOf(context),
                                  fontSize: 14.5,
                                ),
                              ),
                              subtitle: Text(
                                context.tr('push_notifications_desc'),
                                style: TextStyle(
                                  color: AppColors.textSecondaryOf(context),
                                  fontSize: 12,
                                ),
                              ),
                              activeThumbColor: AppColors.primary,
                              value: _pushNotifications,
                              onChanged: (val) {
                                setState(() => _pushNotifications = val);
                              },
                            ),
                            Divider(height: 1, color: AppColors.dividerOf(context)),
                            SwitchListTile(
                              secondary: const Icon(Icons.volume_up_outlined, color: AppColors.info),
                              title: Text(
                                context.tr('sound_vibration'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimaryOf(context),
                                  fontSize: 14.5,
                                ),
                              ),
                              activeThumbColor: AppColors.primary,
                              value: _soundsEnabled,
                              onChanged: (val) {
                                setState(() => _soundsEnabled = val);
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ==========================================
                      // 4. SECTION: SECURITY & ACCOUNT
                      // ==========================================
                      _buildSectionTitle(context, context.tr('security_section'), Icons.security_rounded),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceOf(context),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderOf(context)),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.lock_reset_rounded, color: AppColors.primary),
                              title: Text(
                                context.tr('change_password'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimaryOf(context),
                                  fontSize: 14.5,
                                ),
                              ),
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.iconOf(context),
                              ),
                              onTap: () => _changePassword(context),
                            ),
                            Divider(height: 1, color: AppColors.dividerOf(context)),
                            ListTile(
                              leading: const Icon(Icons.logout_rounded, color: AppColors.warning),
                              title: Text(
                                context.tr('logout'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimaryOf(context),
                                  fontSize: 14.5,
                                ),
                              ),
                              onTap: () => context.read<SettingsCubit>().logout(),
                            ),
                            Divider(height: 1, color: AppColors.dividerOf(context)),
                            ListTile(
                              leading: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
                              title: Text(
                                context.tr('delete_account'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.error,
                                  fontSize: 14.5,
                                ),
                              ),
                              onTap: () => _deleteAccount(context),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Version Footer
                      Center(
                        child: Column(
                          children: [
                            Text(
                              '${context.tr('version')} 1.0.0+1',
                              style: TextStyle(
                                color: AppColors.textMutedOf(context),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Knowledge Exchange Platform',
                              style: TextStyle(
                                color: AppColors.textMutedOf(context),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String iconPath,
    required IconData fallbackIcon,
    required bool isSelected,
    required Color previewBgColor,
    required Color previewCardColor,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderOf(context),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Miniature
            Container(
              height: 60,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: previewBgColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderOf(context).withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 8,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    height: 24,
                    decoration: BoxDecoration(
                      color: previewCardColor,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 45,
                          height: 5,
                          decoration: BoxDecoration(
                            color: isSelected ? accentColor : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                          color: AppColors.textPrimaryOf(context),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondaryOf(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isSelected ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
                  color: isSelected ? AppColors.primary : AppColors.iconOf(context),
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String flag,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.backgroundOf(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderOf(context),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textPrimaryOf(context),
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
