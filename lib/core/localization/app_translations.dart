import 'package:flutter/material.dart';

class AppTranslations {
  final Locale locale;
  AppTranslations(this.locale);

  bool get isArabic => locale.languageCode == 'ar';

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Navigation
      'nav_home': 'Home',
      'nav_discover': 'Discover',
      'nav_matches': 'Matches',
      'nav_requests': 'Requests',
      'nav_profile': 'Profile',

      // Settings
      'settings_title': 'Settings',
      'appearance': 'Appearance & Display',
      'theme_mode': 'Theme Mode',
      'theme_light': 'Light Mode',
      'theme_light_desc': 'Crisp, clean & bright interface',
      'theme_dark': 'Dark Mode',
      'theme_dark_desc': 'Soft on eyes with deep contrast',
      'language_section': 'Language & Region',
      'app_language': 'App Language',
      'english': 'English',
      'arabic': 'العربية (Arabic)',
      'notifications_section': 'Notifications & Alerts',
      'push_notifications': 'Push Notifications',
      'push_notifications_desc': 'Get alerts for new swap requests and messages',
      'sound_vibration': 'Sounds & Haptics',
      'security_section': 'Account & Security',
      'change_password': 'Change Password',
      'current_password': 'Current password',
      'new_password': 'New password',
      'logout': 'Log Out',
      'delete_account': 'Delete Account',
      'delete_account_warning': 'This will permanently remove your account and swap history.',
      'cancel': 'Cancel',
      'save': 'Save',
      'confirm': 'Confirm',
      'version': 'SkillSwap Version',

      // Home
      'good_morning': 'Good morning,',
      'find_next_skill': 'Find your next skill',
      'search_placeholder': 'Search skills or people...',
      'explore_categories': 'Explore Categories',
      'see_all': 'See all',
      'recommended_matches': 'Recommended Matches',
      'trending_skills': 'Trending Skills',

      // Discover
      'discover_skills': 'Discover Skills',
      'filter_skills': 'Filter by skill',
      'filter_countries': 'Filter by country',
      'can_teach': 'Can teach',
      'wants_to_learn': 'Wants to learn',
      'view_profile': 'View profile',

      // Matches
      'smart_matches': 'Smart Matches',
      'mutual_affinity': 'Mutual Skill Affinity',
      'mutual_desc': 'Members whose skills match what you want to learn, and vice-versa.',
      'swap_request': 'Swap Request',
      'chat': 'Chat',

      // Requests
      'swap_requests': 'Swap Requests',
      'tab_pending': 'Pending',
      'tab_accepted': 'Accepted',
      'tab_sent': 'Sent',
      'tab_completed': 'Completed',
      'they_teach': 'They Teach',
      'they_learn': 'They Learn',
      'accept_and_swap': 'Accept & Swap',
      'decline': 'Decline',
      'open_chat': 'Open Chat',
      'leave_review': 'Leave Review',
      'no_pending_req': 'No pending requests',

      // Profile
      'my_profile': 'My Profile',
      'profile': 'Profile',
      'edit_profile': 'Edit Profile',
      'about_me': 'About Me',
      'skills_teach': 'Skills I can teach',
      'skills_learn': 'Skills I want to learn',
      'swaps_done': 'Swaps Done',
      'rating': 'Rating',
      'reviews': 'Reviews',
      'app_settings': 'App Settings & Preferences',

