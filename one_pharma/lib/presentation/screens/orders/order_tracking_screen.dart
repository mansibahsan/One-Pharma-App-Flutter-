import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/data/models/order_model.dart';
import 'package:one_pharma/providers/order_provider.dart';
import 'package:one_pharma/presentation/widgets/medicine_bottle_art.dart';

class OrderTrackingScreen extends ConsumerWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(selectedOrderProvider);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Status')),
        body: const Center(child: Text('Order not found')),
      );
    }

    final currentStep = order.status.stepIndex;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Order Status',
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.headset_mic_outlined, color: AppColors.textPrimary),
            onPressed: () => context.push('/support-chat'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Number Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order: ${order.orderNumber}',
                      style: AppTextStyles.h3.copyWith(fontSize: 14),
                    ),
                    Text(
                      'Total: \$${order.total.toStringAsFixed(2)}',
                      style: AppTextStyles.priceLarge.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Horizontal 6-stage tracker matching Mockup 4
              _buildHorizontalTracker(currentStep),
              const SizedBox(height: 32),

              // Order Timeline Title
              Text(
                'Order Timeline',
                style: AppTextStyles.h3.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Vertical chronological steps
              ...order.trackingTimeline.map((step) {
                return _buildTimelineItem(step);
              }),
              const SizedBox(height: 24),

              // Ordered Product Preview at bottom matching Mockup 4
              Text(
                'Product',
                style: AppTextStyles.h3.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 10),
              ...order.items.map((item) {
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
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: item.product.imageUrl != null && item.product.imageUrl!.isNotEmpty
                              ? Image.network(
                                  item.product.imageUrl!,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Center(
                                    child: MedicineBottleArt(
                                      size: 34,
                                      primaryColor: AppColors.primary,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: MedicineBottleArt(
                                    size: 34,
                                    primaryColor: AppColors.primary,
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalTracker(int activeStep) {
    final stages = ['Pending', 'Confirming', 'Processed', 'Picked', 'Shipped', 'Delivered'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(stages.length, (index) {
        final isPassed = index <= activeStep;
        final isCurrent = index == activeStep;

        return Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isPassed ? AppColors.primary : const Color(0xFFE2E7EE),
                shape: BoxShape.circle,
                border: isCurrent
                    ? Border.all(color: AppColors.primaryLight, width: 3)
                    : null,
              ),
              child: Center(
                child: Icon(
                  isPassed ? Icons.check : Icons.circle,
                  size: isPassed ? 15 : 6,
                  color: isPassed ? Colors.white : AppColors.textMuted,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              stages[index],
              style: AppTextStyles.caption.copyWith(
                fontSize: 9.5,
                fontWeight: isPassed ? FontWeight.w700 : FontWeight.w400,
                color: isPassed ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTimelineItem(TrackingStep step) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left timestamp column
          SizedBox(
            width: 72,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.date,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    fontSize: 11,
                  ),
                ),
                Text(
                  step.time,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          // Central dotted line
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: AppColors.border,
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Right details column
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: AppTextStyles.h3.copyWith(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step.description,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
