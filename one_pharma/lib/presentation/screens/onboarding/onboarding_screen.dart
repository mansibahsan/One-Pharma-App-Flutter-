import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/presentation/widgets/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingItem> _slides = const [
    OnboardingItem(
      title: 'View & Buy Medicine\nOnline',
      subtitle:
          'Browse thousands of verified pharmaceuticals and healthcare products with doorstep delivery.',
      iconIndex: 0,
    ),
    OnboardingItem(
      title: 'Save your time\nwith us',
      subtitle:
          'Upload your doctor\'s prescription and let our certified pharmacists handle the rest effortlessly.',
      iconIndex: 1,
    ),
    OnboardingItem(
      title: 'We provide Home\nDelivery',
      subtitle:
          'Fast, temperature-controlled delivery directly to your home with real-time live GPS tracking.',
      iconIndex: 2,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/auth-gateway');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Skip button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48),
                  TextButton(
                    onPressed: () => context.go('/auth-gateway'),
                    child: Text(
                      'Skip',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // PageView Slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSlideArt(slide.iconIndex),
                            const SizedBox(height: 32),
                            Text(
                              slide.title,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.h1.copyWith(
                                fontSize: 24,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              slide.subtitle,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.subtitle.copyWith(
                                fontSize: 13,
                                color: AppColors.textSecondary,
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

            // Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (index) {
                final isActive = index == _currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 22 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),

            // Bottom Action
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PrimaryButton(
                text: _currentIndex == _slides.length - 1 ? 'Get Started' : 'Next',
                onPressed: _onNext,
              ),
            ),
            const SizedBox(height: 24),

            // Medical watermark icon row
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Opacity(
                opacity: 0.15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.science_outlined, color: AppColors.primary, size: 24),
                    Icon(Icons.add_circle_outline, color: AppColors.primary, size: 24),
                    Icon(Icons.medication_outlined, color: AppColors.primary, size: 24),
                    Icon(Icons.favorite_border, color: AppColors.primary, size: 24),
                    Icon(Icons.local_hospital_outlined, color: AppColors.primary, size: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideArt(int iconIndex) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10,
            left: 15,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFFFF4858),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Container(
            width: 170,
            height: 170,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: _buildInnerIcon(iconIndex),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerIcon(int index) {
    switch (index) {
      case 0:
        return const Icon(
          Icons.medication_liquid_rounded,
          size: 75,
          color: Colors.white,
        );
      case 1:
        return const Icon(
          Icons.verified_rounded,
          size: 75,
          color: Colors.white,
        );
      case 2:
      default:
        return const Icon(
          Icons.two_wheeler_rounded,
          size: 80,
          color: Colors.white,
        );
    }
  }
}

class OnboardingItem {
  final String title;
  final String subtitle;
  final int iconIndex;

  const OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.iconIndex,
  });
}
