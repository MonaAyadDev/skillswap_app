import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillswap/core/routes/routes.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  static const Color _primaryColor = Color(0xFF6C5CE7);
  static const List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      title: 'Share Your Skills',
      description:
          'Teach what you know and share your experience with someone who wants to learn.',
      icon: Icons.lightbulb_outline_rounded,
    ),
    _OnboardingPageData(
      title: 'Learn Something New',
      description:
          'Discover people who can teach you the skills you have always wanted to learn.',
      icon: Icons.auto_stories_rounded,
    ),
    _OnboardingPageData(
      title: 'Find Your Match',
      description:
          'Match with someone whose skills complete yours and start exchanging knowledge.',
      icon: Icons.handshake_outlined,
    ),
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_currentPage == _pages.length - 1) {
      context.go(AppRoutes.login);
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _skip() {
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _skip,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    return _OnboardingPage(
                      page: _pages[index],
                      primaryColor: _primaryColor,
                    );
                  },
                ),
              ),
              _SmoothPageIndicator(
                count: _pages.length,
                currentPage: _currentPage,
                activeColor: _primaryColor,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1
                        ? 'Get Started'
                        : 'Next',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.page,
    required this.primaryColor,
  });

  final _OnboardingPageData page;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 104,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF302A36),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF6F6A76),
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmoothPageIndicator extends StatelessWidget {
  const _SmoothPageIndicator({
    required this.count,
    required this.currentPage,
    required this.activeColor,
  });

  final int count;
  final int currentPage;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: isActive ? 28 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? activeColor : const Color(0xFFE3E0F0),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}
