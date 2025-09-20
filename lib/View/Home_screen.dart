import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_folder_strucutre/Core/Routes/routes_name.dart';
import 'package:mvvm_folder_strucutre/Core/Theme/app_colors.dart';
import 'package:mvvm_folder_strucutre/Core/Theme/text_styles.dart';
import 'package:mvvm_folder_strucutre/View-Model/auth_view_model.dart';
import 'package:mvvm_folder_strucutre/View/favorite_screen.dart';
import 'package:mvvm_folder_strucutre/View/pre_home_screen.dart';
import 'package:mvvm_folder_strucutre/View/product_detail_screen.dart';
import '../Model/State Model/product_state.dart';
import '../Model/product_model.dart';
import '../View-Model/product_view_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedCategoryIndex = 0;
  TextEditingController searchController = TextEditingController();
  int _currentBannerIndex = 0;

  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.restaurant_menu, 'count': 45},
    {'name': 'Pizza', 'icon': Icons.local_pizza, 'count': 12},
    {'name': 'Burger', 'icon': Icons.fastfood, 'count': 8},
    {'name': 'Sushi', 'icon': Icons.set_meal, 'count': 6},
    {'name': 'Dessert', 'icon': Icons.cake, 'count': 10},
    {'name': 'Drinks', 'icon': Icons.local_drink, 'count': 9},
  ];

  final  banners = [
    "assets/images/banner1.jpg",
    "assets/images/banner2.jpg",
    "assets/images/banner3.jpg"
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productProvider.notifier).fetchProducts();
      ref.read(productProvider.notifier).showFavoriteItems();
    });

    // Auto-animate banners
    _startBannerAnimation();
  }

  void _startBannerAnimation() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _currentBannerIndex = (_currentBannerIndex + 1) % banners.length;
        });
        _startBannerAnimation();
      }
    });
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good morning!";
    } else if (hour < 17) {
      return "Good afternoon!";
    } else if (hour < 20) {
      return "Good evening!";
    } else {
      return "Good night!";
    }
  }


  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productProvider);
    final size = MediaQuery.sizeOf(context);

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation(AppColors.orange),
          ),
        ),
      );
    }

    if (state.error != null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.gray400),
              const SizedBox(height: 16),
              Text(
                "Something went wrong",
                style: TextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Text(
                "Error: ${state.error}",
                style: TextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ref.read(productProvider.notifier).fetchProducts();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                ),
                child: Text("Try Again", style: TextStyles.buttonMedium),
              ),
            ],
          ),
        ),
      );
    }

    final products = state.productResponse?.products ?? [];
    final filteredProducts = searchController.text.isEmpty
        ? products
        : products.where((product) {
      return product.title.toLowerCase().contains(searchController.text.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(productProvider.notifier).fetchProducts();
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            // Custom App Bar
            _buildCustomAppBar(size, state),

            // Banner Slider
            _buildBannerSlider(),

            // Categories Section
            _buildCategoriesSection(),

            // Featured Restaurants Header
            _buildFeaturedHeader(),

            // Featured Restaurants
            _buildFeaturedRestaurants(),

            // Popular Items Header
            _buildPopularItemsHeader(filteredProducts.length),

            // Products Grid
            _buildProductsGrid(filteredProducts, state),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildCustomAppBar(Size size, ProductState state) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: true,
      expandedHeight: 190,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 10),
          child: Row(
            children: [
              // Location and Greeting
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getGreeting(),
                      style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 20, color: AppColors.orange),
                        const SizedBox(width: 4),
                        Text(
                          'New York, NY',
                          style: TextStyles.titleSmall.copyWith(color: AppColors.textPrimary,fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Cart Button with Badge
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart_outlined, size: 28, color: AppColors.textPrimary),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PreHomeScreen(screenNo: 2)),
                      );
                    },
                  ),
                  if (state.cartItems.isNotEmpty)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            state.cartItems.length.toString(),
                            style: TextStyles.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
              // Favorite Button
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite_outline, size: 28, color: AppColors.textPrimary),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PreHomeScreen(screenNo: 1)),
                      );
                    },
                  ),
                  if (state.favoriteItems.isNotEmpty)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            state.favoriteItems.length.toString(),
                            style: TextStyles.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: Colors.white,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for food, restaurants...',
                hintStyle: TextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                prefixIcon: Icon(Icons.search, color: AppColors.orange, size: 22),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1.2
                  )
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1.5
                    )                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.orange, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
                filled: true,
                fillColor: AppColors.gray50,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildBannerSlider() {
    return SliverToBoxAdapter(
      child: Container(
        height: 160,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Banner Image

          AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Image.asset(
            banners[_currentBannerIndex], // pick current banner
            key: ValueKey<int>(_currentBannerIndex), // important for animation
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) => Container(
              color: AppColors.gray200,
              child: Center(
                child: Icon(
                  Icons.fastfood,
                  size: 60,
                  color: AppColors.gray400,
                ),
              ),
            ),
          ),
        ),


              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                  ),
                ),
              ),

              // Banner Content
              Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Special Offer',
                      style: TextStyles.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Get 50% off on your first order',
                      style: TextStyles.bodyMedium.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Indicator
              Positioned(
                bottom: 15,
                right: 20,
                child: Row(
                  children: List.generate(banners.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _currentBannerIndex == index ? 20 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: _currentBannerIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildCategoriesSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Categories',
              style: TextStyles.headlineSmall,
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _selectedCategoryIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 80,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.orangeLight : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.orange : AppColors.gray300,
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.orange : AppColors.gray100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            category['icon'] as IconData,
                            color: isSelected ? Colors.white : AppColors.orange,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category['name'] as String,
                          style: TextStyles.labelMedium.copyWith(
                            color: isSelected ? AppColors.orange : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildFeaturedHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Text(
              'Featured Restaurants',
              style: TextStyles.headlineSmall,
            ),
            const Spacer(),
            Text(
              'View all',
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildFeaturedRestaurants() {
    final featuredRestaurants = [
      {'name': 'Pizza Paradise', 'rating': 4.8, 'image': 'https://images.unsplash.com/photo-1513104890138-7c749659a591'},
      {'name': 'Burger King', 'rating': 4.5, 'image': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add'},
      {'name': 'Sushi Express', 'rating': 4.7, 'image': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351'},
    ];

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: featuredRestaurants.length,
          itemBuilder: (context, index) {
            final restaurant = featuredRestaurants[index];
            return Container(
              width: 280,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                    child: Image.network(
                      restaurant['image'] as String,
                      width: 100,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 100,
                        color: AppColors.gray200,
                        child: Icon(Icons.restaurant, color: AppColors.gray400),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            restaurant['name'] as String,
                            style: TextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.star, size: 16, color: AppColors.warning),
                              const SizedBox(width: 4),
                              Text(
                                restaurant['rating'].toString(),
                                style: TextStyles.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '30-45 min • Free delivery',
                            style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildPopularItemsHeader(int productCount) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Text(
              'Popular Items',
              style: TextStyles.headlineSmall,
            ),
            const Spacer(),
            Text(
              '$productCount items',
              style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  SliverGrid _buildProductsGrid(List<Product> filteredProducts, ProductState state) {
    if (filteredProducts.isEmpty) {
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        delegate: SliverChildBuilderDelegate((context, index) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 60, color: AppColors.gray300),
                const SizedBox(height: 16),
                Text(
                  'No food items found',
                  style: TextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try a different search term',
                  style: TextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
          );
        }, childCount: 1),
      );
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.5,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final product = filteredProducts[index];
        return Padding(
          padding: EdgeInsets.only(
            left: index % 2 == 0 ? 16.0 : 0.0,
            right: index % 2 != 0 ? 16.0 : 0.0,
          ),
          child: FoodItemCard(product: product, ref: ref, productState: state),
        );
      }, childCount: filteredProducts.length),
    );
  }
}

class FoodItemCard extends StatelessWidget {
  final Product product;
  final WidgetRef ref;
  final ProductState productState;

  const FoodItemCard({
    super.key,
    required this.product,
    required this.ref,
    required this.productState,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.discountPercentage > 0;
    final originalPrice = product.price + (product.price * product.discountPercentage / 100);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food Image with Badges
            Stack(
              children: [
                // Food Image
                Container(
                  height: 175,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    color: AppColors.gray100,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      product.images[0],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.fastfood,
                          color: AppColors.gray400,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),

                // Discount Badge
                if (hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      ref.read(productProvider.notifier).addToFavorite(product.id.toString());
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        productState.favoriteItems.contains(product.id.toString())
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: productState.favoriteItems.contains(product.id.toString())
                            ? AppColors.error
                            : AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Food Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    product.title,
                    style: TextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Category
                  Text(
                    product.category.replaceAll('-', ' ').toUpperCase(),
                    style: TextStyles.labelSmall.copyWith(
                      color: AppColors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Rating and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rating
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: TextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),

                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyles.titleSmall.copyWith(
                              color: AppColors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (hasDiscount)
                            Text(
                              '\$${originalPrice.toStringAsFixed(2)}',
                              style: TextStyles.bodySmall.copyWith(
                                color: AppColors.textTertiary,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(productProvider.notifier).addToCart(product,1);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Add to Cart',
                        style: TextStyles.buttonSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}