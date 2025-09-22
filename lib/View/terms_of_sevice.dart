import 'package:flutter/material.dart';
import 'package:mvvm_folder_strucutre/Core/Theme/app_colors.dart';
import 'package:mvvm_folder_strucutre/Core/Theme/text_styles.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text('Terms of Service', style: TextStyles.headlineMedium.copyWith(fontSize: 24)),
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
              'Terms of Service',
              style: TextStyles.headlineSmall.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Please read these Terms of Service carefully before using the FoodDeliver App operated by us.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '1. Agreement to Terms',
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'By accessing or using our Service, you agree to be bound by these Terms. If you disagree with any part of the terms, then you may not access the Service.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '2. Accounts',
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'When you create an account with us, you must provide us with information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of your account on our Service.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'You are responsible for safeguarding the password that you use to access the Service and for any activities or actions under your password, whether your password is with our Service or a third-party service.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '3. Ordering and Payment',
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'When you place an order through our Service, you agree to provide accurate and complete information about yourself and your order. All orders are subject to availability and confirmation of the order price.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'We reserve the right to refuse or cancel your order at any time for certain reasons including but not limited to: product or service availability, errors in the description or price of the product or service, error in your order or other reasons.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '4. Delivery',
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Delivery times are estimates only and are not guaranteed. We are not responsible for any delays in delivery due to unforeseen circumstances or factors beyond our control.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'You are responsible for providing accurate delivery information. We are not liable for orders delivered to incorrect addresses provided by you.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '5. Cancellations and Refunds',
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You may cancel your order within 5 minutes of placing it without any charge. After this period, cancellation may not be possible if the restaurant has already started preparing your food.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Refunds will be processed according to our refund policy. If you receive incorrect, damaged, or unsatisfactory items, please contact our customer support within 24 hours of delivery.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '6. Intellectual Property',
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'The Service and its original content, features, and functionality are and will remain the exclusive property of FoodDeliver App and its licensors. The Service is protected by copyright, trademark, and other laws of both the United States and foreign countries.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '7. Links To Other Web Sites',
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Our Service may contain links to third-party web sites or services that are not owned or controlled by FoodDeliver App.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'FoodDeliver App has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third party web sites or services. You further acknowledge and agree that FoodDeliver App shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with use of or reliance on any such content, goods or services available on or through any such web sites or services.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '8. Termination',
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Upon termination, your right to use the Service will immediately cease. If you wish to terminate your account, you may simply discontinue using the Service.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '9. Limitation of Liability',
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'In no event shall FoodDeliver App, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from your access to or use of or inability to access or use the Service.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '10. Governing Law',
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'These Terms shall be governed and construed in accordance with the laws, without regard to its conflict of law provisions.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '11. Changes to Terms',
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material we will provide at least 30 days notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '12. Contact Us',
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'If you have any questions about these Terms, please contact us at:',
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