import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_folder_strucutre/Model/State%20Model/product_state.dart';
import 'package:mvvm_folder_strucutre/Model/cart_item_model.dart';
import 'package:mvvm_folder_strucutre/View-Model/product_view_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../Core/Routes/routes_name.dart';
import '../Core/Util/utils.dart';
import '../Model/product_model.dart';
import '../Core/theme/app_colors.dart';
import '../Core/theme/text_styles.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productProvider.notifier).fetchProducts();
    });
  }

  void _openRazorpayPayment(double totalAmount,BuildContext context) {
    int amountInPaise = (totalAmount * 100).toInt(); // Convert dollars to paise

    var options = {
      'key': 'rzp_test_RGeZKafEfOCqn8', // Your Razorpay Key ID
      'amount': amountInPaise, // Amount in paise
      'name': 'Foodie App',
      'description': 'Cart Payment',
      'prefill': {
        'contact': '9999999999',
        'email': 'test@example.com',
      },
      'theme': {
        'color': '#F37254'
      }
    };

    try {
      Razorpay _razorpay = Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
        Utils.flushbarErrorMessage("Payment Successful: ${response.paymentId}", context,type: FlushbarType.success);
        ref.read(productProvider.notifier).clearCart();
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, RoutesName.preHome, arguments: 0);
        });
      });
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (response) {

        Utils.flushbarErrorMessage("Payment Failed: ${response.message}", context,type: FlushbarType.error);
        ref.read(productProvider.notifier).clearCart();
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, RoutesName.preHome, arguments: 0);
        });
      });
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (response) {
        Utils.flushbarErrorMessage("External Wallet Selected: ${response.walletName}", context,type: FlushbarType.warning);
        ref.read(productProvider.notifier).clearCart();
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, RoutesName.preHome, arguments: 0);
        });
      });

      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productProvider);
    final theme = Theme.of(context);
    debugPrint("total : ${state.cartTotal}");
    final cart = state.cartItems;
    final cartProducts = state.cartItems.map((e) {
      return e.product;
    }).toList().reversed.toList();

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation(theme.primaryColor),
          ),
        ),
      );
    }

    if (state.cartItems.isEmpty) {
      return _buildEmptyCart(theme, context);
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        automaticallyImplyLeading: false, // removes the default back button
        title: Text(
          'My Cart',
          style: TextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textSecondary,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16, top: 8),
              itemCount: cartProducts.length,
              itemBuilder: (context, index) {
                final product = cartProducts[index];
                final cartItem = cart.firstWhere((item) => item.product.id == product.id);
                final quantity = cartItem.quantity ?? 1;
                return _buildCartItem(product, quantity, theme, context, state);
              },
            ),
          ),
          _buildCheckoutSection(state, theme, cart),
        ],
      ),
    );
  }

  Widget _buildCartItem(Product product, int quantity, ThemeData theme, BuildContext context, ProductState state) {
    final hasDiscount = product.discountPercentage > 0;
    final originalPrice = product.price + (product.price * product.discountPercentage / 100);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.orangeLight,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Image.asset(
                          product.images.isNotEmpty ? product.images[0] : '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: AppColors.gray300,
                              size: 32,
                            ),
                          ),
                        ),
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.05),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category
                      Text(
                        product.category.toUpperCase(),
                        style: TextStyles.labelMedium.copyWith(
                          color: _getCategoryColor(product.category),
                          letterSpacing: 0.8,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Title
                      Text(
                        product.title,
                        style: TextStyles.titleSmall.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              if (hasDiscount) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '\$${originalPrice.toStringAsFixed(2)}',
                                  style: TextStyles.bodySmall.copyWith(
                                    color: AppColors.gray500,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (hasDiscount)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.error,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                                  style: TextStyles.labelSmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Quantity controls
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.gray100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Decrease button
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.gray100,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.remove, size: 18, color: AppColors.gray600),
                                onPressed: () {
                                  if (quantity > 1) {
                                    ref.read(productProvider.notifier).decreaseQty(product.id);
                                  } else {
                                    ref.read(productProvider.notifier).removeFromCart(product.id.toString());
                                  }
                                },
                              ),
                            ),

                            // Quantity display
                            Container(
                              width: 40,
                              height: 36,
                              color: AppColors.gray100,
                              alignment: Alignment.center,
                              child: Text(
                                quantity.toString(),
                                style: TextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),

                            // Increase button
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.add, size: 18, color: AppColors.primary),
                                onPressed: () {
                                  ref.read(productProvider.notifier).addToCart(product, 1);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Remove button at top right corner
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () {
                ref.read(productProvider.notifier).removeFromCart(product.id.toString());
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: AppColors.gray600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection(ProductState state, ThemeData theme, List<CartItem> cartProducts) {
    double subtotal = 0;
    for (var item in cartProducts) {
      final quantity = item.quantity ?? 1;
      subtotal += (item.product.price) * quantity;
    }

    const shipping = 5.99;
    const tax = 2.50;
    final total = subtotal + shipping + tax;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Price breakdown
          _buildPriceRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildPriceRow('Shipping', '\$${shipping.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildPriceRow('Tax', '\$${tax.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          Divider(height: 1, color: AppColors.gray300),
          const SizedBox(height: 16),
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: TextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Checkout Button
          Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  const shipping = 5.99;
                  const tax = 2.50;
                  final total = state.cartTotal + shipping + tax;

                  _openRazorpayPayment(total,context);


                },
                child: Center(
                  child: Text(
                    'Proceed to Checkout',
                    style: TextStyles.buttonLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCart(ThemeData theme, BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        automaticallyImplyLeading: false, // removes the default back button
        title: Text(
          'My Cart',
          style: TextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: AppColors.textSecondary,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.orangeLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Your cart is empty',
                style: TextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Looks like you haven\'t added anything to your cart yet',
                textAlign: TextAlign.center,
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, RoutesName.preHome, arguments: 0);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'Browse Products',
                  style: TextStyles.buttonMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper function to get category color
Color _getCategoryColor(String category) {
  final categoryColors = {
    'groceries': AppColors.success,
    'fragrances': AppColors.indigo,
    'furniture': AppColors.orangeDark,
    'beauty': AppColors.purple,
  };
  return categoryColors[category.toLowerCase()] ?? AppColors.gray600;
}


