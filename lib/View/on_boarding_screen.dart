import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Core/Routes/routes_name.dart';
import '../Core/Theme/app_colors.dart';
import '../Core/Theme/text_styles.dart';
import '../Repository/auth_user_repository.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _onboardingPages = [
    OnboardingPage(
      image: 'assets/images/splash1.jpeg',
      title: 'Delicious Food',
      description: 'Discover the best foods from over 1,000 restaurants and fast delivery to your doorstep',
    ),
    OnboardingPage(
      image: 'assets/images/splash2.jpg',
      title: 'Fast Delivery',
      description: 'Fast food delivery to your home, office wherever you are',
    ),
    OnboardingPage(
      image: 'assets/images/splash3.jpeg',
      title: 'Live Tracking',
      description: 'Real time tracking of your food on the app once you placed the order',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () async {
                  final authPrefs = await AuthUserRepository.create();
                  await authPrefs.setFirstTimeOpen(false); // ✅ Mark as seen

                  debugPrint("First time opened: ${authPrefs.isFirstTimeOpen()}");

                  Navigator.pushReplacementNamed(context, RoutesName.splash);
                },
                child: Text(
                  'Skip',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingPages.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (_, index) {
                  return OnboardingPageWidget(page: _onboardingPages[index]);
                },
              ),
            ),

            // Page indicator and Next button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  // Page indicator
                  Row(
                    children: List.generate(
                      _onboardingPages.length,
                          (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? AppColors.orange
                              : AppColors.gray300,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Next button
                  ElevatedButton(
                    onPressed: () async {
                      final authPrefs = await AuthUserRepository.create();
                      await authPrefs.setFirstTimeOpen(false); // ✅ Mark as seen
                      debugPrint("First time opened: ${authPrefs.isFirstTimeOpen()}");

                      if (_currentPage < _onboardingPages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, RoutesName.splash);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      _currentPage == _onboardingPages.length - 1 ? 'Get Started' : 'Next',
                      style: TextStyles.buttonMedium,
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

class OnboardingPage {
  final String image;
  final String title;
  final String description;

  OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(page.image),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Title
          Text(
            page.title,
            style: TextStyles.headlineMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            page.description,
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}