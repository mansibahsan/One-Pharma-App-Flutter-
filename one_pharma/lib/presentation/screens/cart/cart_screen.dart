import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/providers/cart_provider.dart';
import 'package:one_pharma/presentation/widgets/primary_button.dart';
import 'package:one_pharma/presentation/widgets/quantity_stepper.dart';
import 'package:one_pharma/presentation/widgets/medicine_bottle_art.dart';
import 'empty_cart_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    if (cartState.items.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Medicine Bag', style: AppTextStyles.h3),
        ),
        body: const EmptyCartView(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Medicine Bag',
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textSecondary),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Clear Cart?'),
                  content: const Text('Do you want to remove all items from your bag?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        cartNotifier.clearCart();
                        Navigator.of(ctx).pop();
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Prescription alert banner if needed
            if (cartState.requiresPrescription)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.assignment_late_outlined,
                      color: AppColors.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Contains Rx items: Prescription upload will be required at checkout.',
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFFB54708),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Cart Items List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: cartState.items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = cartState.items[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: item.isSelected
                            ? AppColors.primary.withValues(alpha: 0.3)
                            : AppColors.border,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Radio / Checkbox
                        GestureDetector(
                          onTap: () {
                            cartNotifier.toggleItemSelection(
                              item.product.id,
                              item.strength,
                            );
                          },
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: item.isSelected
                                  ? AppColors.primary
                                  : Colors.white,
                              border: Border.all(
                                color: item.isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: 1.5,
                              ),
                            ),
                            child: item.isSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Thumbnail
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.scaffoldBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: item.product.imageUrl != null && item.product.imageUrl!.isNotEmpty
                                ? Image.network(
                                    item.product.imageUrl!,
                                    width: 52,
                                    height: 52,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Center(
                                      child: MedicineBottleArt(
                                        size: 40,
                                        primaryColor: item.product.isPrescriptionRequired
                                            ? AppColors.primary
                                            : const Color(0xFF2E90FA),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: MedicineBottleArt(
                                      size: 40,
                                      primaryColor: item.product.isPrescriptionRequired
                                          ? AppColors.primary
                                          : const Color(0xFF2E90FA),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Title, details, total
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.product.name} ${item.strength}',
                                style: AppTextStyles.h3.copyWith(fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'USD ${item.product.price.toStringAsFixed(2)} x ${item.quantity}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'USD \$${item.itemTotal.toStringAsFixed(2)}',
                                style: AppTextStyles.priceLarge.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Quantity Stepper
                        QuantityStepper(
                          quantity: item.quantity,
                          onChanged: (newQty) {
                            cartNotifier.updateQuantity(
                              item.product.id,
                              item.strength,
                              newQty,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Sticky Checkout Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Select All
                  GestureDetector(
                    onTap: () => cartNotifier.toggleSelectAll(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: cartState.isAllSelected
                                ? AppColors.primary
                                : Colors.white,
                            border: Border.all(
                              color: cartState.isAllSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: 1.5,
                            ),
                          ),
                          child: cartState.isAllSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 13,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'All',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // Total Text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total :',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        'USD \$${cartState.grandTotal.toStringAsFixed(2)}',
                        style: AppTextStyles.priceLarge.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),

                  // Checkout Button
                  PrimaryButton(
                    text: 'CHECK OUT',
                    width: 125,
                    height: 46,
                    fontSize: 13.5,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    onPressed: cartState.selectedItems.isEmpty
                        ? null
                        : () => context.push('/checkout'),
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
