import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/data/mock/mock_data.dart';
import 'package:one_pharma/data/models/prescription_model.dart';
import 'package:one_pharma/providers/auth_provider.dart';
import 'package:one_pharma/providers/prescription_provider.dart';
import 'package:one_pharma/presentation/widgets/product_image.dart';

class WritePrescriptionScreen extends ConsumerStatefulWidget {
  final String? initialPatientName;

  const WritePrescriptionScreen({super.key, this.initialPatientName});

  @override
  ConsumerState<WritePrescriptionScreen> createState() =>
      _WritePrescriptionScreenState();
}

class _WritePrescriptionScreenState extends ConsumerState<WritePrescriptionScreen> {
  static const Color _docAccent = Color(0xFF0D9488);

  late final TextEditingController _patientController;
  final TextEditingController _titleController =
      TextEditingController(text: 'Respiratory & Fever Regimen');
  final TextEditingController _notesController = TextEditingController(
    text: 'Take after meals with warm water. Complete the full prescribed course.',
  );

  final Set<String> _selectedProductIds = {
    'prod_napa_extend',
    'prod_cough_syrup',
  };
  String _selectedFrequency = '1+0+1 (Twice Daily)';
  final String _selectedTiming = 'After Meal';
  String _selectedDuration = '7 Days';

  void _syncNotesFromRegimen() {
    _notesController.text =
        'Dosage: $_selectedFrequency • $_selectedTiming • Duration: $_selectedDuration. Drink plenty of water.';
  }

  @override
  void initState() {
    super.initState();
    _patientController = TextEditingController(
      text: widget.initialPatientName ?? 'Hera Rahman',
    );
  }

