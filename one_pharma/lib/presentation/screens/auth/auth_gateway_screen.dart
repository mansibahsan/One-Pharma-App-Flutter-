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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Text(
                'Welcome to 1 Pharma\nHealthcare Platform',
                textAlign: TextAlign.center,
                style: AppTextStyles.h1.copyWith(
                  fontSize: 26,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Connect patients with authentic medicines, verified prescriptions, and licensed doctors & pharmacists.',
                textAlign: TextAlign.center,
                style: AppTextStyles.subtitle.copyWith(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(flex: 2),
              PrimaryButton(
                text: 'LOGIN AS PATIENT',
                width: double.infinity,
                icon: const Icon(Icons.person_rounded, size: 18, color: Colors.white),
                onPressed: () => context.push('/sign-in?role=patient'),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: 'LOGIN AS DOCTOR',
                width: double.infinity,
                backgroundColor: const Color(0xFF0D9488),
                textColor: Colors.white,
                icon: const Icon(
                  Icons.medical_services_rounded,
                  size: 18,
                  color: Colors.white,
                ),
                onPressed: () => context.push('/sign-in?role=doctor'),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: 'CREATE AN ACCOUNT',
                width: double.infinity,
                backgroundColor: AppColors.primaryLight,
                textColor: AppColors.primary,
                onPressed: () => context.push('/sign-up'),
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
