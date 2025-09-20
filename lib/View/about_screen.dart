import 'package:flutter/material.dart';
import 'package:mvvm_folder_strucutre/Core/Theme/app_colors.dart';
import 'package:mvvm_folder_strucutre/Core/Theme/text_styles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About', style: TextStyles.headlineMedium),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.orange,
                child: Icon(
                  Icons.info_outline,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'About Our App',
              style: TextStyles.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              'This is a sample application demonstrating MVVM architecture with Riverpod state management.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Version',
              style: TextStyles.titleMedium,
            ),
            Text(
              '1.0.0',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Developed by',
              style: TextStyles.titleMedium,
            ),
            Text(
              'Dhrumil Bhut',
              style: TextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}