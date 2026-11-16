import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/product_model.dart';

class WishlistNotifier extends StateNotifier<List<ProductModel>> {
  WishlistNotifier() : super(const []);

  void toggleWishlist(ProductModel product) {
    final exists = state.any((p) => p.id == product.id);
    if (exists) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      state = [...state, product];
    }
  }

  bool isWishlisted(String productId) {
    return state.any((p) => p.id == productId);
  }

  void setWishlist(List<ProductModel> products) {
    state = products;
  }
}

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, List<ProductModel>>((ref) {
  return WishlistNotifier();
});