      // Chat
      'online_status': 'Online · Active Swap',
      'exchange_proposal_active': 'Exchange Proposal Active',
      'type_message': 'Type a message...',
      'say_hi': 'Say hi to your partner! 👋',
    },
    'ar': {
      // Navigation
      'nav_home': 'الرئيسية',
      'nav_discover': 'استكشاف',
      'nav_matches': 'التوافقات',
      'nav_requests': 'الطلبات',
      'nav_profile': 'حسابي',

      // Settings
      'settings_title': 'الإعدادات',
      'appearance': 'المظهر والعرض',
      'theme_mode': 'وضع المظهر',
      'theme_light': 'الوضع الفاتح',
      'theme_light_desc': 'واجهة ساطعة، نقية وواضحة',
      'theme_dark': 'الوضع الداكن',
      'theme_dark_desc': 'مريح للعين مع تباين داكن أنيق',
      'language_section': 'اللغة والمنطقة',
      'app_language': 'لغة التطبيق',
      'english': 'English (الإنجليزية)',
      'arabic': 'العربية',
      'notifications_section': 'الإشعارات والتنبيهات',
      'push_notifications': 'إشعارات التطبيق',
      'push_notifications_desc': 'تنبيهات فورية لطلبات التبادل الجديدة والرسائل',
      'sound_vibration': 'الأصوات والاهتزاز',
      'security_section': 'الأمان والحساب',
      'change_password': 'تغيير كلمة المرور',
      'current_password': 'كلمة المرور الحالية',
      'new_password': 'كلمة المرور الجديدة',
      'logout': 'تسجيل الخروج',
      'delete_account': 'حذف الحساب نهائياً',
      'delete_account_warning': 'سيتم حذف حسابك وجميع بيانات وسجل التبادلات بشكل نهائي.',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'confirm': 'تأكيد',
      'version': 'إصدار SkillSwap',

      // Home
      'good_morning': 'مرحباً بك،',
      'find_next_skill': 'ابحث عن مهاراتك القادمة',
      'search_placeholder': 'ابحث عن مهارة أو مرشد...',
      'explore_categories': 'استكشف التصنيفات',
      'see_all': 'عرض الكل',
      'recommended_matches': 'التوافقات المقترحة لك',
      'trending_skills': 'المهارات الأكثر طلباً',

      // Discover
      'discover_skills': 'استكشاف المهارات',
      'filter_skills': 'تصفية حسب المهارة',
      'filter_countries': 'تصفية حسب الدولة',
      'can_teach': 'مهارات يقدمها',
      'wants_to_learn': 'مهارات يرغب بتعلمها',
      'view_profile': 'عرض الملف',

      // Matches
      'smart_matches': 'التوافقات الذكية',
      'mutual_affinity': 'توافق المهارات التبادلي',
      'mutual_desc': 'أعضاء تتوافق مهاراتهم المعروضة مع ما تريد تعلمه والعكس.',
      'swap_request': 'طلب تبادل',
      'chat': 'محادثة',

      // Requests
      'swap_requests': 'طلبات التبادل',
      'tab_pending': 'قيد الانتظار',
      'tab_accepted': 'المقبولة',
      'tab_sent': 'المرسلة',
      'tab_completed': 'المكتملة',
      'they_teach': 'يُعلم:',
      'they_learn': 'يتعلم:',
      'accept_and_swap': 'قبول وبدء التبادل',
      'decline': 'رفض الطلب',
      'open_chat': 'فتح المحادثة',
      'leave_review': 'ترك تقييم',
      'no_pending_req': 'لا توجد طلبات معلقة حالياً',

      // Profile
      'my_profile': 'ملفي الشخصي',
      'profile': 'الملف الشخصي',
      'edit_profile': 'تعديل الملف',
      'about_me': 'نبذة عني',
      'skills_teach': 'مهارات يمكنني تدريسها',
      'skills_learn': 'مهارات أود تعلمها',
      'swaps_done': 'تبادلات منجزة',
      'rating': 'التقييم',
      'reviews': 'المراجعات',
      'app_settings': 'إعدادات التطبيق وتفضيلاته',

      // Chat
      'online_status': 'متصل الآن · تبادل نشط',
      'exchange_proposal_active': 'اتفاقية التبادل نشطة',
      'type_message': 'اكتب رسالة...',
      'say_hi': 'قل مرحباً لزميلك في التبادل! 👋',
    },
  };

  String text(String key) {
    final langCode = locale.languageCode == 'ar' ? 'ar' : 'en';
    return _localizedValues[langCode]?[key] ?? _localizedValues['en']?[key] ?? key;
  }
}

extension TranslationExtension on BuildContext {
  AppTranslations get trScope =>
      AppTranslations(Localizations.localeOf(this));

  String tr(String key) => trScope.text(key);

  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';
}
