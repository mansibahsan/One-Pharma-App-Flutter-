import 'package:flutter/material.dart';
import 'package:one_pharma/core/theme/app_colors.dart';

class MedicineBottleArt extends StatelessWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  final bool hasCapsule;
  final int variant;

  const MedicineBottleArt({
    super.key,
    this.size = 64,
    this.primaryColor = AppColors.primary,
    this.secondaryColor = const Color(0xFFFFB800),
    this.hasCapsule = true,
    this.variant = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft circle
          Container(
            width: size * 0.9,
            height: size * 0.9,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
          ),
          // Medicine Bottle
          Positioned(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cap
                Container(
                  width: size * 0.28,
                  height: size * 0.08,
                  decoration: BoxDecoration(
                    color: const Color(0xFF475467),
                    borderRadius: BorderRadius.circular(size * 0.04),
                  ),
                ),
                // Neck
                Container(
                  width: size * 0.20,
                  height: size * 0.04,
                  color: const Color(0xFF98A2B3),
                ),
                // Bottle Body
                Container(
                  width: size * 0.44,
                  height: size * 0.50,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(size * 0.10),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: size * 0.06,
                        vertical: size * 0.03,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(size * 0.04),
                      ),
                      child: Icon(
                        Icons.add,
                        size: size * 0.16,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Capsule beside bottle
          if (hasCapsule)
            Positioned(
              bottom: size * 0.08,
              right: size * 0.08,
              child: Transform.rotate(
                angle: -0.4,
                child: Container(
                  width: size * 0.30,
                  height: size * 0.14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size * 0.07),
                    border: Border.all(color: Colors.white, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(size * 0.07),
                              bottomLeft: Radius.circular(size * 0.07),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E90FA),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(size * 0.07),
                              bottomRight: Radius.circular(size * 0.07),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
