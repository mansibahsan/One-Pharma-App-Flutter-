import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/providers/consultation_provider.dart';

class PharmacistProfileScreen extends ConsumerStatefulWidget {
  final String pharmacistId;

  const PharmacistProfileScreen({super.key, required this.pharmacistId});

  @override
  ConsumerState<PharmacistProfileScreen> createState() => _PharmacistProfileScreenState();
}

class _PharmacistProfileScreenState extends ConsumerState<PharmacistProfileScreen> {
  String _selectedDay = 'Today';
  late String _selectedSlot;
  int _consultationTypeIndex = 0; // 0: Video, 1: Audio, 2: Chat

  @override
  void initState() {
    super.initState();
    final list = ref.read(pharmacistListProvider);
    final doc = list.firstWhere((p) => p.id == widget.pharmacistId, orElse: () => list.first);
    _selectedSlot = doc.availableSlots.first;
  }

  @override
  Widget build(BuildContext context) {
    final list = ref.watch(pharmacistListProvider);
    final doc = list.firstWhere((p) => p.id == widget.pharmacistId, orElse: () => list.first);

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
          'Book Consultation',
          style: AppTextStyles.h2.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Profile Card
          Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundImage: NetworkImage(doc.avatarUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.name,
                      style: AppTextStyles.h3.copyWith(fontSize: 18),
                    ),
                    Text(
                      '${doc.qualification} • ${doc.designation}',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 18),
                        const SizedBox(width: 4),
                        Text('${doc.rating} (${doc.reviewCount} reviews)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 20),

          // Consultation Type
          Text('Select Consultation Mode', style: AppTextStyles.h3.copyWith(fontSize: 15)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildTypeOption(0, 'Video Call', r'$' + doc.consultationFee.toStringAsFixed(0), Icons.videocam_rounded),
              const SizedBox(width: 10),
              _buildTypeOption(1, 'Audio Call', r'$' + (doc.consultationFee - 3).toStringAsFixed(0), Icons.phone_in_talk_rounded),
              const SizedBox(width: 10),
              _buildTypeOption(2, 'Live Chat', r'$' + (doc.consultationFee - 5).toStringAsFixed(0), Icons.chat_rounded),
            ],
          ),

          const SizedBox(height: 24),

          // Date Selection
          Text('Select Date', style: AppTextStyles.h3.copyWith(fontSize: 15)),
          const SizedBox(height: 12),
          Row(
            children: ['Today', 'Tomorrow', 'Oct 10'].map((day) {
              final isSel = _selectedDay == day;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ChoiceChip(
                  label: Text(day),
                  selected: isSel,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSel ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: AppColors.scaffoldBackground,
                  onSelected: (val) {
                    if (val) setState(() => _selectedDay = day);
                  },
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Available Slots
          Text('Available Time Slots', style: AppTextStyles.h3.copyWith(fontSize: 15)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: doc.availableSlots.map((slot) {
              final isSel = _selectedSlot == slot;
              return ChoiceChip(
                avatar: Icon(Icons.schedule_rounded, size: 16, color: isSel ? Colors.white : AppColors.primary),
                label: Text(slot),
                selected: isSel,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSel ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                backgroundColor: AppColors.scaffoldBackground,
                onSelected: (val) {
                  if (val) setState(() => _selectedSlot = slot);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          // Bio
          Text('About Clinician', style: AppTextStyles.h3.copyWith(fontSize: 15)),
          const SizedBox(height: 8),
          Text(
            doc.about,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.4),
          ),

          const SizedBox(height: 36),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                final modes = ['Video Call', 'Audio Call', 'Live Chat'];
                ref.read(appointmentsProvider.notifier).book(
                      doc,
                      _selectedDay,
                      _selectedSlot,
                      mode: modes[_consultationTypeIndex],
                    );
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    title: const Row(
                      children: [
                        Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A)),
                        SizedBox(width: 8),
                        Expanded(child: Text('Session Booked!')),
                      ],
                    ),
                    content: Text(
                      'Your ${modes[_consultationTypeIndex]} appointment with ${doc.name} is confirmed for $_selectedDay at $_selectedSlot. It is now visible in the Doctor Portal queue.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          context.push('/teleconsult-call');
                        },
                        child: const Text('Preview Live Call'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          context.pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Done', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: Text(
                'Confirm & Reserve Slot',
                style: AppTextStyles.buttonLarge.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption(int index, String title, String price, IconData icon) {
    final isSel = _consultationTypeIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _consultationTypeIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: isSel ? AppColors.primaryLight : AppColors.scaffoldBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSel ? AppColors.primary : AppColors.borderSubtle,
              width: isSel ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSel ? AppColors.primary : AppColors.textMuted, size: 22),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSel ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                price,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSel ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
