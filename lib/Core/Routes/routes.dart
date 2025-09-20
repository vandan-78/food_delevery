import 'package:flutter/material.dart';
import 'package:mvvm_folder_strucutre/Core/Routes/routes_name.dart';
import 'package:mvvm_folder_strucutre/View/cart_screen.dart';
import 'package:mvvm_folder_strucutre/View/favorite_screen.dart';
import 'package:mvvm_folder_strucutre/View/forgot_password_screen.dart';
import 'package:mvvm_folder_strucutre/View/login_screen.dart';
import 'package:mvvm_folder_strucutre/View/pre_home_screen.dart';
import 'package:mvvm_folder_strucutre/View/profile_screen.dart';
import 'package:mvvm_folder_strucutre/View/splash_screen.dart';
import 'package:mvvm_folder_strucutre/View/text_style_demo.dart';
import 'package:mvvm_folder_strucutre/View/user_screen.dart';
import '../../Model/auth_model.dart';
import '../../Model/user_response_model.dart';
import '../../View/about_screen.dart';
import '../../View/help_support_screen.dart';
import '../../View/on_boarding_screen.dart';
import '../../View/privacy_policy_screen.dart';
import '../../View/signup_screen.dart';
import '../../View/terms_of_sevice.dart';
import '../../View/user_detai_screen.dart';

class Routes {
  static MaterialPageRoute generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.preHome:
        final args = settings.arguments as int?;
        return MaterialPageRoute(builder: (context) => PreHomeScreen(screenNo: args));
      case RoutesName.cartScreen:
        return MaterialPageRoute(builder: (context) => CartScreen());
      case RoutesName.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case RoutesName.about:
        return MaterialPageRoute(builder: (_) => const AboutScreen());
      case RoutesName.helpSupport:
        return MaterialPageRoute(builder: (_) => const HelpSupportScreen());
      case RoutesName.login:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case RoutesName.forgotPassword:
        return MaterialPageRoute(builder: (context) => ForgotPasswordScreen());
      case RoutesName.profile:
        return MaterialPageRoute(builder: (context) => ProfileScreen());
      case RoutesName.privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
      case RoutesName.termsOfService:
        return MaterialPageRoute(builder: (_) => const TermsOfServiceScreen());
      case RoutesName.splash:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case RoutesName.userDetail:
        final args = settings.arguments as User;
        return MaterialPageRoute(builder: (context) => UserDetailScreen(userModel: args));
      case RoutesName.favoriteScreen:
        return MaterialPageRoute(builder: (context) => FavoriteScreen());
      case RoutesName.user:
        final args = settings.arguments as UserModel; // receive UserModel
        return MaterialPageRoute(builder: (context) => UserScreen(user: args));
      case RoutesName.signUp:
        return MaterialPageRoute(builder: (context) => SignupScreen());
      case RoutesName.textStyleDemo:
        return MaterialPageRoute(builder: (context) => TextStylesDemoScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(body: Center(child: Text("Default Screen"))),
        );
    }
  }
}
