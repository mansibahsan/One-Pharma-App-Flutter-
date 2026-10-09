import 'package:flutter/material.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/presentation/widgets/primary_button.dart';
import 'package:one_pharma/presentation/widgets/app_text_field.dart';

class PaymentBottomSheet extends StatefulWidget {
  final double totalAmount;
  final ValueChanged<String> onConfirmPayment;

  const PaymentBottomSheet({
    super.key,
    required this.totalAmount,
    required this.onConfirmPayment,
  });

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  String _selectedMethod = 'Mastercard';
  final _cardNumberController = TextEditingController(text: '1234 5678 9012 4563');
  final _expiryController = TextEditingController(text: '08/28');
  final _cvvController = TextEditingController(text: '123');
  bool _isLoading = false;

  final List<PaymentOption> _methods = const [
    PaymentOption(
      id: 'Mastercard',
      title: 'Mastercard',
      subtitle: 'Pay from mastercard account using gateway',
      icon: Icons.credit_card_rounded,
      iconColor: Color(0xFFEB001B),
    ),
    PaymentOption(
      id: 'Visa Card',
      title: 'Visa Card',
      subtitle: 'Pay from visa account using payment gateway',
      icon: Icons.credit_card,
      iconColor: Color(0xFF1A1F71),
    ),
    PaymentOption(
      id: 'bKash / Nagad',
      title: 'bKash / Nagad MFS',
      subtitle: 'Instant mobile financial payment Bangladesh',
      icon: Icons.account_balance_wallet_rounded,
      iconColor: Color(0xFFE2136E),
    ),
    PaymentOption(
      id: 'Paypal',
      title: 'Paypal',
      subtitle: 'Pay from paypal account using secure checkout',
      icon: Icons.payment_rounded,
      iconColor: Color(0xFF003087),
    ),
    PaymentOption(
      id: 'Cash on Delivery',
      title: 'Cash on Delivery',
      subtitle: 'Pay with cash upon package receipt',
      icon: Icons.local_shipping_outlined,
      iconColor: Color(0xFF00B074),
    ),
  ];

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _confirm() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() => _isLoading = false);

    widget.onConfirmPayment(_selectedMethod);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Payment method',
                  style: AppTextStyles.h3.copyWith(fontSize: 17),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textPrimary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Scrollable Method Options
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                ..._methods.map((method) {
                  final isSelected = _selectedMethod == method.id;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryLight.withValues(alpha: 0.3)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: RadioListTile<String>(
                      value: method.id,
                      groupValue: _selectedMethod,
                      activeColor: AppColors.primary,
                      title: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  method.title,
                                  style: AppTextStyles.h3.copyWith(fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  method.subtitle,
                                  style: AppTextStyles.caption.copyWith(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(method.icon, color: method.iconColor, size: 26),
                        ],
                      ),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedMethod = val);
                        }
                      },
                    ),
                  );
                }),

                // Card details form if credit card is selected
                if (_selectedMethod == 'Mastercard' || _selectedMethod == 'Visa Card') ...[
                  const SizedBox(height: 16),
                  Text(
                    'Card Details',
                    style: AppTextStyles.h3.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _cardNumberController,
                    hintText: 'Card Number',
                    suffixIcon: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.credit_card, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _expiryController,
                          hintText: 'Expiry Date (MM/YY)',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTextField(
                          controller: _cvvController,
                          hintText: 'CVV / CVC',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Confirm Payment Button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: PrimaryButton(
              text: 'CONFIRM PAYMENT (\$${widget.totalAmount.toStringAsFixed(2)})',
              isLoading: _isLoading,
              onPressed: _confirm,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const PaymentOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });
}
