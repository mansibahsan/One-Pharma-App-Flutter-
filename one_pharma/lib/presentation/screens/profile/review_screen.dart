import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/presentation/widgets/primary_button.dart';
import 'package:one_pharma/presentation/widgets/rating_stars.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _supportRating = 5;
  int _functionalityRating = 4;
  int _communicationRating = 5;
  int _packagingRating = 4;
  final TextEditingController _commentController = TextEditingController(
    text: 'Great customer support and lightning fast medicine home delivery.',
  );
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you! Your feedback has been submitted successfully.'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Submit Review',
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Give Review',
                style: AppTextStyles.h3.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // 2x2 Grid of Ratings matching Mockup 5
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildRatingBlock(
                      'Support',
                      _supportRating,
                      (r) => setState(() => _supportRating = r),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildRatingBlock(
                      'Functionality',
                      _functionalityRating,
                      (r) => setState(() => _functionalityRating = r),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildRatingBlock(
                      'Communication',
                      _communicationRating,
                      (r) => setState(() => _communicationRating = r),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildRatingBlock(
                      'Packaging / Delivery',
                      _packagingRating,
                      (r) => setState(() => _packagingRating = r),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Comment Section
              Text(
                'Your Comment',
                style: AppTextStyles.h3.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _commentController,
                  maxLines: 5,
                  style: AppTextStyles.bodyMedium,
                  decoration: const InputDecoration(
                    hintText: 'Share your experience with our medicines and delivery...',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Submit Button
              PrimaryButton(
                text: 'SUBMIT REVIEW',
                isLoading: _isSubmitting,
                onPressed: _submitReview,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBlock(String title, int rating, ValueChanged<int> onRatingChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        RatingStarsSelector(
          rating: rating,
          size: 20,
          onRatingChanged: onRatingChanged,
        ),
      ],
    );
  }
}
