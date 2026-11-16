import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/data/mock/mock_data.dart';
import 'package:one_pharma/data/models/prescription_model.dart';
import 'package:one_pharma/providers/auth_provider.dart';
import 'package:one_pharma/providers/prescription_provider.dart';
import 'package:one_pharma/presentation/widgets/primary_button.dart';

class PrescriptionUploadScreen extends ConsumerStatefulWidget {
  const PrescriptionUploadScreen({super.key});

  @override
  ConsumerState<PrescriptionUploadScreen> createState() =>
      _PrescriptionUploadScreenState();
}

class _PrescriptionUploadScreenState
    extends ConsumerState<PrescriptionUploadScreen> {
  bool _isAttached = false;
  String? _fileName;
  bool _isUploading = false;

  void _simulatePickImage() {
    setState(() {
      _isAttached = true;
      _fileName = 'Doc_Prescription_${DateTime.now().millisecondsSinceEpoch}.jpg';
    });
  }

  void _handleUpload() async {
    if (!_isAttached) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a prescription document first')),
      );
      return;
    }

    setState(() => _isUploading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isUploading = false);

    final user = ref.read(authProvider).user;
    final newRx = PrescriptionModel(
      id: 'rx_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Uploaded Slip • ${_fileName ?? "Rx Document"}',
      patientName: user?.name ?? 'Hera Rahman',
      doctorName: 'Pending Doctor Audit',
      doctorSpecialty: 'Awaiting Clinical Verification',
      hospital: 'Patient Uploaded Slip',
      issueDate: DateTime.now(),
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      status: PrescriptionStatus.pending,
      fileUrl: 'assets/images/products/antibiotic_tablets.jpg',
      linkedMedicines: [
        MockData.products[7], // Zimax 500mg
        MockData.products[0], // Napa Extend
      ],
      notes: 'Uploaded by patient for doctor verification and order approval.',
    );
    ref.read(prescriptionProvider.notifier).addPrescription(newRx);

    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppColors.success),
              SizedBox(width: 8),
              Expanded(child: Text('Sent for Doctor Review')),
            ],
          ),
          content: const Text(
            'Your prescription slip has been added to the Doctor Review Queue. Once verified by a clinician, it will appear as Verified in your Prescription Vault.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                context.pushReplacement('/prescriptions');
              },
              child: const Text('View Vault'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                context.go('/home');
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Prescription Upload',
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Address Card
              Text('Delivery Address', style: AppTextStyles.h3.copyWith(fontSize: 15)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.home_outlined, color: AppColors.textPrimary, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Hera Rahman',
                            style: AppTextStyles.h3.copyWith(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.address ?? 'House#28, Road#30, Sector#10, Dhaka 1230',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.edit_outlined, size: 18, color: AppColors.textMuted),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Contact Number Card
              Text('Contact Number', style: AppTextStyles.h3.copyWith(fontSize: 15)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone_outlined, color: AppColors.textPrimary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        user?.phone ?? '0569 - 8963 - 5632',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Icon(Icons.edit_outlined, size: 18, color: AppColors.textMuted),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Upload Prescription
              Text('Upload Prescription', style: AppTextStyles.h3.copyWith(fontSize: 15)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _simulatePickImage,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isAttached ? AppColors.success : AppColors.border,
                      width: _isAttached ? 1.5 : 1,
                    ),
                  ),
                  child: _isAttached
                      ? Row(
                          children: [
                            Container(
                              width: 60,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Icon(
                                Icons.description_outlined,
                                color: AppColors.primary,
                                size: 36,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _fileName!,
                                    style: AppTextStyles.h3.copyWith(fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '1.4 MB • Ready to submit',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: AppColors.error),
                              onPressed: () {
                                setState(() {
                                  _isAttached = false;
                                  _fileName = null;
                                });
                              },
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.camera_alt_outlined,
                              size: 32,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to capture or choose prescription',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '590x600 or larger recommended up to 2MB each',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const Spacer(),

              // Primary Upload Button
              PrimaryButton(
                text: 'UPLOAD NOW',
                isLoading: _isUploading,
                onPressed: _handleUpload,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
