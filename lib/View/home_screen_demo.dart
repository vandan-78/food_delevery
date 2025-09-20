// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mvvm_folder_strucutre/Core/Routes/routes_name.dart';
// import 'package:mvvm_folder_strucutre/Core/Theme/text_styles.dart';
// import 'package:mvvm_folder_strucutre/View-Model/auth_user_view_model.dart';
// import 'package:mvvm_folder_strucutre/View-Model/auth_view_model.dart';
// import '../View-Model/theme_view_model.dart';
// import '../View-Model/user_view_model.dart';
//
//
//
// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//
//     // fetch users once
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(userProvider.notifier).fetchUsers();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeMode = ref.watch(themeProvider);
//     final user = ref.watch(userProvider);
//     final theme = Theme.of(context);
//
//     // 👇 Move ref.listen here (correct place)
//     ref.listen<String?>(authUserProvider, (prev, token) {
//       if (token == null || token.isEmpty) {
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           RoutesName.login,
//               (route) => false,
//         );
//       }
//     });
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("User Directory"),
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             icon: Icon(themeMode == ThemeMode.light
//                 ? Icons.light_mode
//                 : Icons.dark_mode),
//             onPressed: () {
//               ref.read(themeProvider.notifier).toggleTheme();
//             },
//             tooltip: 'Toggle Theme',
//           ),
//           IconButton(
//             icon: const Icon(Icons.logout_outlined),
//             tooltip: 'Log Out',
//             onPressed: () {
//               ref.read(loginProvider.notifier).logout();
//             },
//           ),
//         ],
//       ),
//       body: user.isLoading
//           ? Center(
//         child: CircularProgressIndicator(
//           strokeWidth: 2,
//           valueColor:
//           AlwaysStoppedAnimation(Theme.of(context).primaryColor),
//         ),
//       )
//           : user.error != null
//           ? Center(child: Text(user.error ?? "Unknown error"))
//           : SafeArea(
//         child: ListView.builder(
//           itemCount: user.users.length,
//           itemBuilder: (context, index) {
//             final singleData = user.users[index];
//             return GestureDetector(
//               onTap: () {
//                 Navigator.pushNamed(context, RoutesName.userDetail,arguments: singleData);
//               },
//               child: ListTile(
//                 leading: CircleAvatar(
//                   backgroundImage: NetworkImage(singleData.image),
//                 ),
//                 title: Text("${singleData.username} ${singleData.lastName}"),
//               ),
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => ref.read(userProvider.notifier).fetchUsers(),
//         tooltip: 'Refresh Users',
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }
// }
