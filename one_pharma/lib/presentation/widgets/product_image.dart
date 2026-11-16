import 'package:flutter/material.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/presentation/widgets/medicine_bottle_art.dart';

/// Displays a product image from a local asset path or a network URL,
/// falling back gracefully if missing or unreadable.
class ProductImage extends StatelessWidget {
  final String? imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color fallbackColor;
  final double fallbackSize;

  const ProductImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackColor = AppColors.primary,
    this.fallbackSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    final path = imagePath?.trim() ?? '';
    Widget content;

    if (path.isEmpty) {
      content = _buildFallback();
    } else if (path.startsWith('http://') || path.startsWith('https://')) {
      content = Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(fallbackColor),
              ),
            ),
          );
        },
        errorBuilder: (_, _, _) => _buildFallback(),
      );
    } else {
      content = Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => _buildFallback(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: content,
      );
    }
    return content;
  }

  Widget _buildFallback() {
    return Center(
      child: MedicineBottleArt(
        size: fallbackSize,
        primaryColor: fallbackColor,
      ),
    );
  }
}

