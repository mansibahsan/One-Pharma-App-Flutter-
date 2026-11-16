import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/data/models/user_model.dart';
import 'package:one_pharma/providers/auth_provider.dart';
import 'package:one_pharma/presentation/widgets/primary_button.dart';
import 'package:one_pharma/presentation/widgets/app_text_field.dart';

class SignInScreen extends ConsumerStatefulWidget {
  final UserRole initialRole;

  const SignInScreen({
    super.key,
    this.initialRole = UserRole.patient,
  });

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  late UserRole _selectedRole;
  late final TextEditingController _emailController;
  final _passwordController = TextEditingController(text: 'password123');
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole;
    _emailController = TextEditingController(
      text: _selectedRole == UserRole.doctor
          ? 'dr.tanjila@onepharma.com'
          : 'hera.rahman@onepharma.com',
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _selectRole(UserRole role) {
    if (_selectedRole == role) return;
    setState(() {
      _selectedRole = role;
      _emailController.text = role == UserRole.doctor
          ? 'dr.tanjila@onepharma.com'
          : 'hera.rahman@onepharma.com';
    });
  }

  void _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await ref
        .read(authProvider.notifier)
        .signIn(email, password, role: _selectedRole);
    setState(() => _isLoading = false);

    if (mounted) {
      if (_selectedRole == UserRole.doctor) {
        context.go('/doctor');
      } else {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDoctor = _selectedRole == UserRole.doctor;
    final accentColor = isDoctor ? const Color(0xFF0D9488) : AppColors.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: accentColor),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Sign In',
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Role Selector Segmented Control
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildRoleSegment(
                        role: UserRole.patient,
                        title: 'Login as Patient',
                        icon: Icons.person_outline_rounded,
                        activeColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildRoleSegment(
                        role: UserRole.doctor,
                        title: 'Login as Doctor',
                        icon: Icons.medical_services_outlined,
                        activeColor: const Color(0xFF0D9488),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Role Context Banner
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isDoctor
                      ? const Color(0xFFCCFBF1).withValues(alpha: 0.65)
                      : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isDoctor
                          ? Icons.verified_user_rounded
                          : Icons.local_pharmacy_rounded,
                      color: accentColor,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isDoctor
                                ? 'Doctor & Clinical Pharmacist Portal'
                                : 'Patient Healthcare & Delivery Portal',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isDoctor
                                ? 'Review uploaded Rx slips, manage consults & issue digital e-Rx'
                                : 'Order medicines, upload prescriptions & track live deliveries',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              AppTextField(
                controller: _emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.mail_outline, color: AppColors.textMuted),
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _passwordController,
                hintText: 'Password',
                isPassword: true,
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password reset link sent to registered email'),
                      ),
                    );
                  },
                  child: Text(
                    'Forgot your password?',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: isDoctor ? 'SIGN IN AS DOCTOR' : 'SIGN IN AS PATIENT',
                backgroundColor: accentColor,
                isLoading: _isLoading,
                onPressed: _handleSignIn,
              ),

              const SizedBox(height: 36),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account? ',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pushReplacement('/sign-up'),
                    child: Text(
                      'Create Account',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSegment({
    required UserRole role,
    required String title,
    required IconData icon,
    required Color activeColor,
  }) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => _selectRole(role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 17,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
