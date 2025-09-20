import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_folder_strucutre/Model/State%20Model/product_state.dart';
import '../Model/cart_item_model.dart';
import '../Model/product_model.dart';
import '../Repository/product_repository.dart';

final productProvider = StateNotifierProvider<ProductNotifier,ProductState>((ref) {
  return ProductNotifier(ProductRepository());
},);

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepository _repo;
  ProductNotifier(this._repo): super(ProductState());

  /// Add product to cart (or increase qty if already exists)
  void addToCart(Product product, int qty) {
    final updatedCart = List<CartItem>.from(state.cartItems);

    final index = updatedCart.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      final existing = updatedCart[index];
      updatedCart[index] = existing.copyWith(
        quantity: (existing.quantity + qty).clamp(1, 99),
      );
    } else {
      updatedCart.add(CartItem(product: product, quantity: qty));
    }

    final total = updatedCart
        .map((e) => (double.parse(e.product.price.toString()) * e.quantity))
        .fold(0.0, (a, b) => a + b);


    state = state.copyWith(cartItems: updatedCart, cartTotal: total);
  }

  void decreaseQty(int productId) {
    final updatedCart = List<CartItem>.from(state.cartItems);

    final index = updatedCart.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      final existing = updatedCart[index];

      if (existing.quantity > 1) {
        // Just decrease
        updatedCart[index] = existing.copyWith(quantity: existing.quantity - 1);
        debugPrint("Decreased qty of $productId → ${existing.quantity - 1}");
      } else {
        // Remove completely if qty = 1
        updatedCart.removeAt(index);
        debugPrint("Removed product $productId from cart");
      }

      // Recalculate total
      final total = updatedCart.fold<double>(
        0.0,
            (sum, e) => sum + (e.product.price * e.quantity),
      );

      state = state.copyWith(cartItems: updatedCart, cartTotal: total);
    }
  }


  /// Remove product completely from cart
  void removeFromCart(String productId) {
    final updatedCart = List<CartItem>.from(state.cartItems);

    // Find index by productId
    final index = updatedCart.indexWhere((item) => item.product.id.toString() == productId);

    if (index != -1) {
      updatedCart.removeAt(index);

      // Recalculate total
      final total = updatedCart
          .map((e) => (double.parse(e.product.price.toString()) * e.quantity))
          .fold(0.0, (a, b) => a + b);

      state = state.copyWith(cartItems: updatedCart, cartTotal: total);
      debugPrint("Removed from cart: $productId");
    }
  }




  void addToFavorite(String productId) {
    final updatedFavorites = List<String>.from(state.favoriteItems);

    if (updatedFavorites.contains(productId)) {
      updatedFavorites.remove(productId);
      debugPrint("Removed $productId");
    } else {
      updatedFavorites.add(productId); // stays in selection order
      debugPrint("Added $productId");
    }

    state = state.copyWith(favoriteItems: updatedFavorites);
  }

  void clearCart(){
    state = state.copyWith(cartItems: [], cartTotal: 0.0);
  }


  void showFavoriteItems() {
    debugPrint("Favorite items: ${state.favoriteItems}");
  }

  Future<void> fetchProducts() async{
    try{
      state = state.copyWith(isLoading: true);
      final result = await _repo.fetchProductData();
      state = state.copyWith(productResponse: result, isLoading: false);


    }catch(e){
      state = state.copyWith(error: e.toString(),isLoading: false);
    }
  }
}