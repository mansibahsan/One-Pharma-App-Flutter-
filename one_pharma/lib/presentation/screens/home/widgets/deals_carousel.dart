import 'package:flutter/material.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/presentation/widgets/medicine_bottle_art.dart';

class DealsCarousel extends StatelessWidget {
  final ValueChanged<String>? onDealTap;

  const DealsCarousel({super.key, this.onDealTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 135,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        children: [
          _buildDealBanner(
            category: 'VITAMINS',
            title: 'Multivitamins',
            subtitle: 'Immunity Boost',
            discount: '45% OFF',
            price: r'$56.00',
            originalPrice: r'$80.00',
            imageUrl:
                'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?auto=format&fit=crop&w=400&q=80',
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF0F2), Color(0xFFFFDDE1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            accentColor: AppColors.primary,
            onTap: () => onDealTap?.call('prod_goof_vitas'),
          ),
          const SizedBox(width: 14),
          _buildDealBanner(
            category: 'AYURVEDA',
            title: 'Herbal Care',
            subtitle: '100% Organic',
            discount: '45% OFF',
            price: r'$89.00',
            originalPrice: r'$90.00',
            imageUrl:
                'https://images.unsplash.com/photo-1550572017-edd951b55104?auto=format&fit=crop&w=400&q=80',
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF6ED), Color(0xFFFFE5D0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            accentColor: const Color(0xFFF79009),
            onTap: () => onDealTap?.call('prod_betulin_lux'),
          ),
          const SizedBox(width: 14),
          _buildDealBanner(
            category: 'DAILY CARE',
            title: 'Allergy Relief',
            subtitle: 'Fast Action',
            discount: '20% OFF',
            price: r'$38.00',
            originalPrice: r'$56.00',
            imageUrl:
                'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80',
            gradient: const LinearGradient(
              colors: [Color(0xFFEDF6FF), Color(0xFFD6EBFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            accentColor: const Color(0xFF2E90FA),
            onTap: () => onDealTap?.call('prod_plastic_oi'),
          ),
        ],
      ),
    );
  }

  Widget _buildDealBanner({
    required String category,
    required String title,
    required String subtitle,
    required String discount,
    required String price,
    required String originalPrice,
    required String imageUrl,
    required LinearGradient gradient,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 235,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Discount Tag Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      discount,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 9.5,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.h3.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                  // Price row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        price,
                        style: AppTextStyles.priceLarge.copyWith(
                          fontSize: 14,
                          color: accentColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        originalPrice,
                        style: AppTextStyles.priceOriginal.copyWith(fontSize: 10.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Right Product Picture Banner
            Stack(
              alignment: Alignment.center,
              children: [
                // Soft background glow circle
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.9),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                // Real product photo
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => MedicineBottleArt(
                      size: 48,
                      primaryColor: accentColor,
                      hasCapsule: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}