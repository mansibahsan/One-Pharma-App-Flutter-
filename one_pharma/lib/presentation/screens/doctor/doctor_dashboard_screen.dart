import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/data/models/prescription_model.dart';
import 'package:one_pharma/providers/auth_provider.dart';
import 'package:one_pharma/providers/consultation_provider.dart';
import 'package:one_pharma/providers/prescription_provider.dart';
import 'doctor_shell_screen.dart';

class DoctorDashboardScreen extends ConsumerWidget {
  const DoctorDashboardScreen({super.key});

  static const Color _docAccent = Color(0xFF0D9488);
  static const Color _docDark = Color(0xFF0F766E);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctor = ref.watch(authProvider).user;
    final clinicians = ref.watch(pharmacistListProvider);
    final isOnline = clinicians.isNotEmpty ? clinicians.first.isOnline : true;

    final appointments = ref.watch(appointmentsProvider);
    final upcomingList = appointments
        .where((a) => a.status == AppointmentStatus.upcoming)
        .toList();

    final prescriptions = ref.watch(prescriptionProvider);
    final pendingRxList = prescriptions
        .where((r) => r.status == PrescriptionStatus.pending)
        .toList();
    final verifiedRxCount = prescriptions
        .where((r) => r.status == PrescriptionStatus.verified)
        .length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            // Top Clinician Bar
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFCCFBF1),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/hero/hero_teleconsult.jpg',
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.medical_services_rounded,
                        color: _docAccent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              doctor?.name ?? 'Dr. Tanjila Ahmed, PharmD',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.h3.copyWith(fontSize: 15),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified_rounded,
                            size: 16,
                            color: _docAccent,
                          ),
                        ],
                      ),
                      Text(
                        '${doctor?.specialty.isNotEmpty == true ? doctor!.specialty : "Clinical Pharmacist"} • #${doctor?.licenseNumber.isNotEmpty == true ? doctor!.licenseNumber : "REG-DH-849204"}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Notifications',
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: _docAccent,
                    size: 26,
                  ),
                  onPressed: () => context.push('/notifications'),
                ),
                IconButton(
                  tooltip: 'Log Out',
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.textSecondary,
                    size: 22,
                  ),
                  onPressed: () {
                    ref.read(authProvider.notifier).signOut();
                    context.go('/auth-gateway');
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Hero Status Banner + Availability Toggle
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_docDark, _docAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: _docAccent.withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isOnline ? 'ACCEPTING CONSULTS' : 'OFF DUTY',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            isOnline ? 'Online' : 'Offline',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Switch(
                            value: isOnline,
                            activeThumbColor: Colors.white,
                            activeTrackColor: const Color(0xFF34D399),
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
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Clinical Workspace & e-Rx Hub',
                    style: AppTextStyles.h2.copyWith(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Verify uploaded prescriptions, conduct teleconsultations, and issue digital e-prescriptions straight to patient vaults.',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontSize: 11.5,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => context.push('/doctor/write-rx'),
                          icon: const Icon(Icons.edit_document, size: 15),
                          label: const Text(
                            'Write e-Rx',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: _docDark,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              ref.read(doctorShellTabProvider.notifier).state = 2,
                          icon: const Icon(Icons.fact_check_outlined, size: 15),
                          label: Text(
                            'Rx Queue (${pendingRxList.length})',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 3 KPI Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    title: 'Pending Rx',
                    value: '${pendingRxList.length}',
                    subtitle: 'Needs Audit',
                    icon: Icons.pending_actions_rounded,
                    color: const Color(0xFFD97706),
                    bgColor: const Color(0xFFFEF3C7),
                    onTap: () => ref.read(doctorShellTabProvider.notifier).state = 2,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildKpiCard(
                    title: 'Consults',
                    value: '${upcomingList.length}',
                    subtitle: 'Scheduled',
                    icon: Icons.videocam_rounded,
                    color: const Color(0xFF2563EB),
                    bgColor: const Color(0xFFDBEAFE),
                    onTap: () => ref.read(doctorShellTabProvider.notifier).state = 1,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildKpiCard(
                    title: 'Verified e-Rx',
                    value: '$verifiedRxCount',
                    subtitle: 'Active Vault',
                    icon: Icons.verified_rounded,
                    color: _docAccent,
                    bgColor: const Color(0xFFCCFBF1),
                    onTap: () => ref.read(doctorShellTabProvider.notifier).state = 2,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // Pending Rx Verification Preview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Pending Prescription Audits',
                    style: AppTextStyles.h3.copyWith(fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      ref.read(doctorShellTabProvider.notifier).state = 2,
                  child: const Text(
                    'View All',
                    style: TextStyle(color: _docAccent, fontSize: 12),
                  ),
                ),
              ],
            ),
            if (pendingRxList.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, color: _docAccent),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'All patient-uploaded prescriptions have been verified!',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...pendingRxList.take(2).map((rx) => _buildPendingRxTile(context, ref, rx)),

            const SizedBox(height: 20),

            // Next Patient Consultation Preview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Upcoming Patient Consultations',
                    style: AppTextStyles.h3.copyWith(fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      ref.read(doctorShellTabProvider.notifier).state = 1,
                  child: const Text(
                    'Full Schedule',
                    style: TextStyle(color: _docAccent, fontSize: 12),
                  ),
                ),
              ],
            ),
            if (upcomingList.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('No upcoming consultations scheduled.'),
              )
            else
              ...upcomingList.take(2).map(
                    (appt) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderSubtle),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color(0xFFCCFBF1),
                                child: Text(
                                  appt.patientName[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: _docDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appt.patientName,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${appt.patientAgeGender} • ${appt.date} at ${appt.time}',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDBEAFE),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  appt.mode,
                                  style: const TextStyle(
                                    color: Color(0xFF2563EB),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Reason: ${appt.chiefComplaint}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => context.push(
                                    '/doctor/write-rx?patient=${Uri.encodeComponent(appt.patientName)}',
                                  ),
                                  icon: const Icon(Icons.edit_note_rounded, size: 16),
                                  label: const Text('Issue e-Rx'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: _docAccent,
                                    side: const BorderSide(color: _docAccent),
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => context.push('/teleconsult-call'),
                                  icon: const Icon(Icons.videocam_rounded, size: 16),
                                  label: const Text('Join Call'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _docAccent,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: AppTextStyles.h2.copyWith(fontSize: 20, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 11.5,
              ),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingRxTile(BuildContext context, WidgetRef ref, PrescriptionModel rx) {
    final doctor = ref.read(authProvider).user;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.assignment_late_rounded, color: Color(0xFFD97706), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${rx.patientName} • ${rx.title}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'PENDING',
                  style: TextStyle(
                    color: Color(0xFFB45309),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Items: ${rx.linkedMedicines.map((m) => "${m.name} (${m.selectedStrength})").join(", ")}',
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton.icon(
              onPressed: () {
                ref.read(prescriptionProvider.notifier).verifyPrescription(
                      rx.id,
                      doctorName: doctor?.name ?? 'Dr. Tanjila Ahmed, PharmD',
                      doctorSpecialty: doctor?.specialty ?? 'Clinical Pharmacist Specialist',
                      hospital: doctor?.hospital ?? 'Evercare Hospital Dhaka',
                    );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Verified ${rx.title} for ${rx.patientName}!'),
                    backgroundColor: _docAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.verified_rounded, size: 16),
              label: const Text('Verify & Approve Digital Rx'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _docAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
