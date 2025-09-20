import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Core/Routes/routes_name.dart';
import '../Core/Theme/app_colors.dart';
import '../Core/Theme/text_styles.dart';
import '../Repository/auth_user_repository.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    getPrefs();

    // Animation setup
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();

    // Navigation logic after splash delay
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 3));

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        Navigator.pushNamed(context, RoutesName.preHome);
      } else {
        Navigator.pushNamed(context, RoutesName.login);
      }
    });
  }

  void getPrefs() async {
    final prefs = await AuthUserRepository.create();
    debugPrint("Token : ${prefs.getToken()}");
    debugPrint("User Name : ${prefs.getUserName()}");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // Animated background elements - Food themed
          Positioned(
            top: -18,
            right: -MediaQuery.of(context).size.width * 0.1,
            child: _AnimatedCircleShape(
              size: MediaQuery.of(context).size.width * 0.5,
              color1: const Color(0xFFFFF0E6),
              color2: const Color(0xFFFFD8C9),
              controller: _controller,
              delay: 0.0,
            ),
          ),
          Positioned(
            bottom: -MediaQuery.of(context).size.width * 0.15,
            left: -MediaQuery.of(context).size.width * 0.1,
            child: _AnimatedCircleShape(
              size: MediaQuery.of(context).size.width * 0.4,
              color1: const Color(0xFFE8F5E9),
              color2: const Color(0xFFC8E6C9),
              controller: _controller,
              delay: 0.1,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: MediaQuery.of(context).size.width * 0.1,
            child: _AnimatedFoodShape(
              size: MediaQuery.of(context).size.width * 0.2,
              color1: const Color(0xFFFFF3E0),
              color2: const Color(0xFFFFE0B2),
              controller: _controller,
              delay: 0.2,
              icon: Icons.local_pizza,
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2,
            right: MediaQuery.of(context).size.width * 0.1,
            child: _AnimatedFoodShape(
              size: MediaQuery.of(context).size.width * 0.18,
              color1: const Color(0xFFFFE8E0),
              color2: const Color(0xFFFFCCBC),
              controller: _controller,
              delay: 0.3,
              icon: Icons.local_drink,
            ),
          ),

          // Main content
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Food-themed logo
                    _FoodLogoCluster(controller: _controller),
                    const SizedBox(height: 30),
                    Text(
                      'Foodie',
                      style: TextStyles.headlineLarge.copyWith(
                        color: AppColors.orange,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Delicious food at your doorstep',
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedCircleShape extends StatelessWidget {
  final double size;
  final Color color1;
  final Color color2;
  final AnimationController controller;
  final double delay;

  const _AnimatedCircleShape({
    required this.size,
    required this.color1,
    required this.color2,
    required this.controller,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final animationValue = controller.value;
        final scale = (animationValue - delay).clamp(0.0, 1.0);

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: scale,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [color1, color2],
                  center: Alignment.center,
                  radius: 0.8,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color2.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedFoodShape extends StatelessWidget {
  final double size;
  final Color color1;
  final Color color2;
  final AnimationController controller;
  final double delay;
  final IconData icon;

  const _AnimatedFoodShape({
    required this.size,
    required this.color1,
    required this.color2,
    required this.controller,
    required this.delay,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final animationValue = controller.value;
        final scale = (animationValue - delay).clamp(0.0, 1.0);

        return Transform.rotate(
          angle: 0.5 * scale,
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: scale,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color1, color2],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: color2.withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: AppColors.orange,
                  size: size * 0.4,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FoodLogoCluster extends StatefulWidget {
  final AnimationController controller;

  const _FoodLogoCluster({required this.controller});

  @override
  _FoodLogoClusterState createState() => _FoodLogoClusterState();
}

class _FoodLogoClusterState extends State<_FoodLogoCluster>
    with SingleTickerProviderStateMixin {
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late AnimationController _logoController;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 140,
              height: 140,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 25,
                    spreadRadius: 1,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    blurRadius: 15,
                    spreadRadius: 5,
                    offset: const Offset(0, -5),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    AppColors.gray50,
                  ],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Main food icon
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.orange.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.restaurant_menu_rounded,
                      size: 42,
                      color: AppColors.orange,
                    ),
                  ),

                  // Food category icons positioned around the main icon
                  _AnimatedFoodIcon(
                    controller: _logoController,
                    delay: 0.0,
                    top: 8,
                    right: 8,
                    icon: Icons.local_pizza,
                    color: Colors.deepOrange,
                  ),
                  _AnimatedFoodIcon(
                    controller: _logoController,
                    delay: 0.2,
                    bottom: 8,
                    left: 8,
                    icon: Icons.emoji_food_beverage,
                    color: Colors.brown,
                  ),
                  _AnimatedFoodIcon(
                    controller: _logoController,
                    delay: 0.4,
                    bottom: 8,
                    right: 8,
                    icon: Icons.cake,
                    color: Colors.pink,
                  ),
                  _AnimatedFoodIcon(
                    controller: _logoController,
                    delay: 0.6,
                    top: 8,
                    left: 8,
                    icon: Icons.local_dining,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedFoodIcon extends StatelessWidget {
  final AnimationController controller;
  final double delay;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final IconData icon;
  final Color color;

  const _AnimatedFoodIcon({
    required this.controller,
    required this.delay,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(delay, 1.0, curve: Curves.easeInOut),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Positioned(
          top: top,
          bottom: bottom,
          left: left,
          right: right,
          child: Transform.translate(
            offset: Offset(0, 2 * animation.value * math.sin(controller.value * 2 * math.pi)),
            child: Transform.scale(
              scale: 0.8 + 0.2 * animation.value,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: color,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}