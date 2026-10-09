import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/data/mock/mock_data.dart';
import 'package:one_pharma/data/models/pharmacy_model.dart';
import 'package:one_pharma/presentation/widgets/primary_button.dart';

class NearbyPharmaciesScreen extends StatefulWidget {
  const NearbyPharmaciesScreen({super.key});

  @override
  State<NearbyPharmaciesScreen> createState() => _NearbyPharmaciesScreenState();
}

class _NearbyPharmaciesScreenState extends State<NearbyPharmaciesScreen> {
  PharmacyModel _selectedPharmacy = MockData.nearbyPharmacies.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Near By Pharmacies',
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Map Canvas Simulation matching Mockup 4
            Positioned.fill(
              child: CustomPaint(
                painter: _MapCanvasPainter(),
              ),
            ),

            // Map Pins corresponding to nearby stores
            ...MockData.nearbyPharmacies.asMap().entries.map((entry) {
              final index = entry.key;
              final pharm = entry.value;
              final isSelected = _selectedPharmacy.id == pharm.id;

              // Static offset positioning on canvas
              final positions = [
                const Offset(120, 180),
                const Offset(270, 140),
                const Offset(220, 260),
                const Offset(90, 310),
              ];
              final pos = positions[index % positions.length];

              return Positioned(
                left: pos.dx,
                top: pos.dy,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedPharmacy = pharm);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.white : AppColors.primary,
                              width: 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.local_pharmacy,
                            size: isSelected ? 22 : 16,
                            color: isSelected ? Colors.white : AppColors.primary,
                          ),
                        ),
                        Container(
                          width: 4,
                          height: 6,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            // Floating Top Search
            Positioned(
              top: 12,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.textMuted, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Uttara Sector 10, Dhaka',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const Icon(Icons.my_location_rounded, color: AppColors.primary, size: 20),
                  ],
                ),
              ),
            ),

            // Bottom Horizontal Card Row & Selected Store Detail
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Text(
                      'Your Near By',
                      style: AppTextStyles.h3.copyWith(
                        fontSize: 15,
                        backgroundColor: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),

                  // Horizontal Store Badges
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: MockData.nearbyPharmacies.length,
                      itemBuilder: (context, index) {
                        final pharm = MockData.nearbyPharmacies[index];
                        final isSelected = _selectedPharmacy.id == pharm.id;

                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedPharmacy = pharm);
                          },
                          child: Container(
                            width: 150,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.border,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.local_pharmacy_rounded,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pharm.name,
                                        style: AppTextStyles.h3.copyWith(fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star_rounded,
                                            size: 13,
                                            color: AppColors.primary,
                                          ),
                                          Text(
                                            ' ${pharm.rating}',
                                            style: AppTextStyles.caption.copyWith(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Selected Pharmacy Floating Action Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedPharmacy.name,
                              style: AppTextStyles.h3.copyWith(fontSize: 16),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _selectedPharmacy.isOpen
                                    ? AppColors.successLight
                                    : AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _selectedPharmacy.isOpen ? 'OPEN NOW' : 'CLOSED',
                                style: AppTextStyles.caption.copyWith(
                                  color: _selectedPharmacy.isOpen
                                      ? AppColors.success
                                      : AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedPharmacy.address,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                text: 'Call Store',
                                height: 42,
                                backgroundColor: AppColors.scaffoldBackground,
                                textColor: AppColors.textPrimary,
                                icon: const Icon(Icons.phone, size: 16, color: AppColors.textPrimary),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Calling ${_selectedPharmacy.phone}')),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: PrimaryButton(
                                text: 'Browse Store',
                                height: 42,
                                icon: const Icon(Icons.storefront_outlined, size: 16, color: Colors.white),
                                onPressed: () => context.push('/category/All'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapCanvasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Soft map background tint
    final bgPaint = Paint()..color = const Color(0xFFF0F4F8);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // River / waterway diagonal band
    final waterPaint = Paint()
      ..color = const Color(0xFFD6E4F0)
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke;
    final pathWater = Path()
      ..moveTo(0, size.height * 0.4)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.35,
        size.width,
        size.height * 0.55,
      );
    canvas.drawPath(pathWater, waterPaint);

    // Street Grid
    final streetPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final thinStreetPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    // Major Avenues
    canvas.drawLine(
        Offset(0, size.height * 0.2), Offset(size.width, size.height * 0.2), streetPaint);
    canvas.drawLine(
        Offset(0, size.height * 0.48), Offset(size.width, size.height * 0.48), streetPaint);
    canvas.drawLine(
        Offset(size.width * 0.35, 0), Offset(size.width * 0.35, size.height), streetPaint);
    canvas.drawLine(
        Offset(size.width * 0.75, 0), Offset(size.width * 0.75, size.height), streetPaint);

    // Diagonal streets matching Mockup 4
    canvas.drawLine(const Offset(-20, 100), Offset(size.width + 40, 380), thinStreetPaint);
    canvas.drawLine(const Offset(40, -20), Offset(size.width + 20, 500), thinStreetPaint);
    canvas.drawLine(const Offset(100, -20), Offset(-20, 360), thinStreetPaint);

    // Parks / Green blocks
    final parkPaint = Paint()..color = const Color(0xFFE4F2E7);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.05, size.height * 0.05, 90, 80),
        const Radius.circular(8),
      ),
      parkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.42, size.height * 0.26, 110, 70),
        const Radius.circular(8),
      ),
      parkPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
