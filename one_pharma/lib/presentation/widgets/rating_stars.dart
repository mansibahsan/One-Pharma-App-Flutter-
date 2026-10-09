import 'package:flutter/material.dart';
import 'package:one_pharma/core/theme/app_colors.dart';

class RatingStarsSelector extends StatelessWidget {
  final int rating;
  final ValueChanged<int>? onRatingChanged;
  final double size;

  const RatingStarsSelector({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isFilled = starIndex <= rating;
        return GestureDetector(
          onTap: onRatingChanged != null ? () => onRatingChanged!(starIndex) : null,
          child: Padding(
            padding: const EdgeInsets.only(right: 3),
            child: Icon(
              Icons.star_rounded,
              size: size,
              color: isFilled ? AppColors.primary : AppColors.border,
            ),
          ),
        );
      }),
    );
  }
}
