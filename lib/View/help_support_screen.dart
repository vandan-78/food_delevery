import 'package:flutter/material.dart';
import 'package:mvvm_folder_strucutre/Core/Theme/app_colors.dart';
import 'package:mvvm_folder_strucutre/Core/Theme/text_styles.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text('Help & Support', style: TextStyles.headlineMedium.copyWith(fontSize: 24)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.help_outline,
                  size: 40,
                  color: AppColors.orange,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Frequently Asked Questions',
              style: TextStyles.headlineSmall.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 10),
            _buildFAQItem('How do I reset my password?', 'You can reset your password from the login screen by clicking on "Forgot Password".'),
            _buildFAQItem('How do I update my profile?', 'Go to the Profile screen and tap on "Personal Information" to update your details.'),
            _buildFAQItem('Who developed this app?', 'This app was developed by Dhrumil Bhut.'),
            const SizedBox(height: 20),
            Text(
              'Contact Support',
              style: TextStyles.headlineSmall.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: support@example.com',
              style: TextStyles.bodyMedium,
            ),
            Text(
              'Phone: +1 (555) 123-4567',
              style: TextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: TextStyles.bodyLarge),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(answer, style: TextStyles.bodyMedium),
        ),
      ],
    );
  }
}