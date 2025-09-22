import 'package:mvvm_folder_strucutre/Model/cart_item_model.dart';
import 'package:mvvm_folder_strucutre/Model/product_model.dart';

class ProductState {
  final List<Product>? products;
  final bool isLoading;
  final String? error;
  final List<String> favoriteItems;
  final List<CartItem> cartItems;
  final double cartTotal;
  ProductState({
    this.products = const [],
    this.isLoading = false,
    this.error,
    this.favoriteItems = const [],
    this.cartItems = const [],
    this.cartTotal = 0
  });


  ProductState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? error,
    List<String>? favoriteItems,
    List<CartItem>? cartItems,
    double? cartTotal
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      favoriteItems: favoriteItems ?? this.favoriteItems,
      cartItems: cartItems ?? this.cartItems,
      cartTotal: cartTotal ?? this.cartTotal
    );
  }
}
