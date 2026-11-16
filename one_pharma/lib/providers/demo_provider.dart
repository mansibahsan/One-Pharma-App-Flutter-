import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock/mock_data.dart';
import '../data/models/address_model.dart';
import 'cart_provider.dart';
import 'address_provider.dart';
import 'order_provider.dart';
import 'prescription_provider.dart';
import 'reminder_provider.dart';
import 'wishlist_provider.dart';

enum DemoPersona {
  newPatient,
  regularCustomer,
  chronicCare;

  String get label {
    switch (this) {
      case DemoPersona.newPatient:
        return 'New Patient (Empty Cart & Welcome)';
      case DemoPersona.regularCustomer:
        return 'Regular Customer (Active Orders & Saved Bag)';
      case DemoPersona.chronicCare:
        return 'Chronic Care (Active Rx & Pill Schedule)';
    }
  }

  String get subtitle {
    switch (this) {
      case DemoPersona.newPatient:
        return 'Fresh experience with empty bag, no orders, clean states';
      case DemoPersona.regularCustomer:
        return '3 items in bag, active delivery tracking, 3 saved addresses';
      case DemoPersona.chronicCare:
        return '2 verified prescriptions, 4 pill reminders, refill alerts';
    }
  }
}

final currentDemoPersonaProvider =
    StateProvider<DemoPersona>((ref) => DemoPersona.regularCustomer);

void applyDemoPersona(WidgetRef ref, DemoPersona persona) {
  ref.read(currentDemoPersonaProvider.notifier).state = persona;

  final products = MockData.products;

  switch (persona) {
    case DemoPersona.newPatient:
      ref.read(cartProvider.notifier).clearCart();
      ref.read(ordersProvider.notifier).setOrders([]);
      ref.read(addressProvider.notifier).setAddresses([
        const AddressModel(
          id: 'addr_1',
          label: 'Home',
          recipientName: 'New Patient',
          phone: '+880 1711-234567',
          streetAddress: 'Road #5, Block C',
          area: 'Banani',
          city: 'Dhaka 1213',
          isDefault: true,
        ),
      ]);
      ref.read(prescriptionProvider.notifier).setPrescriptions([]);
      ref.read(reminderProvider.notifier).setReminders([]);
      ref.read(wishlistProvider.notifier).setWishlist([]);
      break;

    case DemoPersona.regularCustomer:
      ref.read(cartProvider.notifier).clearCart();
      ref.read(cartProvider.notifier).addItem(products[0], quantity: 2); // Napa Extend
      ref.read(cartProvider.notifier).addItem(products[4], quantity: 1); // Hexisol Hand Rub
      ref.read(cartProvider.notifier).addItem(products[5], quantity: 1); // 3-Ply Surgical Mask
      ref.read(ordersProvider.notifier).setOrders(MockData.mockOrders);
      ref.read(addressProvider.notifier).setAddresses(MockData.initialAddresses);
      ref.read(prescriptionProvider.notifier).setPrescriptions(MockData.initialPrescriptions);
      ref.read(reminderProvider.notifier).setReminders(MockData.initialReminders);
      ref.read(wishlistProvider.notifier).setWishlist([products[4], products[11]]);
      break;

    case DemoPersona.chronicCare:
      ref.read(cartProvider.notifier).clearCart();
      ref.read(cartProvider.notifier).addItem(products[8], quantity: 1); // Lantus Insulin Pen
      ref.read(cartProvider.notifier).addItem(products[3], quantity: 1); // Normal Saline 0.9%
      ref.read(ordersProvider.notifier).setOrders(MockData.mockOrders);
      ref.read(addressProvider.notifier).setAddresses(MockData.initialAddresses);
      ref.read(prescriptionProvider.notifier).setPrescriptions(MockData.initialPrescriptions);
      ref.read(reminderProvider.notifier).setReminders(MockData.initialReminders);
      ref.read(wishlistProvider.notifier).setWishlist([products[7], products[8], products[11]]);
      break;
  }
}
