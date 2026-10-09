import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/providers/auth_provider.dart';
import 'package:one_pharma/providers/prescription_provider.dart';
import 'package:one_pharma/providers/reminder_provider.dart';
import 'package:one_pharma/providers/wishlist_provider.dart';
import 'package:one_pharma/presentation/widgets/demo_mode_sheet.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final rxCount = ref.watch(prescriptionProvider).where((p) => p.isValid).length;
    final reminderCount = ref.watch(reminderProvider).length;
    final wishlistCount = ref.watch(wishlistProvider).length;

    return Drawer(
      backgroundColor: Colors.white,
      elevation: 16,
      child: Column(
        children: [
          // Header Red Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white.withValues(alpha: 0.25),
                  child: const Icon(
                    Icons.person,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Geelus Deen',
                        style: AppTextStyles.h3.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user?.email ?? 'demodesign@gmail.com',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Demo Mode Banner Tile
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
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
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Navigator.of(context).pop();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (ctx) => const DemoModeSheet(),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Demo Persona Switcher',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Switch customer scenarios live',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'PITCH',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
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

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 6),
              children: [
                _buildMenuItem(
                  icon: Icons.health_and_safety_rounded,
                  label: 'Prescription Vault',
                  badgeText: rxCount > 0 ? '$rxCount Active' : null,
                  badgeColor: const Color(0xFF2563EB),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/prescriptions');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.alarm_on_rounded,
                  label: 'Pill Reminders & Schedule',
                  badgeText: reminderCount > 0 ? '$reminderCount Meds' : null,
                  badgeColor: const Color(0xFFD97706),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/reminders');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.medical_services_rounded,
                  label: 'Consult Pharmacist',
                  badgeText: 'Live',
                  badgeColor: const Color(0xFF16A34A),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/consult');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.favorite_border_rounded,
                  label: 'Saved Medicines',
                  badgeText: wishlistCount > 0 ? '$wishlistCount' : null,
                  badgeColor: AppColors.primary,
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/wishlist');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.location_on_outlined,
                  label: 'Delivery Addresses',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/addresses');
                  },
                ),
                const Divider(height: 12, color: AppColors.divider),
                _buildMenuItem(
                  icon: Icons.document_scanner_rounded,
                  label: 'Upload Prescription',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/prescription-upload');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.shopping_bag_outlined,
                  label: 'My Orders',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go('/orders');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.person_outline_rounded,
                  label: 'My Profile & Account',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/profile');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.discount_outlined,
                  label: 'Offers & Discounts',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/notifications');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.headset_mic_outlined,
                  label: 'Help & 24/7 Support',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/support-chat');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.rate_review_outlined,
                  label: 'Feedback & Review',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/review');
                  },
                ),
              ],
            ),
          ),

          // Divider & Log Out
          const Divider(height: 1, color: AppColors.divider),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            leading: const Icon(
              Icons.logout_rounded,
              color: AppColors.textSecondary,
              size: 22,
            ),
            title: Text(
              'Log Out',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              ref.read(authProvider.notifier).signOut();
              context.go('/auth-gateway');
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    String? badgeText,
    Color badgeColor = AppColors.primary,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      leading: Icon(
        icon,
        color: AppColors.textSecondary,
        size: 22,
      ),
      title: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
      trailing: badgeText != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}
