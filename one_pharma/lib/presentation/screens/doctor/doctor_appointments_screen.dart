import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/providers/consultation_provider.dart';
import 'patient_case_sheet.dart';

class DoctorAppointmentsScreen extends ConsumerStatefulWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  ConsumerState<DoctorAppointmentsScreen> createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends ConsumerState<DoctorAppointmentsScreen> {
  AppointmentStatus _selectedFilter = AppointmentStatus.upcoming;
  static const Color _docAccent = Color(0xFF0D9488);

  @override
  Widget build(BuildContext context) {
    final allAppointments = ref.watch(appointmentsProvider);
    final filtered =
        allAppointments.where((a) => a.status == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Patient Consultations',
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_document, color: _docAccent),
            tooltip: 'Write e-Prescription',
            onPressed: () => context.push('/doctor/write-rx'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Segmented Filter
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: AppointmentStatus.values.map((status) {
                  final isSelected = _selectedFilter == status;
                  final count =
                      allAppointments.where((a) => a.status == status).length;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: status == AppointmentStatus.upcoming ? 8 : 0,
                      ),
                      child: ChoiceChip(
                        label: Text('${status.label} ($count)'),
                        selected: isSelected,
                        selectedColor: _docAccent,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                        backgroundColor: AppColors.scaffoldBackground,
                        onSelected: (_) => setState(() => _selectedFilter = status),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No ${_selectedFilter.label.toLowerCase()} consultations',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final appt = filtered[index];
                        return _buildAppointmentCard(context, appt);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, BookedAppointment appt) {
    final isUpcoming = appt.status == AppointmentStatus.upcoming;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => PatientCaseSheet(appointment: appt),
        );
      },
      child: Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSubtle),
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
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFCCFBF1),
                child: Text(
                  appt.patientName[0].toUpperCase(),
                  style: const TextStyle(
                    color: _docAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appt.patientName,
                      style: AppTextStyles.h3.copyWith(fontSize: 15),
                    ),
                    Text(
                      appt.patientAgeGender,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isUpcoming
                      ? const Color(0xFFDBEAFE)
                      : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  appt.mode,
                  style: TextStyle(
                    color: isUpcoming
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF16A34A),
                    fontWeight: FontWeight.bold,
                    fontSize: 10.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.schedule_rounded, size: 15, color: _docAccent),
                    const SizedBox(width: 6),
                    Text(
                      '${appt.date} • ${appt.time}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Tap for EMR Case Sheet →',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: _docAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Chief Complaint: ${appt.chiefComplaint}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push(
                    '/doctor/write-rx?patient=${Uri.encodeComponent(appt.patientName)}',
                  ),
                  icon: const Icon(Icons.edit_document, size: 15),
                  label: const Text('Write e-Rx'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _docAccent,
                    side: const BorderSide(color: _docAccent),
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
              if (isUpcoming) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/teleconsult-call'),
                    icon: const Icon(Icons.videocam_rounded, size: 16),
                    label: const Text('Start Call'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _docAccent,
                      foregroundColor: Colors.white,
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
                const SizedBox(width: 6),
                IconButton(
                  tooltip: 'Mark Completed',
                  icon: const Icon(Icons.check_circle_outline_rounded, color: _docAccent),
                  onPressed: () {
                    ref.read(appointmentsProvider.notifier).markCompleted(appt.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Marked ${appt.patientName} session as completed'),
                        backgroundColor: _docAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ],
      ),
      ),
    );
  }
}

