import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'text_styles.dart';

class AppTheme{
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.orange,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: AppBarTheme(
          backgroundColor: AppColors.orange,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyles.titleLarge.copyWith(color: Colors.white)
      ),
      textTheme: TextTheme(
        displayLarge: TextStyles.displayLarge,
        displayMedium: TextStyles.displayMedium,
        displaySmall: TextStyles.displaySmall,
        headlineLarge: TextStyles.headlineLarge,
        headlineMedium: TextStyles.headlineMedium,
        headlineSmall: TextStyles.headlineSmall,
        titleLarge: TextStyles.titleLarge,
        titleMedium: TextStyles.titleMedium,
        titleSmall: TextStyles.titleSmall,
        bodyLarge: TextStyles.bodyLarge,
        bodyMedium: TextStyles.bodyMedium,
        bodySmall: TextStyles.bodySmall,
        labelLarge: TextStyles.labelLarge,
        labelMedium: TextStyles.labelMedium,
        labelSmall: TextStyles.labelSmall,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.gray50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.orange),
        ),
        labelStyle: TextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyles.buttonLarge.copyWith(
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      )
  );

  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyles.titleLarge.copyWith(color: Colors.white)
      ),
      textTheme: TextTheme(
        displayLarge: TextStyles.displayLarge.copyWith(color: AppColors.textDark),
        displayMedium: TextStyles.displayMedium.copyWith(color: AppColors.textDark),
        displaySmall: TextStyles.displaySmall.copyWith(color: AppColors.textDark),
        headlineLarge: TextStyles.headlineLarge.copyWith(color: AppColors.textDark),
        headlineMedium: TextStyles.headlineMedium.copyWith(color: AppColors.textDark),
        headlineSmall: TextStyles.headlineSmall.copyWith(color: AppColors.textDark),
        titleLarge: TextStyles.titleLarge.copyWith(color: AppColors.textDark),
        titleMedium: TextStyles.titleMedium.copyWith(color: AppColors.textDark),
        titleSmall: TextStyles.titleSmall.copyWith(color: AppColors.textDark),
        bodyLarge: TextStyles.bodyLarge.copyWith(color: AppColors.textDark),
        bodyMedium: TextStyles.bodyMedium.copyWith(color: AppColors.textDark),
        bodySmall: TextStyles.bodySmall.copyWith(color: AppColors.textDark),
        labelLarge: TextStyles.labelLarge.copyWith(color: AppColors.textDark),
        labelMedium: TextStyles.labelMedium.copyWith(color: AppColors.textDark),
        labelSmall: TextStyles.labelSmall.copyWith(color: AppColors.textDark),
      )
  );
}