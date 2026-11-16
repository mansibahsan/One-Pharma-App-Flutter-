import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';

class HeroSlide {
  final String tag;
  final String title;
  final String subtitle;
  final String ctaLabel;
  final String route;
  final String imageAsset;
  final Color accentColor;
  final Color scrimColor;

  const HeroSlide({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.route,
    required this.imageAsset,
    required this.accentColor,
    required this.scrimColor,
  });
}

class HeroBannerCarousel extends StatefulWidget {
  const HeroBannerCarousel({super.key});

  @override
  State<HeroBannerCarousel> createState() => _HeroBannerCarouselState();
}

class _HeroBannerCarouselState extends State<HeroBannerCarousel> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  int _currentIndex = 0;
  Timer? _autoPlayTimer;

  static const List<HeroSlide> _slides = [
    HeroSlide(
      tag: 'EXPRESS 30-MIN',
      title: 'Authentic Meds\nTo Your Doorstep',
      subtitle: 'Tablets, Syrups, IV Saline & Care',
      ctaLabel: 'Shop Now',
      route: '/category/All',
      imageAsset: 'assets/images/hero/hero_delivery.jpg',
      accentColor: Color(0xFF0284C7),
      scrimColor: Color(0xFF0C4A6E),
    ),
    HeroSlide(
      tag: 'RX VERIFIED',
      title: 'Upload Rx & Save\nUp to 25% Today',
      subtitle: 'Licensed pharmacists review in mins',
      ctaLabel: 'Upload Rx',
      route: '/prescription-upload',
      imageAsset: 'assets/images/hero/hero_prescription.jpg',
      accentColor: Color(0xFFEA580C),
      scrimColor: Color(0xFF7C2D12),
    ),
    HeroSlide(
      tag: '24/7 CLINICAL CARE',
      title: 'Consult Licensed\nPharmacists Live',
      subtitle: 'Dosage safety, refills & guidance',
      ctaLabel: 'Book Session',
      route: '/consult',
      imageAsset: 'assets/images/hero/hero_teleconsult.jpg',
      accentColor: AppColors.primary,
      scrimColor: Color(0xFF1E293B),
    ),
    HeroSlide(
      tag: 'HOSPITAL & PPE',
      title: 'Masks, Gloves &\nHexisol Sanitizers',
      subtitle: 'Medical-grade hygiene essentials',
      ctaLabel: 'Explore PPE',
      route: '/category/Safety%20%26%20PPE',
      imageAsset: 'assets/images/hero/hero_pharmacy.jpg',
      accentColor: Color(0xFF0D9488),
      scrimColor: Color(0xFF134E4A),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final next = (_currentIndex + 1) % _slides.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Column(
        children: [
          SizedBox(
            height: 176,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                return _buildSlideCard(context, _slides[index]);
              },
            ),
          ),
          const SizedBox(height: 10),
          // Interactive Dot + Image Thumbnail Strip Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_slides.length, (index) {
              final isActive = index == _currentIndex;
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSlideCard(BuildContext context, HeroSlide slide) {
    return GestureDetector(
      onTap: () => context.push(slide.route),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: slide.scrimColor.withValues(alpha: 0.16),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Real Full-Bleed Hero Photograph
              Image.asset(
                slide.imageAsset,
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              ),
              // Directional Gradient Scrim for Crisp Typography
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.0, 0.58, 1.0],
                    colors: [
                      slide.scrimColor.withValues(alpha: 0.92),
                      slide.scrimColor.withValues(alpha: 0.72),
                      slide.scrimColor.withValues(alpha: 0.12),
                    ],
                  ),
                ),
              ),
              // Foreground Hero Content
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: slide.accentColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        slide.tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          slide.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.h2.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                            height: 1.2,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          slide.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.88),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            slide.ctaLabel,
                            style: TextStyle(
                              color: slide.scrimColor,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: slide.scrimColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

