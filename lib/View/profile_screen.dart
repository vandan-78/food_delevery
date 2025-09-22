import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_folder_strucutre/Core/Routes/routes_name.dart';
import 'package:mvvm_folder_strucutre/Core/Theme/app_colors.dart';
import 'package:mvvm_folder_strucutre/Core/Theme/text_styles.dart';
import 'package:mvvm_folder_strucutre/Repository/auth_user_repository.dart';
import 'package:mvvm_folder_strucutre/View-Model/auth_view_model.dart';
import '../View-Model/theme_view_model.dart';

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 24,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
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
                      style: const TextStyle(
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
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userEmail ?? 'user@example.com',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Preferences Section
            _buildMenuSection('PREFERENCES', [
              _buildMenuItem(
                Icons.color_lens_outlined,
                'Dark Mode',
                null,
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (_) {
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
                  activeColor: AppColors.orange,
                  activeTrackColor: AppColors.orange.withOpacity(0.5),
                ),
              ),
            ]),

            const SizedBox(height: 20),

            // Support & About Section
            _buildMenuSection('SUPPORT & ABOUT', [
              _buildMenuItem(
                Icons.description_outlined,
                'Terms of Service',
                    () => Navigator.pushNamed(context, RoutesName.termsOfService),
              ),
              _buildMenuItem(
                Icons.privacy_tip_outlined,
                'Privacy Policy',
                    () => Navigator.pushNamed(context, RoutesName.privacyPolicy),
              ),
              _buildMenuItem(
                Icons.info_outline,
                'App Version',
                null,
                trailing: Text(
                  'V1.1.0 (Build 1)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.6),
                  ),
                ),
              ),
            ]),

            const SizedBox(height: 20),

            // Help & Support
            _buildMenuSection('', [
              _buildMenuItem(
                Icons.help_outline,
                'Help & Support',
                    () => Navigator.pushNamed(context, RoutesName.helpSupport),
              ),
            ]),

            const SizedBox(height: 30),

            // Developer Info
            Text(
              'Developed by Dhrumil Bhut',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.6),
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
              child: authState.isLoading
                  ? const CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              )
                  : Text(
                'Logout',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700
                ),
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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.1,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback? onTap,
      {Widget? trailing}) {
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
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: trailing ??
          Icon(Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context)
                  .colorScheme
                  .onBackground
                  .withOpacity(0.6)),
      onTap: onTap,
    );
  }
}
