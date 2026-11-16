import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/data/models/prescription_model.dart';
import 'package:one_pharma/providers/auth_provider.dart';
import 'package:one_pharma/providers/prescription_provider.dart';
import 'package:one_pharma/presentation/widgets/product_image.dart';

class DoctorPrescriptionsScreen extends ConsumerStatefulWidget {
  const DoctorPrescriptionsScreen({super.key});

  @override
  ConsumerState<DoctorPrescriptionsScreen> createState() =>
      _DoctorPrescriptionsScreenState();
}

class _DoctorPrescriptionsScreenState extends ConsumerState<DoctorPrescriptionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static const Color _docAccent = Color(0xFF0D9488);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prescriptions = ref.watch(prescriptionProvider);
    final pendingList = prescriptions
        .where((p) => p.status == PrescriptionStatus.pending)
        .toList();
    final verifiedList = prescriptions
        .where((p) => p.status == PrescriptionStatus.verified)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Prescription Audit & e-Rx',
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: _docAccent,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: _docAccent,
          indicatorWeight: 3,
          labelStyle: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: 'Pending Audit (${pendingList.length})'),
            Tab(text: 'Verified e-Rx (${verifiedList.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(pendingList, isPending: true),
          _buildList(verifiedList, isPending: false),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/doctor/write-rx'),
        backgroundColor: _docAccent,
        icon: const Icon(Icons.edit_document, color: Colors.white),
        label: const Text(
          'Write Digital e-Rx',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildList(List<PrescriptionModel> list, {required bool isPending}) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPending ? Icons.task_alt_rounded : Icons.receipt_long_rounded,
                size: 52,
                color: _docAccent,
              ),
              const SizedBox(height: 14),
              Text(
                isPending ? 'No Pending Slips to Audit' : 'No Verified Prescriptions',
                style: AppTextStyles.h3.copyWith(fontSize: 17),
              ),
              const SizedBox(height: 6),
              Text(
                isPending
                    ? 'When a patient uploads an Rx slip, it appears here for clinical verification.'
                    : 'Issue a new Digital e-Rx using the button below.',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
      itemCount: list.length,
      itemBuilder: (context, index) => _buildRxCard(context, list[index], isPending),
    );
  }

  Widget _buildRxCard(BuildContext context, PrescriptionModel rx, bool isPending) {
    final doctor = ref.read(authProvider).user;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isPending ? const Color(0xFFFDE68A) : AppColors.borderSubtle,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isPending
                      ? const Color(0xFFFEF3C7)
                      : const Color(0xFFCCFBF1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isPending
                      ? Icons.pending_actions_rounded
                      : Icons.verified_rounded,
                  color: isPending ? const Color(0xFFD97706) : _docAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rx.title,
                      style: AppTextStyles.h3.copyWith(fontSize: 15),
                    ),
                    Text(
                      'Patient: ${rx.patientName} • ${rx.hospital}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPending
                      ? const Color(0xFFFEF3C7)
                      : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  rx.status.label,
                  style: TextStyle(
                    color: isPending
                        ? const Color(0xFFD97706)
                        : const Color(0xFF16A34A),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Linked Medications (${rx.linkedMedicines.length}):',
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...rx.linkedMedicines.map(
            (med) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  ProductImage(
                    imagePath: med.imageUrl,
                    width: 34,
                    height: 34,
                    borderRadius: BorderRadius.circular(8),
                    fallbackSize: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${med.name} ${med.selectedStrength} (${med.brand})',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '\$${med.price.toStringAsFixed(2)}',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _docAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (rx.notes.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Clinical Note: ${rx.notes}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push('/prescriptions/${rx.id}'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _docAccent,
                    side: const BorderSide(color: _docAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Inspect Slip'),
                ),
              ),
              if (isPending) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showRejectDialog(context, rx),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Return Slip'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(prescriptionProvider.notifier).verifyPrescription(
                            rx.id,
                            doctorName:
                                doctor?.name ?? 'Dr. Tanjila Ahmed, PharmD',
                            doctorSpecialty: doctor?.specialty ??
                                'Clinical Pharmacist Specialist',
                            hospital:
                                doctor?.hospital ?? 'Evercare Hospital Dhaka',
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Approved & digitally signed ${rx.title} for ${rx.patientName}',
                          ),
                          backgroundColor: _docAccent,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.verified_rounded, size: 15),
                    label: const Text('Approve Rx'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _docAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context, PrescriptionModel rx) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Return Prescription Slip'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select the clinical reason for requesting a new upload from the patient:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            ...[
              'Illegible handwriting / dosage unclear',
              'Missing physician BMDC seal or date',
              'Medication strength requires confirmation',
            ].map(
              (reason) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.report_problem_outlined,
                  color: AppColors.error,
                  size: 18,
                ),
                title: Text(reason, style: const TextStyle(fontSize: 12.5)),
                onTap: () {
                  ref.read(prescriptionProvider.notifier).removePrescription(rx.id);
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Returned slip to ${rx.patientName}: $reason'),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

