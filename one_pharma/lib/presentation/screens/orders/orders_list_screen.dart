import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/data/models/order_model.dart';
import 'package:one_pharma/providers/order_provider.dart';
import 'package:one_pharma/presentation/widgets/product_image.dart';

class OrdersListScreen extends ConsumerWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: orders.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.receipt_long_outlined,
                      size: 64,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 16),
                    Text('No orders yet', style: AppTextStyles.h3),
                    const SizedBox(height: 6),
                    Text(
                      'Your completed and ongoing purchases will appear here',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                itemCount: orders.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final firstItem = order.items.isNotEmpty ? order.items.first : null;

                  return GestureDetector(
                    onTap: () {
                      ref.read(selectedOrderIdProvider.notifier).state = order.id;
                      context.push('/order-tracking');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderSubtle),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Item preview image
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.scaffoldBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ProductImage(
                              imagePath: firstItem?.product.imageUrl,
                              width: 52,
                              height: 52,
                              borderRadius: BorderRadius.circular(12),
                              fallbackColor: _getStatusColor(order.status),
                              fallbackSize: 38,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Order Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  firstItem != null
                                      ? '${firstItem.product.name} ${firstItem.strength}'
                                      : order.orderNumber,
                                  style: AppTextStyles.h3.copyWith(fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  firstItem != null
                                      ? 'USD \$${firstItem.product.price.toStringAsFixed(2)} x ${firstItem.quantity}'
                                      : 'Order ID: ${order.orderNumber}',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Total: USD \$${order.total.toStringAsFixed(2)}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Status Pill Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusBg(order.status),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _getStatusColor(order.status).withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              order.status.label,
                              style: AppTextStyles.caption.copyWith(
                                color: _getStatusColor(order.status),
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFF79009);
      case OrderStatus.confirming:
        return const Color(0xFFF79009);
      case OrderStatus.processed:
        return const Color(0xFF2E90FA);
      case OrderStatus.picked:
        return const Color(0xFF7A5AF8);
      case OrderStatus.shipped:
        return AppColors.primary;
      case OrderStatus.delivered:
        return const Color(0xFF12B76A);
    }
  }

  Color _getStatusBg(OrderStatus status) {
    return _getStatusColor(status).withValues(alpha: 0.1);
  }
}