  @override
  void dispose() {
    _patientController.dispose();
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleIssueRx() {
    final selectedMeds = MockData.products
        .where((p) => _selectedProductIds.contains(p.id))
        .toList();

    if (selectedMeds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least 1 medicine')),
      );
      return;
    }

    final doctor = ref.read(authProvider).user;
    final newRx = PrescriptionModel(
      id: 'rx_doc_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim().isNotEmpty
          ? _titleController.text.trim()
          : 'Digital e-Prescription',
      patientName: _patientController.text.trim().isNotEmpty
          ? _patientController.text.trim()
          : 'Hera Rahman',
      doctorName: doctor?.name ?? 'Dr. Tanjila Ahmed, PharmD',
      doctorSpecialty:
          doctor?.specialty.isNotEmpty == true ? doctor!.specialty : 'Clinical Pharmacist Specialist',
      hospital:
          doctor?.hospital.isNotEmpty == true ? doctor!.hospital : 'Evercare Hospital Dhaka',
      issueDate: DateTime.now(),
      expiryDate: DateTime.now().add(const Duration(days: 60)),
      status: PrescriptionStatus.verified,
      fileUrl: selectedMeds.first.imageUrl ?? 'assets/images/products/paracetamol_tablets.jpg',
      linkedMedicines: selectedMeds,
      notes: _notesController.text.trim(),
    );

    ref.read(prescriptionProvider.notifier).addPrescription(newRx);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Digital e-Rx issued to ${newRx.patientName}\'s Prescription Vault!',
        ),
        backgroundColor: _docAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _docAccent),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Write Digital e-Prescription',
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                children: [
                  Text(
                    'Patient Name',
                    style: AppTextStyles.h3.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _patientController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline, color: _docAccent),
                      hintText: 'Patient Full Name',
                      filled: true,
                      fillColor: AppColors.scaffoldBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.borderSubtle),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Diagnosis / Prescription Title',
                    style: AppTextStyles.h3.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.medical_information_outlined, color: _docAccent),
                      hintText: 'e.g. Respiratory Care, Diabetes Titration',
                      filled: true,
                      fillColor: AppColors.scaffoldBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.borderSubtle),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      'Respiratory & Fever Regimen',
                      'Diabetes Insulin Titration',
                      'IV Fluid & Antibiotic Care',
                      'Gastric Reflux Relief',
                    ].map((preset) {
                      return ActionChip(
                        label: Text(preset, style: const TextStyle(fontSize: 11)),
                        backgroundColor: const Color(0xFFCCFBF1).withValues(alpha: 0.5),
                        onPressed: () {
                          setState(() => _titleController.text = preset);
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 18),

                  // Automated Clinical Drug Safety Banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _selectedProductIds.contains('prod_ceftriaxone_inj') ||
                              _selectedProductIds.contains('prod_insulin_pen')
                          ? const Color(0xFFFEF3C7)
                          : const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _selectedProductIds.contains('prod_ceftriaxone_inj') ||
                                _selectedProductIds.contains('prod_insulin_pen')
                            ? const Color(0xFFFDE68A)
                            : const Color(0xFF86EFAC),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _selectedProductIds.contains('prod_ceftriaxone_inj') ||
                                  _selectedProductIds.contains('prod_insulin_pen')
                              ? Icons.info_outline_rounded
                              : Icons.verified_user_rounded,
                          color: _selectedProductIds.contains('prod_ceftriaxone_inj') ||
                                  _selectedProductIds.contains('prod_insulin_pen')
                              ? const Color(0xFFD97706)
                              : const Color(0xFF16A34A),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _selectedProductIds.contains('prod_ceftriaxone_inj') ||
                                    _selectedProductIds.contains('prod_insulin_pen')
                                ? 'Clinical Advisory: Regimen includes parenteral/injectable therapy. Verify cold-chain & nursing administration.'
                                : 'Clinical Drug-Interaction Check Passed: No contraindications across ${_selectedProductIds.length} selected items.',
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Structured Dosage Builder
                  Text(
                    'Dosage Frequency & Course Duration',
                    style: AppTextStyles.h3.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      '1+0+1 (Twice Daily)',
                      '1+1+1 (Thrice Daily)',
                      '0+0+1 (Night Only)',
                      '1+0+0 (Morning Only)',
                    ].map((freq) {
                      final isSel = _selectedFrequency == freq;
                      return ChoiceChip(
                        label: Text(freq, style: const TextStyle(fontSize: 11)),
                        selected: isSel,
                        selectedColor: _docAccent,
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (_) {
                          setState(() {
                            _selectedFrequency = freq;
                            _syncNotesFromRegimen();
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: ['5 Days', '7 Days', '14 Days', '30 Days'].map((dur) {
                      final isSel = _selectedDuration == dur;
                      return ChoiceChip(
                        label: Text(dur, style: const TextStyle(fontSize: 11)),
                        selected: isSel,
                        selectedColor: _docAccent,
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (_) {
                          setState(() {
                            _selectedDuration = dur;
                            _syncNotesFromRegimen();
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 18),
                  Text(
                    'Select Prescribed Medicines (${_selectedProductIds.length} selected)',
                    style: AppTextStyles.h3.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  ...MockData.products.map((product) {
                    final isSelected = _selectedProductIds.contains(product.id);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedProductIds.remove(product.id);
                          } else {
                            _selectedProductIds.add(product.id);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFCCFBF1).withValues(alpha: 0.45)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? _docAccent : AppColors.borderSubtle,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            ProductImage(
                              imagePath: product.imageUrl,
                              width: 42,
                              height: 42,
                              borderRadius: BorderRadius.circular(10),
                              fallbackSize: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${product.name} (${product.selectedStrength})',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '${product.genericName} • ${product.category}',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              isSelected
                                  ? Icons.check_circle_rounded
                                  : Icons.add_circle_outline_rounded,
                              color: isSelected ? _docAccent : AppColors.textMuted,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 14),
                  Text(
                    'Clinical Dosage & Advice Notes',
                    style: AppTextStyles.h3.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Dosage frequency, meal timing, and precautions...',
                      filled: true,
                      fillColor: AppColors.scaffoldBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.borderSubtle),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Sticky Sign & Issue CTA
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _handleIssueRx,
                  icon: const Icon(Icons.verified_user_rounded, color: Colors.white),
                  label: const Text(
                    'SIGN & ISSUE DIGITAL E-RX',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _docAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
