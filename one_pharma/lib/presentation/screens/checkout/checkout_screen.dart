import 'package:one_pharma/presentation/widgets/address_picker_sheet.dart';
import 'package:one_pharma/providers/address_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/providers/auth_provider.dart';
import 'package:one_pharma/providers/cart_provider.dart';
import 'package:one_pharma/providers/order_provider.dart';
import 'package:one_pharma/presentation/widgets/primary_button.dart';
import 'package:one_pharma/presentation/widgets/medicine_bottle_art.dart';
import 'payment_bottom_sheet.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _hasUploadedPrescription = false;
  String _uploadedFileName = '';

  void _simulateUploadPrescription() {
    setState(() {
      _hasUploadedPrescription = true;
      _uploadedFileName = 'Prescription_Rx_Doc_${DateTime.now().millisecondsSinceEpoch}.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prescription image attached successfully (1.4 MB)'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _handlePlaceOrder() {
    final cartState = ref.read(cartProvider);

    // Prescription validation check
    if (cartState.requiresPrescription && !_hasUploadedPrescription) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Prescription Required'),
          content: const Text(
            'Your bag contains prescription medicines. Please upload a valid doctor\'s prescription before proceeding to payment.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _simulateUploadPrescription();
              },
              child: const Text('Upload Now'),
            ),
          ],
        ),
      );
      return;
    }

    // Show Payment Bottom Sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PaymentBottomSheet(
        totalAmount: cartState.grandTotal,
        onConfirmPayment: (method) {
          Navigator.of(ctx).pop();
          _finalizeOrder(method);
        },
      ),
    );
  }

  void _finalizeOrder(String paymentMethod) {
    final user = ref.read(authProvider).user;
    final cartState = ref.read(cartProvider);
    final selectedAddress = ref.read(selectedAddressProvider);

    final orderId = ref.read(ordersProvider.notifier).placeOrder(
          items: cartState.selectedItems,
          subtotal: cartState.subtotal,
          deliveryFee: cartState.deliveryFee,
          discount: cartState.discount,
          total: cartState.grandTotal,
          address: selectedAddress?.fullAddress ?? user?.address ?? 'House #28, Road #30, Sector #10, Dhaka 1230',
          phone: selectedAddress?.phone ?? user?.phone ?? '0569 - 8963 - 5632',
          paymentMethod: paymentMethod,
          prescriptionUrl: _hasUploadedPrescription ? _uploadedFileName : null,
        );

    ref.read(selectedOrderIdProvider.notifier).state = orderId;
    ref.read(cartProvider.notifier).removeSelected();

    context.pushReplacement('/order-success');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final selectedAddress = ref.watch(selectedAddressProvider);
    final cartState = ref.watch(cartProvider);
    final items = cartState.selectedItems;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Checkout Information',
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Address Card (Interactive)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery Address', style: AppTextStyles.h3.copyWith(fontSize: 15)),
                        TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (ctx) => const AddressPickerSheet(),
                            );
                          },
                          child: Text(
                            'CHANGE',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) => const AddressPickerSheet(),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedAddress != null
                                        ? '${selectedAddress.recipientName} (${selectedAddress.label})'
                                        : (user?.name ?? 'Hera Rahman'),
                                    style: AppTextStyles.h3.copyWith(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    selectedAddress != null
                                        ? '${selectedAddress.fullAddress} • ${selectedAddress.phone}'
                                        : (user?.address ?? 'House#28, Road#30, Sector#10, Dhaka 1230'),
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Contact Number Card
                    Text('Contact Number', style: AppTextStyles.h3.copyWith(fontSize: 15)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.phone_outlined, color: AppColors.textPrimary, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              user?.phone ?? '0569 - 8963 - 5632',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(Icons.edit_outlined, size: 18, color: AppColors.textMuted),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Upload Prescription Card
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Upload Prescription', style: AppTextStyles.h3.copyWith(fontSize: 15)),
                        if (cartState.requiresPrescription)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.warningLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Required for Rx',
                              style: AppTextStyles.caption.copyWith(
                                color: const Color(0xFFB54708),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _simulateUploadPrescription,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _hasUploadedPrescription
                                ? AppColors.success
                                : AppColors.border,
                            width: _hasUploadedPrescription ? 1.5 : 1,
                          ),
                        ),
                        child: _hasUploadedPrescription
                            ? Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: AppColors.successLight,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.receipt_rounded,
                                      color: AppColors.success,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _uploadedFileName,
                                          style: AppTextStyles.h3.copyWith(fontSize: 13),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Attached ready for pharmacist audit',
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.success,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: AppColors.error, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        _hasUploadedPrescription = false;
                                        _uploadedFileName = '';
                                      });
                                    },
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Attach Prescription Image',
                                          style: AppTextStyles.h3.copyWith(fontSize: 13),
                                        ),
                                        Text(
                                          '590x600 or larger recommended, up to 2MB',
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.file_upload_outlined,
                                    color: AppColors.primary,
                                    size: 22,
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Product List Summary
                    Text('Product List', style: AppTextStyles.h3.copyWith(fontSize: 15)),
                    const SizedBox(height: 10),
                    ...items.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBackground,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: item.product.imageUrl != null && item.product.imageUrl!.isNotEmpty
                                    ? Image.network(
                                        item.product.imageUrl!,
                                        width: 44,
                                        height: 44,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => Center(
                                          child: MedicineBottleArt(
                                            size: 32,
                                            primaryColor: item.product.isPrescriptionRequired
                                                ? AppColors.primary
                                                : const Color(0xFF2E90FA),
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: MedicineBottleArt(
                                          size: 32,
                                          primaryColor: item.product.isPrescriptionRequired
                                              ? AppColors.primary
                                              : const Color(0xFF2E90FA),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${item.product.name} ${item.strength}',
                                    style: AppTextStyles.h3.copyWith(fontSize: 13),
                                  ),
                                  Text(
                                    'USD \$${item.product.price.toStringAsFixed(2)} x ${item.quantity}',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'USD \$${item.itemTotal.toStringAsFixed(2)}',
                              style: AppTextStyles.priceLarge.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 10),

                    // Cost Breakdown
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          _buildCostRow('Subtotal', 'USD \$${cartState.subtotal.toStringAsFixed(2)}'),
                          const SizedBox(height: 6),
                          _buildCostRow('Delivery Fee', 'USD \$${cartState.deliveryFee.toStringAsFixed(2)}'),
                          const SizedBox(height: 6),
                          _buildCostRow('Special Discount', '- USD \$${cartState.discount.toStringAsFixed(2)}', isDiscount: true),
                          const Divider(height: 16),
                          _buildCostRow(
                            'Grand Total',
                            'USD \$${cartState.grandTotal.toStringAsFixed(2)}',
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Items : ${items.fold(0, (s, i) => s + i.quantity)}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        'USD \$${cartState.grandTotal.toStringAsFixed(2)}',
                        style: AppTextStyles.priceLarge.copyWith(fontSize: 17),
                      ),
                    ],
                  ),
                  const Spacer(),
                  PrimaryButton(
                    text: 'PLACE ORDER',
                    width: 160,
                    height: 48,
                    onPressed: _handlePlaceOrder,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String title, String value, {bool isDiscount = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isTotal
              ? AppTextStyles.h3.copyWith(fontSize: 14)
              : AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.priceLarge.copyWith(fontSize: 16)
              : (isDiscount
                  ? AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                    )
                  : AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    )),
        ),
      ],
    );
  }
}
