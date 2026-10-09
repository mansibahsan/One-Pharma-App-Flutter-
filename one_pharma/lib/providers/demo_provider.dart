import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock/mock_data.dart';
import '../data/models/address_model.dart';
import 'cart_provider.dart';
import 'address_provider.dart';
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
        return 'Fresh experience with welcome coupon and clean states';
      case DemoPersona.regularCustomer:
        return '3 items in bag, order out for delivery, 2 saved addresses';
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
      // Empty cart, no orders, clean addresses
      ref.read(cartProvider.notifier).clearCart();
      ref.read(addressProvider.notifier).setAddresses([
        const AddressModel(
          id: 'addr_1',
          label: 'Home',
          recipientName: 'New Patient',
          phone: '0171-1234567',
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
      // Active cart, standard orders, verified addresses
      ref.read(cartProvider.notifier).clearCart();
      ref.read(cartProvider.notifier).addItem(products[0], quantity: 2);
      ref.read(cartProvider.notifier).addItem(products[1], quantity: 1);
      ref.read(cartProvider.notifier).addItem(products[4], quantity: 1);
      ref.read(addressProvider.notifier).setAddresses(MockData.initialAddresses);
      ref.read(prescriptionProvider.notifier).setPrescriptions(MockData.initialPrescriptions);
      ref.read(reminderProvider.notifier).setReminders(MockData.initialReminders);
      ref.read(wishlistProvider.notifier).setWishlist([products[2], products[3]]);
      break;

    case DemoPersona.chronicCare:
      // Rich prescriptions, full reminders, due refills
      ref.read(cartProvider.notifier).clearCart();
      ref.read(cartProvider.notifier).addItem(products[2], quantity: 1); // Betulin Lux
      ref.read(addressProvider.notifier).setAddresses(MockData.initialAddresses);
      ref.read(prescriptionProvider.notifier).setPrescriptions(MockData.initialPrescriptions);
      ref.read(reminderProvider.notifier).setReminders(MockData.initialReminders);
      ref.read(wishlistProvider.notifier).setWishlist([products[0], products[1], products[4]]);
      break;
  }
}
