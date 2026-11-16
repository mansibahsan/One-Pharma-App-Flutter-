import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:one_pharma/core/theme/app_colors.dart';

/// Vector logo mark matching assets/icons/app_icon.svg.
class AppIconMark extends StatelessWidget {
  final double size;
  final Color primaryColor;
  final Color accentColor;
  final bool inverted;

  const AppIconMark({
    super.key,
    this.size = 72,
    this.primaryColor = AppColors.primary,
    this.accentColor = const Color(0xFFFFB800),
    this.inverted = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _AppIconMarkPainter(
        primaryColor: primaryColor,
        accentColor: accentColor,
        inverted: inverted,
      ),
    );
  }
}

class _AppIconMarkPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;
  final bool inverted;

  _AppIconMarkPainter({
    required this.primaryColor,
    required this.accentColor,
    required this.inverted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final center = Offset(s / 2, s / 2);

    // Cross bars
    final crossPaint = Paint()
      ..color = inverted ? Colors.white : primaryColor
      ..style = PaintingStyle.fill;

    final barThickness = s * 0.28;
    final barLength = s * 0.82;
    final radius = Radius.circular(s * 0.09);

    final verticalRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: barThickness, height: barLength),
      radius,
    );
    final horizontalRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: barLength, height: barThickness),
      radius,
    );

    canvas.drawRRect(verticalRect, crossPaint);
    canvas.drawRRect(horizontalRect, crossPaint);

    // Center medallion
    final medallionRadius = s * 0.165;
    final medallionPaint = Paint()
      ..color = inverted ? primaryColor : Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, medallionRadius, medallionPaint);

    // Capsule inside center medallion
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 4);

    final capW = s * 0.125;
    final capH = s * 0.22;
    final capR = Radius.circular(capW / 2);

    final fullCapsule = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: capW, height: capH),
      capR,
    );
    canvas.clipRRect(fullCapsule);

    final topHalfPaint = Paint()
      ..color = inverted ? Colors.white : primaryColor;
    canvas.drawRect(
      Rect.fromLTRB(-capW / 2, -capH / 2, capW / 2, 0),
      topHalfPaint,
    );

    final bottomHalfPaint = Paint()..color = accentColor;
    canvas.drawRect(
      Rect.fromLTRB(-capW / 2, 0, capW / 2, capH / 2),
      bottomHalfPaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AppIconMarkPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.inverted != inverted;
  }
}

