import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/presentation/widgets/primary_button.dart';

class AuthGatewayScreen extends StatelessWidget {
  const AuthGatewayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Text(
                'Start by creating an\naccount.',
                textAlign: TextAlign.center,
                style: AppTextStyles.h1.copyWith(
                  fontSize: 28,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Access fast medicine delivery, prescription uploads, and authentic healthcare products anytime.',
                textAlign: TextAlign.center,
                style: AppTextStyles.subtitle.copyWith(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(flex: 3),
              PrimaryButton(
                text: 'CREATE AN ACCOUNT',
                onPressed: () => context.push('/sign-up'),
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                text: 'SIGN IN',
                backgroundColor: AppColors.primaryLight,
                textColor: AppColors.primary,
                onPressed: () => context.push('/sign-in'),
              ),
              const Spacer(flex: 1),
              Opacity(
                opacity: 0.15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.science_outlined, color: AppColors.primary, size: 24),
                    Icon(Icons.add_circle_outline, color: AppColors.primary, size: 24),
                    Icon(Icons.medication_outlined, color: AppColors.primary, size: 24),
                    Icon(Icons.favorite_border, color: AppColors.primary, size: 24),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
