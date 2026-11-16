import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/data/models/address_model.dart';
import 'package:one_pharma/providers/address_provider.dart';

class AddAddressScreen extends ConsumerStatefulWidget {
  const AddAddressScreen({super.key});

  @override
  ConsumerState<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<AddAddressScreen> {
  final _nameController = TextEditingController(text: 'Hera Rahman');
  final _phoneController = TextEditingController(text: '0171-8963563');
  final _streetController = TextEditingController();
  final _areaController = TextEditingController();
  final _cityController = TextEditingController(text: 'Dhaka 1230');
  String _label = 'Home';
  bool _isDefault = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _areaController.dispose();
    _cityController.dispose();
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
          'Add Delivery Address',
          style: AppTextStyles.h2.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          Text('Address Label', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: ['Home', 'Office', 'Parents'].map((lbl) {
              final isSel = _label == lbl;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ChoiceChip(
                  label: Text(lbl),
                  selected: isSel,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSel ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: AppColors.scaffoldBackground,
                  onSelected: (val) {
                    if (val) setState(() => _label = lbl);
                  },
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
          _buildTextField('Recipient Full Name', _nameController, 'e.g. Hera Rahman'),
          const SizedBox(height: 16),
          _buildTextField('Contact Phone', _phoneController, 'e.g. 0171-8963563'),
          const SizedBox(height: 16),
          _buildTextField('Street / House / Building', _streetController, 'e.g. House 42, Road 11'),
          const SizedBox(height: 16),
          _buildTextField('Area / Sector', _areaController, 'e.g. Sector 10, Uttara'),
          const SizedBox(height: 16),
          _buildTextField('City & Postal Code', _cityController, 'e.g. Dhaka 1230'),

          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Set as default address',
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
            value: _isDefault,
            activeTrackColor: AppColors.primary,
            onChanged: (val) => setState(() => _isDefault = val),
          ),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                if (_streetController.text.trim().isEmpty || _areaController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in street address and area.')),
                  );
                  return;
                }
                final newAddr = AddressModel(
                  id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
                  label: _label,
                  recipientName: _nameController.text.trim(),
                  phone: _phoneController.text.trim(),
                  streetAddress: _streetController.text.trim(),
                  area: _areaController.text.trim(),
                  city: _cityController.text.trim(),
                  isDefault: _isDefault,
                );
                ref.read(addressProvider.notifier).addAddress(newAddr);
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Address added successfully!'),
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
                'Save Address',
                style: AppTextStyles.buttonLarge.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.scaffoldBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderSubtle),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
