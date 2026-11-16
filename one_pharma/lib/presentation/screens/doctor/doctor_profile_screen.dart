import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/data/mock/mock_data.dart';
import 'package:one_pharma/providers/auth_provider.dart';
import 'package:one_pharma/providers/consultation_provider.dart';

class DoctorProfileScreen extends ConsumerWidget {
  const DoctorProfileScreen({super.key});

  static const Color _docAccent = Color(0xFF0D9488);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctor = ref.watch(authProvider).user ?? MockData.currentDoctor;
    final clinicians = ref.watch(pharmacistListProvider);
    final firstDoc = clinicians.isNotEmpty ? clinicians.first : null;
    final isOnline = firstDoc?.isOnline ?? true;
    final activeSlots = firstDoc?.availableSlots ?? const ['10:00 AM', '11:30 AM', '03:00 PM'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Clinician Profile & Credentials',
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: const Color(0xFFCCFBF1),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/hero/hero_teleconsult.jpg',
                        width: 88,
                        height: 88,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.medical_services_rounded,
                          size: 40,
                          color: _docAccent,
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
                        color: _docAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                doctor.name,
                style: AppTextStyles.h2.copyWith(fontSize: 20),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                doctor.role,
                style: AppTextStyles.caption.copyWith(
                  color: _docAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Monthly Clinical Summary Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Consults', '48', 'This Month'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard('Rating', '4.9 ★', '142 Reviews'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard('Earnings', '\$720', 'Settled'),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Interactive Time-Slot Manager
            Text(
              'Consultation Time Slots (Live Sync)',
              style: AppTextStyles.h3.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to enable or disable booking slots visible to patients',
              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                '09:30 AM',
                '10:00 AM',
                '11:30 AM',
                '03:00 PM',
                '04:30 PM',
                '07:00 PM',
                '08:30 PM',
              ].map((slot) {
                final isEnabled = activeSlots.contains(slot);
                return FilterChip(
                  label: Text(slot),
                  selected: isEnabled,
                  selectedColor: const Color(0xFFCCFBF1),
                  checkmarkColor: _docAccent,
                  labelStyle: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: isEnabled ? _docAccent : AppColors.textSecondary,
                  ),
                  onSelected: (_) {
                    if (firstDoc != null) {
                      ref
                          .read(pharmacistListProvider.notifier)
                          .toggleSlot(firstDoc.id, slot);
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Credentials Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.scaffoldBackground,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    Icons.badge_outlined,
                    'Registration / License',
                    doctor.licenseNumber.isNotEmpty
                        ? doctor.licenseNumber
                        : 'REG-DH-849204',
                  ),
                  const Divider(height: 20),
                  _buildInfoRow(
                    Icons.local_hospital_outlined,
                    'Primary Hospital',
                    doctor.hospital.isNotEmpty
                        ? doctor.hospital
                        : 'Evercare Hospital Dhaka',
                  ),
                  const Divider(height: 20),
                  _buildInfoRow(
                    Icons.medical_information_outlined,
                    'Clinical Specialty',
                    doctor.specialty.isNotEmpty
                        ? doctor.specialty
                        : 'Clinical Pharmacist & Diabetes Care',
                  ),
                  const Divider(height: 20),
                  _buildInfoRow(
                    Icons.attach_money_rounded,
                    'Consultation Fee',
                    '\$15.00 / session',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Availability Toggle Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFCCFBF1).withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _docAccent.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.wifi_tethering_rounded, color: _docAccent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Live Teleconsult Availability',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isOnline
                              ? 'Shown as Online to Patients'
                              : 'Currently Offline',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isOnline,
                    activeThumbColor: _docAccent,
                    onChanged: (_) {
                      if (clinicians.isNotEmpty) {
                        ref
                            .read(pharmacistListProvider.notifier)
                            .toggleOnlineStatus(clinicians.first.id);
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Sign Out
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(authProvider.notifier).signOut();
                  context.go('/auth-gateway');
                },
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                label: const Text(
                  'LOG OUT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _docAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.h3.copyWith(fontSize: 16, color: _docAccent),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 9.5, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: _docAccent),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              ),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

