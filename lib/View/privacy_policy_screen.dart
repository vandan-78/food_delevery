import 'package:flutter/material.dart';
import 'package:mvvm_folder_strucutre/Core/Theme/app_colors.dart';
import 'package:mvvm_folder_strucutre/Core/Theme/text_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text('Privacy Policy', style: TextStyles.headlineMedium.copyWith(fontSize: 24)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: January 1, 2024',
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Privacy Policy',
              style: TextStyles.headlineSmall.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Your privacy is important to us. This Privacy Policy explains how FoodDeliver App collects, uses, discloses, and safeguards your information when you use our mobile application.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '1. Information We Collect',
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We may collect information about you in a variety of ways. The information we may collect via the Application includes:',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              '• Personal Data: Personally identifiable information, such as your name, shipping address, email address, and telephone number, that you voluntarily give to us when you register with the Application or when you choose to participate in various activities related to the Application.',
              style: TextStyles.bodyMedium,
            ),
            Text(
              '• Derivative Data: Information our servers automatically collect when you access the Application, such as your IP address, device type, browser type, operating system, access times, and the pages you have viewed directly before and after accessing the Application.',
              style: TextStyles.bodyMedium,
            ),
            Text(
              '• Financial Data: Financial information, such as data related to your payment method that we may collect when you purchase, order, return, exchange, or request information about our services from the Application.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '2. Use of Your Information',
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Having accurate information about you permits us to provide you with a smooth, efficient, and customized experience. Specifically, we may use information collected about you via the Application to:',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              '• Create and manage your account.',
              style: TextStyles.bodyMedium,
            ),
            Text(
              '• Process your transactions and send you related information, including purchase confirmations and invoices.',
              style: TextStyles.bodyMedium,
            ),
            Text(
              '• Email you regarding your account or order.',
              style: TextStyles.bodyMedium,
            ),
            Text(
              '• Enable user-to-user communications.',
              style: TextStyles.bodyMedium,
            ),
            Text(
              '• Generate a personal profile about you to make future visits to the Application more personalized.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '3. Disclosure of Your Information',
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We may share information we have collected about you in certain situations. Your information may be disclosed as follows:',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              '• By Law or to Protect Rights: If we believe the release of information about you is necessary to respond to legal process, to investigate or remedy potential violations of our policies, or to protect the rights, property, and safety of others, we may share your information as permitted or required by any applicable law, rule, or regulation.',
              style: TextStyles.bodyMedium,
            ),
            Text(
              '• Business Transfers: We may share or transfer your information in connection with, or during negotiations of, any merger, sale of company assets, financing, or acquisition of all or a portion of our business to another company.',
              style: TextStyles.bodyMedium,
            ),
            Text(
              '• Third-Party Service Providers: We may share your information with third parties that perform services for us or on our behalf, including payment processing, data analysis, email delivery, hosting services, customer service, and marketing assistance.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '4. Security of Your Information',
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We use administrative, technical, and physical security measures to help protect your personal information. While we have taken reasonable steps to secure the personal information you provide to us, please be aware that despite our efforts, no security measures are perfect or impenetrable, and no method of data transmission can be guaranteed against any interception or other type of misuse.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '5. Policy for Children',
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We do not knowingly solicit information from or market to children under the age of 13. If you become aware of any data we have collected from children under age 13, please contact us using the contact information provided below.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '6. Contact Us',
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'If you have questions or comments about this Privacy Policy, please contact us at:',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'FoodDeliver App Support\nsupport@fooddeliverapp.com\n+1 (555) 123-4567',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}