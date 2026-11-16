import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/presentation/screens/shell/main_shell_screen.dart';
import 'package:one_pharma/presentation/widgets/primary_button.dart';

class EmptyCartView extends ConsumerWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mockup 4 illustration with locked capsule icon
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'Your Medicine Bag is Empty',
              textAlign: TextAlign.center,
              style: AppTextStyles.h3.copyWith(
                fontSize: 18,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              'Browse our verified catalog of prescription and OTC healthcare products to get started.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            PrimaryButton(
              text: 'BROWSE MEDICINES',
              width: 220,
              onPressed: () {
                ref.read(mainShellTabProvider.notifier).state = 0;
                if (GoRouter.maybeOf(context) != null) {
                  context.go('/home');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
