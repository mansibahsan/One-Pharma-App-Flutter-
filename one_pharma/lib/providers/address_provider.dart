import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/address_model.dart';
import '../data/mock/mock_data.dart';

class AddressNotifier extends StateNotifier<List<AddressModel>> {
  AddressNotifier() : super(MockData.initialAddresses);

  void addAddress(AddressModel address) {
    if (address.isDefault) {
      state = state.map((a) => a.copyWith(isDefault: false)).toList();
    }
    state = [...state, address];
  }

  void setDefault(String id) {
    state = state.map((a) => a.copyWith(isDefault: a.id == id)).toList();
  }

  void removeAddress(String id) {
    state = state.where((a) => a.id != id).toList();
  }

  void setAddresses(List<AddressModel> addresses) {
    state = addresses;
  }
}

final addressProvider =
    StateNotifierProvider<AddressNotifier, List<AddressModel>>((ref) {
  return AddressNotifier();
});

final selectedAddressProvider = Provider<AddressModel?>((ref) {
  final addresses = ref.watch(addressProvider);
  if (addresses.isEmpty) return null;
  return addresses.firstWhere((a) => a.isDefault, orElse: () => addresses.first);
});
