import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_folder_strucutre/Core/Routes/routes_name.dart';
import 'package:mvvm_folder_strucutre/Core/Theme/app_colors.dart';
import 'package:mvvm_folder_strucutre/Core/Theme/text_styles.dart';
import 'package:mvvm_folder_strucutre/Repository/auth_user_repository.dart';
import 'package:mvvm_folder_strucutre/View-Model/auth_view_model.dart';


class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late AuthUserRepository prefs;
  String? userName;
  String? userEmail;
  String? initials;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    prefs = await AuthUserRepository.create();
    setState(() {
      userName = prefs.getUserName();
      userEmail = prefs.getUserEmail();
      initials = _getInitials(userName ?? '');
    });
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';

    List<String> nameParts = name.split(' ');
    if (nameParts.length == 1) {
      return nameParts[0][0].toUpperCase();
    } else {
      return '${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}'.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyles.headlineMedium.copyWith(
              fontSize: 24
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.orange,
                    child: Text(
                      initials ?? '?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName ?? 'User Name',
                          style: TextStyles.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userEmail ?? 'user@example.com',
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Support & About Section
            _buildMenuSection('SUPPORT & ABOUT', [
              _buildMenuItem(Icons.description_outlined, 'Terms of Service', () {
                Navigator.pushNamed(context, RoutesName.termsOfService);
              }),
              _buildMenuItem(Icons.privacy_tip_outlined, 'Privacy Policy', () {
                Navigator.pushNamed(context, RoutesName.privacyPolicy);
              }),
              _buildMenuItem(Icons.info_outline, 'App Version', null, trailing: Text(
                'V1.1.0 (Build 1)',
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              )),
            ]),

            const SizedBox(height: 20),

            // Help & Support
            _buildMenuSection('', [
              _buildMenuItem(Icons.help_outline, 'Help & Support', () {
                Navigator.pushNamed(context, RoutesName.helpSupport);
              }),
            ]),

            const SizedBox(height: 30),

            // Developer Info (small text at bottom)
            Text(
              'Developed by Dhrumil Bhut',
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 20),

            // Logout Button
            ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).signOut();
                Navigator.pushReplacementNamed(context, RoutesName.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: authState.isLoading ?
              CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              )
                  :
              Text(
                'Logout',
                style: TextStyles.buttonLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback? onTap, {Widget? trailing}) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.orange, size: 20),
      ),
      title: Text(title, style: TextStyles.bodyLarge),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}