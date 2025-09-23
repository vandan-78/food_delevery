import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mvvm_folder_strucutre/Core/Theme/app_colors.dart';
import 'package:mvvm_folder_strucutre/Core/Theme/text_styles.dart';
import 'package:mvvm_folder_strucutre/Core/Util/utils.dart';
import 'package:mvvm_folder_strucutre/View/pre_home_screen.dart';
import 'package:mvvm_folder_strucutre/View/product_detail_screen.dart';
import '../Model/State Model/product_state.dart';
import '../Model/product_model.dart';
import '../View-Model/product_view_model.dart';
import '../View-Model/theme_view_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _currentAddress = "Fetching location...";
  final ScrollController _scrollController = ScrollController();
  int _selectedCategoryIndex = 0;
  TextEditingController searchController = TextEditingController();
  int _currentBannerIndex = 0;

  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.restaurant_menu, 'count': 45, 'type': 'all'},
    {'name': 'Pizza', 'icon': Icons.local_pizza, 'count': 12, 'type': 'pizza'},
    {'name': 'Burger', 'icon': Icons.fastfood, 'count': 8, 'type': 'burger'},
    {'name': 'Sushi', 'icon': Icons.set_meal, 'count': 6, 'type': 'sushi'},
    {'name': 'Dessert', 'icon': Icons.cake, 'count': 10, 'type': 'dessert'},
    {'name': 'Drinks', 'icon': Icons.local_drink, 'count': 9, 'type': 'drinks'},
    {'name': 'Chicken', 'icon': Icons.kebab_dining, 'count': 7, 'type': 'chicken'},
    {'name': 'Sides', 'icon': Icons.lunch_dining, 'count': 5, 'type': 'sides'},

  ];

  final banners = [
    "assets/images/banner1.jpg",
    "assets/images/banner2.jpg",
    "assets/images/banner3.jpg"
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserLocation();
      ref.read(productProvider.notifier).fetchProducts();
      ref.read(productProvider.notifier).showFavoriteItems();
    });

    _startBannerAnimation();
  }

  // Filter products based on selected category and search text
  List<Product> _getFilteredProducts(List<Product> products) {
    String searchText = searchController.text.toLowerCase();
    String selectedCategory = categories[_selectedCategoryIndex]['type'] as String;

    return products.where((product) {
      // First filter by search text
      bool matchesSearch = searchText.isEmpty ||
          product.title.toLowerCase().contains(searchText) ||
          product.description.toLowerCase().contains(searchText) ||
          product.tags.any((tag) => tag.toLowerCase().contains(searchText));

      // Then filter by category
      bool matchesCategory = selectedCategory == 'all' ||
          product.category.toLowerCase().contains(selectedCategory) ||
          product.tags.any((tag) => tag.toLowerCase().contains(selectedCategory)) ||
          (selectedCategory == 'pizza' && product.title.toLowerCase().contains('pizza')) ||
          (selectedCategory == 'burger' && product.title.toLowerCase().contains('burger')) ||
          (selectedCategory == 'sushi' && product.category.toLowerCase().contains('sushi')) ||
          (selectedCategory == 'dessert' && product.category.toLowerCase().contains('dessert')) ||
          (selectedCategory == 'drinks' && product.category.toLowerCase().contains('drinks')) ||
          (selectedCategory == 'chicken' &&
              (product.title.toLowerCase().contains('chicken') ||
                  product.tags.any((tag) => tag.toLowerCase().contains('chicken')))) ||
          (selectedCategory == 'sides' &&
              (product.tags.any((tag) => tag.toLowerCase().contains('sides')) ||
                  product.title.toLowerCase().contains('fries') ||
                  product.title.toLowerCase().contains('rings') ||
                  product.title.toLowerCase().contains('sticks')));

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // Update category counts based on actual products
  void _updateCategoryCounts(List<Product> products) {
    for (var category in categories) {
      String categoryType = category['type'] as String;
      int count = _getProductsByCategory(products, categoryType).length;
      category['count'] = count;
    }
  }

  List<Product> _getProductsByCategory(List<Product> products, String categoryType) {
    if (categoryType == 'all') return products;

    return products.where((product) {
      return product.category.toLowerCase().contains(categoryType) ||
          product.tags.any((tag) => tag.toLowerCase().contains(categoryType)) ||
          (categoryType == 'pizza' && product.title.toLowerCase().contains('pizza')) ||
          (categoryType == 'burger' && product.title.toLowerCase().contains('burger')) ||
          (categoryType == 'sushi' && product.category.toLowerCase().contains('sushi')) ||
          (categoryType == 'dessert' && product.category.toLowerCase().contains('dessert')) ||
          (categoryType == 'drinks' && product.category.toLowerCase().contains('drinks')) ||
          (categoryType == 'chicken' &&
              (product.title.toLowerCase().contains('chicken') ||
                  product.tags.any((tag) => tag.toLowerCase().contains('chicken')))) ||
          (categoryType == 'sides' &&
              (product.tags.any((tag) => tag.toLowerCase().contains('sides')) ||
                  product.title.toLowerCase().contains('fries') ||
                  product.title.toLowerCase().contains('rings') ||
                  product.title.toLowerCase().contains('sticks')));
    }).toList();
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _currentAddress = "Enable Location!.");
        _showSettingsDialog("Location Services", "Enable location services", true);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.deniedForever) {
        setState(() => _currentAddress = "Enable permission!.");
        _showSettingsDialog("Location Permission", "Enable location permission", false);
        return;
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.deniedForever) {
          setState(() => _currentAddress = "Enable permission!.");
          _showSettingsDialog("Location Permission", "Enable location permission", false);
          return;
        }

        if (permission == LocationPermission.denied) {
          setState(() => _currentAddress = "Permission denied");
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress = "${place.subLocality ?? ''}, ${place.locality ?? ''}";
        });
      }

    } catch (e) {
      setState(() => _currentAddress = "Location error");
      print("Location error: $e");
    }
  }

  void _showSettingsDialog(String title, String message, bool isLocationService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text("$message. Please enable it in settings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              isLocationService
                  ? Geolocator.openLocationSettings()
                  : Geolocator.openAppSettings();
            },
            child: Text("Open Settings"),
          ),
        ],
      ),
    );
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

  Future<bool?> _showExitDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            "Exit App",
            style: theme.textTheme.titleLarge?.copyWith(
              color: isDark ? AppColors.textDark : AppColors.textSecondary,
            ),
          ),
          content: Text(
            "Are you sure you want to exit the app?",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textDark : AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                "Cancel",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isDark ? AppColors.textDark : AppColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                SystemNavigator.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Exit"),
            ),
          ],
        );
      },
    );
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
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final size = MediaQuery.sizeOf(context);

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
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
        backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: isDarkMode ? AppColors.gray400 : AppColors.gray600),
              const SizedBox(height: 16),
              Text(
                "Something went wrong",
                style: TextStyles.bodyLarge.copyWith(
                  color: isDarkMode ? AppColors.textDark : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Error: ${state.error}",
                style: TextStyles.bodyMedium.copyWith(
                  color: isDarkMode ? AppColors.gray400 : AppColors.textTertiary,
                ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: _getUserLocation,
          child: Icon(Icons.location_on),
        ),
      );
    }

    final products = state.products ?? [];

    // Update category counts based on actual products
    if (products.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateCategoryCounts(products);
      });
    }

    final filteredProducts = _getFilteredProducts(products);

    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await _showExitDialog(context);
        return shouldExit ?? false;
      },
      child: Scaffold(
        backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: RefreshIndicator(
          onRefresh: () async {
            ref.read(productProvider.notifier).fetchProducts();
          },
          color: AppColors.orange,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              _buildCustomAppBar(size, state, isDarkMode),
              _buildBannerSlider(isDarkMode),
              _buildCategoriesSection(isDarkMode),
              _buildFeaturedHeader(isDarkMode),
              _buildFeaturedRestaurants(isDarkMode),
              _buildPopularItemsHeader(filteredProducts.length, isDarkMode),
              _buildProductsGrid(filteredProducts, state, isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  // ... (Keep all your existing _build methods exactly the same, they don't need changes)

  SliverAppBar _buildCustomAppBar(Size size, ProductState state, bool isDarkMode) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      floating: true,
      pinned: true,
      snap: true,
      expandedHeight: 190,
      backgroundColor: isDarkMode ? AppColors.gray800 : Colors.white,
      surfaceTintColor: isDarkMode ? AppColors.gray800 : Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.gray800 : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getGreeting(),
                      style: TextStyles.bodyMedium.copyWith(
                        color: isDarkMode ? AppColors.gray400 : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 20, color: AppColors.orange),
                        const SizedBox(width: 4),
                        Text(
                          _currentAddress,
                          style: TextStyles.titleSmall.copyWith(
                            color: isDarkMode ? AppColors.textDark : AppColors.textPrimary,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart_outlined, size: 26,
                        color: isDarkMode ? AppColors.textDark : AppColors.textPrimary),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PreHomeScreen(screenNo: 2)),
                      );
                    },
                  ),
                  if (state.cartItems.isNotEmpty)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(color: isDarkMode ? AppColors.gray800 : Colors.white, width: 1),
                        ),
                        child: Center(
                          child: Text(
                            state.cartItems.length.toString(),
                            style: TextStyles.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite_outline, size: 26,
                        color: isDarkMode ? AppColors.textDark : AppColors.textPrimary),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PreHomeScreen(screenNo: 1)),
                      );
                    },
                  ),
                  if (state.favoriteItems.isNotEmpty)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(color: isDarkMode ? AppColors.gray800 : Colors.white, width: 1),
                        ),
                        child: Center(
                          child: Text(
                            state.favoriteItems.length.toString(),
                            style: TextStyles.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
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
          color: isDarkMode ? AppColors.gray800 : Colors.white,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.gray700 : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {}); // Rebuild when search text changes
              },
              style: TextStyles.bodyMedium.copyWith(
                color: isDarkMode ? AppColors.textDark : AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search for food, restaurants...',
                hintStyle: TextStyles.bodyMedium.copyWith(
                  color: isDarkMode ? AppColors.gray400 : AppColors.textTertiary,
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.orange, size: 22),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDarkMode ? AppColors.gray600 : Colors.grey.shade200,
                    width: 1.2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDarkMode ? AppColors.gray600 : Colors.grey.shade200,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.orange, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
                filled: true,
                fillColor: isDarkMode ? AppColors.gray600 : AppColors.gray50,
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildCategoriesSection(bool isDarkMode) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Categories',
              style: TextStyles.headlineSmall.copyWith(
                color: isDarkMode ? AppColors.textDark : AppColors.textPrimary,
              ),
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
                      color: isSelected
                          ? AppColors.orangeLight
                          : isDarkMode ? AppColors.gray700 : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.orange
                            : isDarkMode ? AppColors.gray600 : AppColors.gray300,
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
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
                            color: isSelected ? AppColors.orange :
                            isDarkMode ? AppColors.gray600 : AppColors.gray100,
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
                            color: isSelected
                                ? AppColors.orange
                                : isDarkMode ? AppColors.textDark : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${category['count']}',
                          style: TextStyles.labelSmall.copyWith(
                            color: isSelected
                                ? AppColors.orange
                                : isDarkMode ? AppColors.gray400 : AppColors.textTertiary,
                          ),
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

  // ... (Keep all other _build methods exactly as they were)

  SliverToBoxAdapter _buildBannerSlider(bool isDarkMode) {
    return SliverToBoxAdapter(
      child: Container(
        height: 160,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Image.asset(
                  banners[_currentBannerIndex],
                  key: ValueKey<int>(_currentBannerIndex),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: isDarkMode ? AppColors.gray700 : AppColors.gray200,
                    child: Center(
                      child: Icon(
                        Icons.fastfood,
                        size: 60,
                        color: isDarkMode ? AppColors.gray500 : AppColors.gray400,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                  ),
                ),
              ),
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

  SliverToBoxAdapter _buildFeaturedHeader(bool isDarkMode) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Text(
              'Featured Restaurants',
              style: TextStyles.headlineSmall.copyWith(
                color: isDarkMode ? AppColors.textDark : AppColors.textPrimary,
              ),
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

  SliverToBoxAdapter _buildFeaturedRestaurants(bool isDarkMode) {
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
                color: isDarkMode ? AppColors.gray700 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
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
                        color: isDarkMode ? AppColors.gray600 : AppColors.gray200,
                        child: Icon(Icons.restaurant,
                            color: isDarkMode ? AppColors.gray400 : AppColors.gray400),
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
                            style: TextStyles.titleSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? AppColors.textDark : AppColors.textPrimary,
                            ),
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
                                style: TextStyles.bodySmall.copyWith(
                                  color: isDarkMode ? AppColors.textDark : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '30-45 min • Free delivery',
                            style: TextStyles.bodySmall.copyWith(
                              color: isDarkMode ? AppColors.gray400 : AppColors.textSecondary,
                            ),
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

  SliverToBoxAdapter _buildPopularItemsHeader(int productCount, bool isDarkMode) {
    final selectedCategory = categories[_selectedCategoryIndex]['name'] as String;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Text(
              selectedCategory == 'All' ? 'Popular Items' : '$selectedCategory Items',
              style: TextStyles.headlineSmall.copyWith(
                color: isDarkMode ? AppColors.textDark : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Text(
              '$productCount items',
              style: TextStyles.bodyMedium.copyWith(
                color: isDarkMode ? AppColors.gray400 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverGrid _buildProductsGrid(List<Product> filteredProducts, ProductState state, bool isDarkMode) {
    if (filteredProducts.isEmpty) {
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        delegate: SliverChildBuilderDelegate((context, index) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 60,
                    color: isDarkMode ? AppColors.gray500 : AppColors.gray300),
                const SizedBox(height: 16),
                Text(
                  'No items found',
                  style: TextStyles.bodyLarge.copyWith(
                    color: isDarkMode ? AppColors.textDark : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try a different category or search term',
                  style: TextStyles.bodyMedium.copyWith(
                    color: isDarkMode ? AppColors.gray400 : AppColors.textTertiary,
                  ),
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
        childAspectRatio: 0.55,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final product = filteredProducts[index];
        return Padding(
          padding: EdgeInsets.only(
            left: index % 2 == 0 ? 16.0 : 0.0,
            right: index % 2 != 0 ? 16.0 : 0.0,
          ),
          child: FoodItemCard(
            product: product,
            ref: ref,
            productState: state,
            isDarkMode: isDarkMode,
          ),
        );
      }, childCount: filteredProducts.length),
    );
  }
}


class FoodItemCard extends StatelessWidget {
  final Product product;
  final WidgetRef ref;
  final ProductState productState;
  final bool isDarkMode;

  const FoodItemCard({
    super.key,
    required this.product,
    required this.ref,
    required this.productState,
    required this.isDarkMode,
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
          color: isDarkMode ? AppColors.gray700 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
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
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    color: isDarkMode ? AppColors.gray600 : AppColors.gray100,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      product.images[0],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.fastfood,
                          color: isDarkMode ? AppColors.gray400 : AppColors.gray400,
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
                        color: isDarkMode ? AppColors.gray700 : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
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
                            : isDarkMode ? AppColors.gray300 : AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Food Details with fixed height container
            Container(
              height: 180,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with fixed height
                  SizedBox(
                    height: 40,
                    child: Text(
                      product.title,
                      style: TextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        color: isDarkMode ? AppColors.textDark : AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Category
                  Text(
                    product.category.replaceAll('-', ' ').toUpperCase(),
                    style: TextStyles.labelSmall.copyWith(
                      color: AppColors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

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
                            style: TextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? AppColors.textDark : AppColors.textPrimary,
                            ),
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
                                color: isDarkMode ? AppColors.gray400 : AppColors.textTertiary,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(productProvider.notifier).addToCart(product, 1);
                        Utils.toastMessage("added successfully",type: ToastType.success);
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