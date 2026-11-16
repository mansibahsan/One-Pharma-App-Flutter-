import 'package:flutter/material.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/presentation/widgets/product_image.dart';

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
            category: 'SAFETY & PPE',
            title: '3-Ply Face Masks',
            subtitle: 'Box of 50 • BFE 98%',
            discount: '33% OFF',
            price: r'$8.00',
            originalPrice: r'$12.00',
            imagePath: 'assets/images/products/surgical_mask.jpg',
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF0F2), Color(0xFFFFDDE1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            accentColor: AppColors.primary,
            onTap: () => onDealTap?.call('prod_surgical_mask'),
          ),
          const SizedBox(width: 14),
          _buildDealBanner(
            category: 'ANTISEPTIC',
            title: 'Hexisol Hand Rub',
            subtitle: '500ml Hospital Grade',
            discount: '24% OFF',
            price: r'$9.50',
            originalPrice: r'$12.50',
            imagePath: 'assets/images/products/hexisol_antiseptic.jpg',
            gradient: const LinearGradient(
              colors: [Color(0xFFECFEFF), Color(0xFFCFFAFE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            accentColor: const Color(0xFF0D9488),
            onTap: () => onDealTap?.call('prod_hexisol_rub'),
          ),
          const SizedBox(width: 14),
          _buildDealBanner(
            category: 'VITAMINS',
            title: 'Daily Multivitamin',
            subtitle: 'Immunity & Zinc',
            discount: '25% OFF',
            price: r'$18.00',
            originalPrice: r'$24.00',
            imagePath: 'assets/images/products/multivitamin_bottle.jpg',
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF6ED), Color(0xFFFFE5D0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            accentColor: const Color(0xFFF79009),
            onTap: () => onDealTap?.call('prod_centrum_multi'),
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
    required String imagePath,
    required LinearGradient gradient,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 245,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
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
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 78,
                  height: 78,
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
                ProductImage(
                  imagePath: imagePath,
                  width: 74,
                  height: 74,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(16),
                  fallbackColor: accentColor,
                  fallbackSize: 48,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
