import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;
  final String strength;
  final bool isSelected;

  const CartItemModel({
    required this.product,
    this.quantity = 1,
    required this.strength,
    this.isSelected = true,
  });

  double get itemTotal => product.price * quantity;

  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
    String? strength,
    bool? isSelected,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      strength: strength ?? this.strength,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
