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
import '../Repository/product_repository.dart';


class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productProvider.notifier).fetchProducts();
    });

    _razorpay = Razorpay();
    _setupRazorpayCallbacks();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _setupRazorpayCallbacks() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Utils.flushbarErrorMessage("Payment Successful: ${response.paymentId}", context, type: FlushbarType.success);
    ref.read(productProvider.notifier).clearCart();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, RoutesName.preHome, arguments: 0);
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Utils.flushbarErrorMessage("Payment Failed: ${response.message}", context, type: FlushbarType.error);
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, RoutesName.preHome, arguments: 0);
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Utils.flushbarErrorMessage("External Wallet Selected: ${response.walletName}", context, type: FlushbarType.warning);
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, RoutesName.preHome, arguments: 0);
    });
  }

  void _openRazorpayPayment(double totalAmount, BuildContext context) {
    int amountInPaise = (totalAmount * 100).toInt();


    var options = {
      'key': 'rzp_test_RGeZKafEfOCqn8',
      'amount': amountInPaise,
      'name': 'Foodie App',
      'description': 'Cart Payment',
      'prefill': {
        'contact': '9927845706',
        'email': 'dhrumil@example.com',
      },
      'theme': {
        'color': '#FF6B35'
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cart = state.cartItems;
    final cartProducts = state.cartItems.map((e) => e.product).toList().reversed.toList();

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation(theme.primaryColor),
          ),
        ),
      );
    }

    if (state.cartItems.isEmpty) {
      return _buildEmptyCart(theme, context, isDark);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'My Cart',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: theme.cardTheme.color,
        foregroundColor: theme.iconTheme.color,
        iconTheme: theme.iconTheme,
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
                return _buildCartItem(product, quantity, theme, context, state, isDark);
              },
            ),
          ),
          _buildCheckoutSection(state, theme, cart, isDark),
        ],
      ),
    );
  }

  Widget _buildCartItem(Product product, int quantity, ThemeData theme, BuildContext context, ProductState state, bool isDark) {
    final hasDiscount = product.discountPercentage > 0;
    final originalPrice = product.price + (product.price * product.discountPercentage / 100);
    final cardColor = isDark ? AppColors.gray800 : AppColors.surface;
    final shadowColor = isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05);
    final quantityBgColor = isDark ? AppColors.gray700 : AppColors.gray100;
    final iconColor = isDark ? AppColors.gray400 : AppColors.gray600;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
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
                    color: isDark ? AppColors.gray700 : AppColors.orangeLight,
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
                              color: isDark ? AppColors.gray500 : AppColors.gray300,
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
                                Colors.black.withOpacity(isDark ? 0.2 : 0.05),
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
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: _getCategoryColor(product.category, isDark),
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Title
                      Text(
                        product.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          height: 1.3,
                          fontWeight: FontWeight.w600,
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
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: theme.primaryColor,
                                ),
                              ),
                              if (hasDiscount) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '\$${originalPrice.toStringAsFixed(2)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isDark ? AppColors.gray500 : AppColors.gray500,
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
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
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
                          color: quantityBgColor,
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
                                color: quantityBgColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.remove, size: 18, color: iconColor),
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
                              color: quantityBgColor,
                              alignment: Alignment.center,
                              child: Text(
                                quantity.toString(),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            // Increase button
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(isDark ? 0.3 : 0.15),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.add, size: 18, color: theme.primaryColor),
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
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.delete,
                  color: theme.primaryColor,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection(ProductState state, ThemeData theme, List<CartItem> cartProducts, bool isDark) {
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
        color: theme.cardTheme.color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
            blurRadius: 16,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Price breakdown
          _buildPriceRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}', theme),
          const SizedBox(height: 8),
          _buildPriceRow('Shipping', '\$${shipping.toStringAsFixed(2)}', theme),
          const SizedBox(height: 8),
          _buildPriceRow('Tax', '\$${tax.toStringAsFixed(2)}', theme),
          const SizedBox(height: 16),
          Divider(height: 1, color: isDark ? AppColors.gray700 : AppColors.gray300),
          const SizedBox(height: 16),
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.primaryColor,
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
              gradient: isDark
                  ? LinearGradient(
                colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
                  : AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withOpacity(isDark ? 0.4 : 0.3),
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
                  _openRazorpayPayment(total, context);
                },
                child: Center(
                  child: Text(
                    'Proceed to Checkout',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  Widget _buildPriceRow(String label, String value, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.gray400 : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCart(ThemeData theme, BuildContext context, bool isDark) {
    final emptyCartColor = isDark ? AppColors.gray700 : AppColors.orangeLight;
    final buttonColor = isDark ? AppColors.primaryDark : AppColors.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'My Cart',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        backgroundColor: theme.cardTheme.color,
        elevation: 0,
        foregroundColor: theme.iconTheme.color,
        iconTheme: theme.iconTheme,
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
                  color: theme.primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 60,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Your cart is empty',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Looks like you haven\'t added anything to your cart yet',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.gray400 : AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, RoutesName.preHome, arguments: 0);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'Browse Products',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
Color _getCategoryColor(String category, bool isDark) {
  final categoryColors = {
    'groceries': isDark ? AppColors.success : AppColors.success,
    'fragrances': isDark ? AppColors.indigo : AppColors.indigo,
    'furniture': isDark ? AppColors.orangeDark : AppColors.orange,
    'beauty': isDark ? AppColors.purple : AppColors.purple,
    'electronics': isDark ? AppColors.teal : AppColors.teal,
  };
  return categoryColors[category.toLowerCase()] ?? (isDark ? AppColors.gray400 : AppColors.gray600);
}