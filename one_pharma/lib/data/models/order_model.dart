import 'cart_item_model.dart';

enum OrderStatus {
  pending,
  confirming,
  processed,
  picked,
  shipped,
  delivered;

  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirming:
        return 'Confirming';
      case OrderStatus.processed:
        return 'Processed';
      case OrderStatus.picked:
        return 'Picked';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  int get stepIndex {
    switch (this) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.confirming:
        return 1;
      case OrderStatus.processed:
        return 2;
      case OrderStatus.picked:
        return 3;
      case OrderStatus.shipped:
        return 4;
      case OrderStatus.delivered:
        return 5;
    }
  }
}

class TrackingStep {
  final String title;
  final String date;
  final String time;
  final String description;
  final bool isCompleted;
  final bool isCurrent;

  const TrackingStep({
    required this.title,
    required this.date,
    required this.time,
    required this.description,
    this.isCompleted = false,
    this.isCurrent = false,
  });
}

class OrderModel {
  final String id;
  final String orderNumber;
  final DateTime orderDate;
  final OrderStatus status;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final String deliveryAddress;
  final String contactNumber;
  final String paymentMethod;
  final String? prescriptionUrl;
  final List<TrackingStep> trackingTimeline;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.deliveryAddress,
    required this.contactNumber,
    required this.paymentMethod,
    this.prescriptionUrl,
    required this.trackingTimeline,
  });
}
