import 'package:flutter/material.dart';
import 'package:mvvm_folder_strucutre/Core/Theme/text_styles.dart';
import 'package:mvvm_folder_strucutre/View/home_screen.dart';
import 'package:mvvm_folder_strucutre/View/cart_screen.dart';
import 'package:mvvm_folder_strucutre/View/favorite_screen.dart';
import 'package:mvvm_folder_strucutre/View/profile_screen.dart';

class PreHomeScreen extends StatefulWidget {
  final int? screenNo;
  const PreHomeScreen({super.key, required this.screenNo});

  @override
  State<PreHomeScreen> createState() => _PreHomeScreenState();
}

class _PreHomeScreenState extends State<PreHomeScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.screenNo != null) {
      selectedIndex = widget.screenNo!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(),
      FavoriteScreen(),
      CartScreen(),
      ProfileScreen()
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: screens[selectedIndex],
      bottomNavigationBar: _buildCustomBottomNavBar(context),
    );
  }

  Widget _buildCustomBottomNavBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor, // Use theme background for nav bar
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, 0, Icons.home_rounded, "Home"),
          _buildNavItem(context, 1, Icons.favorite_rounded, "Favorite"),
          _buildNavItem(context, 2, Icons.shopping_cart_rounded, "Cart"),
          _buildNavItem(context, 3, Icons.person_rounded, "Profile"),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;
    final theme = Theme.of(context);

    final selectedColor = theme.primaryColor;
    final unselectedColor = theme.textTheme.labelSmall!.color!;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? selectedColor : unselectedColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyles.labelSmall.copyWith(
                color: isSelected ? selectedColor : unselectedColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
