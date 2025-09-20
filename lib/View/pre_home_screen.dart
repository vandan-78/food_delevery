import 'package:flutter/material.dart';
import 'package:mvvm_folder_strucutre/Core/Theme/app_colors.dart';
import 'package:mvvm_folder_strucutre/Core/Theme/text_styles.dart';
import 'package:mvvm_folder_strucutre/View/Home_screen.dart';
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
    if (widget.screenNo == 1) {
      selectedIndex = 1;
    } else if (widget.screenNo == 2) {
      selectedIndex = 2;
    } else if (widget.screenNo == 3) {
      selectedIndex = 3;
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
      backgroundColor: AppColors.backgroundLight,
      body: screens[selectedIndex],
      bottomNavigationBar: _buildCustomBottomNavBar(),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
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
          _buildNavItem(0, Icons.home_rounded, "Home"),
          _buildNavItem(1, Icons.favorite_rounded, "Favorite"),
          _buildNavItem(2, Icons.shopping_cart_rounded, "Cart"),
          _buildNavItem(3, Icons.person_rounded, "Profile"),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orange.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? AppColors.orange : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyles.labelSmall.copyWith(
                color: isSelected ? AppColors.orange : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}