import 'package:flutter/material.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? icon;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double? fontSize;
  final BorderRadiusGeometry? borderRadius;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.width,
    this.height = 54,
    this.padding,
    this.textStyle,
    this.fontSize,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? AppColors.primary;
    final effectiveText = textColor ?? (isOutlined ? AppColors.primary : Colors.white);

    return SizedBox(
      width: width,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: effectiveText,
                side: BorderSide(color: effectiveBg, width: 1.5),
                shape: borderRadius != null
                    ? RoundedRectangleBorder(borderRadius: borderRadius!)
                    : const StadiumBorder(),
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: _buildChild(effectiveText),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: effectiveBg,
                foregroundColor: effectiveText,
                elevation: 0,
                shadowColor: effectiveBg.withValues(alpha: 0.35),
                shape: borderRadius != null
                    ? RoundedRectangleBorder(borderRadius: borderRadius!)
                    : const StadiumBorder(),
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: _buildChild(effectiveText),
            ),
    );
  }

  Widget _buildChild(Color color) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    final effectiveStyle = (textStyle ?? AppTextStyles.buttonLarge).copyWith(
      color: color,
      fontSize: fontSize ??
          (textStyle != null
              ? null
              : (height <= 44
                  ? 13
                  : (width != null && width! < 150 ? 13.5 : null))),
    );

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 6),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                style: effectiveStyle,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: effectiveStyle,
          maxLines: 1,
          softWrap: false,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}