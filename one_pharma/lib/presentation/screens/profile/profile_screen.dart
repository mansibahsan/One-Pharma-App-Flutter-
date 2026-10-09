import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/providers/auth_provider.dart';
import 'package:one_pharma/providers/order_provider.dart';
import 'package:one_pharma/providers/prescription_provider.dart';
import 'package:one_pharma/providers/reminder_provider.dart';
import 'package:one_pharma/providers/wishlist_provider.dart';
import 'package:one_pharma/providers/address_provider.dart';
import 'package:one_pharma/presentation/widgets/primary_button.dart';
import 'package:one_pharma/presentation/widgets/app_text_field.dart';
import 'package:one_pharma/presentation/widgets/demo_mode_sheet.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _nameController = TextEditingController(text: user?.name ?? 'Heluz Juan');
    _phoneController = TextEditingController(text: user?.phone ?? '0569 - 8963 - 5632');
    _emailController = TextEditingController(text: user?.email ?? 'deom123@gmail.com');
    _addressController = TextEditingController(
      text: user?.address ?? 'House # 60 , Sector #12, Road# 20\nDhaka-1230',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 600));

    ref.read(authProvider.notifier).updateProfile(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          address: _addressController.text.trim(),
        );

    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile details updated successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final orderCount = ref.watch(ordersProvider).length;
    final rxCount = ref.watch(prescriptionProvider).length;
    final wishlistCount = ref.watch(wishlistProvider).length;
    final addressCount = ref.watch(addressProvider).length;
    final reminderCount = ref.watch(reminderProvider).length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'My Profile & Hub',
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF7C3AED)),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (ctx) => const DemoModeSheet(),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        (user?.name.isNotEmpty == true)
                            ? user!.name[0].toUpperCase()
                            : 'H',
                        style: AppTextStyles.h1.copyWith(
                          color: AppColors.primary,
                          fontSize: 34,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_user_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                user?.name ?? 'Heluz Juan',
                style: AppTextStyles.h2.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 2),
              Text(
                user?.role ?? 'Verified Patient • Dhaka, BD',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 18),

              // Activity Stats Cards
              Row(
                children: [
                  _buildStatTile('Orders', '$orderCount', Icons.receipt_long_rounded, () => context.go('/orders')),
                  const SizedBox(width: 8),
                  _buildStatTile('Prescriptions', '$rxCount', Icons.health_and_safety_rounded, () => context.push('/prescriptions')),
                  const SizedBox(width: 8),
                  _buildStatTile('Pill Alerts', '$reminderCount', Icons.alarm_on_rounded, () => context.push('/reminders')),
                  const SizedBox(width: 8),
                  _buildStatTile('Saved Meds', '$wishlistCount', Icons.favorite_border_rounded, () => context.push('/wishlist')),
                  const SizedBox(width: 8),
                  _buildStatTile('Addresses', '$addressCount', Icons.location_on_outlined, () => context.push('/addresses')),
                ],
              ),

              const SizedBox(height: 16),

              // Demo Switcher Banner
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) => const DemoModeSheet(),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 22),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Interactive Demo Persona',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'Switch between New Patient, Regular, Chronic Care',
                                  style: TextStyle(color: Colors.white70, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'SWITCH',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 20),

              // Full Name
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Full Name', style: AppTextStyles.h3.copyWith(fontSize: 14)),
              ),
              const SizedBox(height: 6),
              AppTextField(
                controller: _nameController,
                hintText: 'Full Name',
              ),
              const SizedBox(height: 16),

              // Contact Number
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Contact Number', style: AppTextStyles.h3.copyWith(fontSize: 14)),
              ),
              const SizedBox(height: 6),
              AppTextField(
                controller: _phoneController,
                hintText: 'Contact Number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Email Address
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Email Address', style: AppTextStyles.h3.copyWith(fontSize: 14)),
              ),
              const SizedBox(height: 6),
              AppTextField(
                controller: _emailController,
                hintText: 'Email Address',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Address
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Default Delivery Address', style: AppTextStyles.h3.copyWith(fontSize: 14)),
              ),
              const SizedBox(height: 6),
              AppTextField(
                controller: _addressController,
                hintText: 'Delivery Address',
                maxLines: 2,
              ),
              const SizedBox(height: 28),

              // Update Profile CTA
              PrimaryButton(
                text: 'UPDATE PROFILE',
                isLoading: _isSaving,
                onPressed: _saveProfile,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatTile(String label, String value, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: Material(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
