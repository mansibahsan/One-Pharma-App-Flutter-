import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/models/order_model.dart';
import '../data/models/cart_item_model.dart';
import '../data/mock/mock_data.dart';

class OrderNotifier extends StateNotifier<List<OrderModel>> {
  OrderNotifier() : super(MockData.mockOrders);

  String placeOrder({
    required List<CartItemModel> items,
    required double subtotal,
    required double deliveryFee,
    required double discount,
    required double total,
    required String address,
    required String phone,
    required String paymentMethod,
    String? prescriptionUrl,
  }) {
    final now = DateTime.now();
    final newId = 'ord_${now.millisecondsSinceEpoch}';
    final orderNum = 'OP-${now.year}-${(10000 + state.length * 123 + 456)}';

    final timeStr = DateFormat('hh:mm a').format(now).toLowerCase();
    final dateStr = DateFormat('dd MMM').format(now);

    final newOrder = OrderModel(
      id: newId,
      orderNumber: orderNum,
      orderDate: now,
      status: OrderStatus.confirming,
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      discount: discount,
      total: total,
      deliveryAddress: address,
      contactNumber: phone,
      paymentMethod: paymentMethod,
      prescriptionUrl: prescriptionUrl,
      trackingTimeline: [
        TrackingStep(
          title: 'Confirming',
          date: dateStr,
          time: timeStr,
          description: 'Payment authorized & waiting for pharmacy verification',
          isCompleted: true,
          isCurrent: true,
        ),
        TrackingStep(
          title: 'Pending',
          date: dateStr,
          time: timeStr,
          description: 'Order placed successfully by customer',
          isCompleted: true,
        ),
      ],
    );

    state = [newOrder, ...state];
    return newId;
  }
}

final ordersProvider =
    StateNotifierProvider<OrderNotifier, List<OrderModel>>((ref) {
  return OrderNotifier();
});

final selectedOrderIdProvider = StateProvider<String?>((ref) => 'ord_1');

final selectedOrderProvider = Provider<OrderModel?>((ref) {
  final orderId = ref.watch(selectedOrderIdProvider);
  final orders = ref.watch(ordersProvider);
  if (orderId == null || orders.isEmpty) return null;
  return orders.firstWhere(
    (o) => o.id == orderId,
    orElse: () => orders.first,
  );
});
