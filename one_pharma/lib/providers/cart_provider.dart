import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/cart_item_model.dart';
import '../data/models/product_model.dart';

class CartState {
  final List<CartItemModel> items;

  const CartState({required this.items});

  List<CartItemModel> get selectedItems =>
      items.where((item) => item.isSelected).toList();

  bool get isAllSelected =>
      items.isNotEmpty && items.every((item) => item.isSelected);

  int get totalItemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => selectedItems.fold(
      0.0, (sum, item) => sum + (item.product.price * item.quantity));

  double get deliveryFee => selectedItems.isEmpty ? 0.0 : 10.0;

  double get discount => selectedItems.isEmpty ? 0.0 : 8.0;

  double get grandTotal {
    if (selectedItems.isEmpty) return 0.0;
    final total = subtotal + deliveryFee - discount;
    return total > 0 ? total : 0.0;
  }

  bool get requiresPrescription => selectedItems
      .any((item) => item.product.isPrescriptionRequired);

  CartState copyWith({List<CartItemModel>? items}) {
    return CartState(items: items ?? this.items);
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState(items: []));

  void addItem(ProductModel product, {String? strength, int quantity = 1}) {
    final targetStrength = strength ?? product.selectedStrength;
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == product.id && item.strength == targetStrength,
    );

    if (existingIndex != -1) {
      final updatedList = List<CartItemModel>.from(state.items);
      final current = updatedList[existingIndex];
      updatedList[existingIndex] = current.copyWith(
        quantity: current.quantity + quantity,
      );
      state = state.copyWith(items: updatedList);
    } else {
      final newItem = CartItemModel(
        product: product,
        strength: targetStrength,
        quantity: quantity,
        isSelected: true,
      );
      state = state.copyWith(items: [...state.items, newItem]);
    }
  }

  void prepareOrderNow(
    ProductModel product, {
    String? strength,
    int? quantity,
  }) {
    final targetStrength = strength ?? product.selectedStrength;
    final updatedList =
        state.items.map((item) => item.copyWith(isSelected: false)).toList();

    final existingIndex = updatedList.indexWhere(
      (item) => item.product.id == product.id && item.strength == targetStrength,
    );

    if (existingIndex != -1) {
      final current = updatedList[existingIndex];
      updatedList[existingIndex] = current.copyWith(
        quantity: quantity ?? current.quantity,
        isSelected: true,
      );
    } else {
      updatedList.add(
        CartItemModel(
          product: product,
          strength: targetStrength,
          quantity: quantity ?? 1,
          isSelected: true,
        ),
      );
    }

    state = state.copyWith(items: updatedList);
  }

  void updateQuantity(String productId, String strength, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId, strength);
      return;
    }
    final updatedList = state.items.map((item) {
      if (item.product.id == productId && item.strength == strength) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();
    state = state.copyWith(items: updatedList);
  }

  void removeItem(String productId, String strength) {
    final updatedList = state.items
        .where((item) => !(item.product.id == productId && item.strength == strength))
        .toList();
    state = state.copyWith(items: updatedList);
  }

  void toggleItemSelection(String productId, String strength) {
    final updatedList = state.items.map((item) {
      if (item.product.id == productId && item.strength == strength) {
        return item.copyWith(isSelected: !item.isSelected);
      }
      return item;
    }).toList();
    state = state.copyWith(items: updatedList);
  }

  void toggleSelectAll() {
    final shouldSelect = !state.isAllSelected;
    final updatedList = state.items.map((item) {
      return item.copyWith(isSelected: shouldSelect);
    }).toList();
    state = state.copyWith(items: updatedList);
  }

  void clearCart() {
    state = const CartState(items: []);
  }

  void removeSelected() {
    final updatedList = state.items.where((item) => !item.isSelected).toList();
    state = state.copyWith(items: updatedList);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
