import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/data/models/prescription_model.dart';
import 'package:one_pharma/providers/consultation_provider.dart';
import 'package:one_pharma/providers/prescription_provider.dart';
import 'doctor_dashboard_screen.dart';
import 'doctor_appointments_screen.dart';
import 'doctor_prescriptions_screen.dart';
import 'doctor_profile_screen.dart';

final doctorShellTabProvider = StateProvider<int>((ref) => 0);

class DoctorShellScreen extends ConsumerStatefulWidget {
  final int initialTab;

  const DoctorShellScreen({super.key, this.initialTab = 0});

  @override
  ConsumerState<DoctorShellScreen> createState() => _DoctorShellScreenState();
}

class _DoctorShellScreenState extends ConsumerState<DoctorShellScreen> {
  static const Color _docAccent = Color(0xFF0D9488);

  final List<Widget> _screens = const [
    DoctorDashboardScreen(),
    DoctorAppointmentsScreen(),
    DoctorPrescriptionsScreen(),
    DoctorProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(doctorShellTabProvider.notifier).state =
            widget.initialTab.clamp(0, _screens.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(doctorShellTabProvider);
    final upcomingCount = ref
        .watch(appointmentsProvider)
        .where((a) => a.status == AppointmentStatus.upcoming)
        .length;
    final pendingRxCount = ref
        .watch(prescriptionProvider)
        .where((r) => r.status == PrescriptionStatus.pending)
        .length;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppColors.borderSubtle)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 68,
            child: Row(
              children: [
                Expanded(
                  child: _buildNavItem(
                    index: 0,
                    currentIndex: currentIndex,
                    activeIcon: Icons.space_dashboard_rounded,
                    inactiveIcon: Icons.space_dashboard_outlined,
                    label: 'Dashboard',
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    index: 1,
                    currentIndex: currentIndex,
                    activeIcon: Icons.videocam_rounded,
                    inactiveIcon: Icons.videocam_outlined,
                    label: 'Consults',
                    badgeCount: upcomingCount,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    index: 2,
                    currentIndex: currentIndex,
                    activeIcon: Icons.assignment_turned_in_rounded,
                    inactiveIcon: Icons.assignment_outlined,
                    label: 'Rx Queue',
                    badgeCount: pendingRxCount,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    index: 3,
                    currentIndex: currentIndex,
                    activeIcon: Icons.person_rounded,
                    inactiveIcon: Icons.person_outline_rounded,
                    label: 'Profile',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required int currentIndex,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
    int badgeCount = 0,
  }) {
    final isSelected = currentIndex == index;

    return InkWell(
      onTap: () => ref.read(doctorShellTabProvider.notifier).state = index,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : inactiveIcon,
                  size: 22,
                  color: isSelected ? _docAccent : AppColors.textMuted,
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.2),
                      ),
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                height: 1.15,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? _docAccent : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 16 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: isSelected ? _docAccent : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

