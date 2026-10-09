import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/data/mock/mock_data.dart';
import 'package:one_pharma/data/models/product_model.dart';
import 'package:one_pharma/data/models/reminder_model.dart';
import 'package:one_pharma/providers/reminder_provider.dart';

class AddReminderScreen extends ConsumerStatefulWidget {
  const AddReminderScreen({super.key});

  @override
  ConsumerState<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends ConsumerState<AddReminderScreen> {
  late ProductModel _selectedProduct;
  final TextEditingController _dosageController = TextEditingController(text: '1 Tablet');
  ReminderTimeSlot _selectedSlot = ReminderTimeSlot.morning;
  String _selectedInstruction = 'After meal';
  final int _totalDoses = 30;

  @override
  void initState() {
    super.initState();
    _selectedProduct = MockData.products.first;
  }

  @override
  void dispose() {
    _dosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Add Pill Reminder',
          style: AppTextStyles.h2.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Select Medicine
          Text('Select Medication', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ProductModel>(
                value: _selectedProduct,
                isExpanded: true,
                items: MockData.products.map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Text('${p.name} (${p.selectedStrength})', style: AppTextStyles.bodyMedium),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedProduct = val);
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Dosage
          Text('Dosage Quantity', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _dosageController,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.scaffoldBackground,
              hintText: 'e.g. 1 Tablet, 2 Capsules, 10ml',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.borderSubtle),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.borderSubtle),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Timing Slot
          Text('Time Slot', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ReminderTimeSlot.values.map((slot) {
              final isSel = _selectedSlot == slot;
              return ChoiceChip(
                label: Text('${slot.label} (${slot.defaultTime})'),
                selected: isSel,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSel ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                backgroundColor: AppColors.scaffoldBackground,
                onSelected: (val) {
                  if (val) setState(() => _selectedSlot = slot);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Instructions
          Text('Food Instruction', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['After meal', 'Before meal', 'With water', 'At bedtime'].map((inst) {
              final isSel = _selectedInstruction == inst;
              return ChoiceChip(
                label: Text(inst),
                selected: isSel,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSel ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                backgroundColor: AppColors.scaffoldBackground,
                onSelected: (val) {
                  if (val) setState(() => _selectedInstruction = inst);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 36),

          // Submit
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                final rem = ReminderModel(
                  id: 'rem_${DateTime.now().millisecondsSinceEpoch}',
                  product: _selectedProduct,
                  dosage: _dosageController.text.trim().isNotEmpty
                      ? _dosageController.text.trim()
                      : '1 Tablet',
                  instruction: _selectedInstruction,
                  slot: _selectedSlot,
                  time: _selectedSlot.defaultTime,
                  isTakenToday: false,
                  remainingDoses: _totalDoses,
                  totalDoses: _totalDoses,
                );
                ref.read(reminderProvider.notifier).addReminder(rem);
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pill reminder scheduled successfully!'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: Text(
                'Save Medication Reminder',
                style: AppTextStyles.buttonLarge.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
