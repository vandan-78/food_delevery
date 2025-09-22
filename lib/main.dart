    import 'package:firebase_core/firebase_core.dart';
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'package:mvvm_folder_strucutre/Core/Theme/app_theme.dart';
    import 'Core/Routes/routes.dart';
    import 'Core/Routes/routes_name.dart';
    import 'Repository/auth_user_repository.dart';
    import 'View-Model/theme_view_model.dart';
    import 'firebase_options.dart';

    late final AuthUserRepository authPrefs;

    Future<void> main() async {
      WidgetsFlutterBinding.ensureInitialized();

      // 🔥 Initialize Firebase with FlutterFire CLI options
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      authPrefs = await AuthUserRepository.create();


      runApp(const ProviderScope(child: MyApp()));
    }


    class MyApp extends ConsumerWidget {
      const MyApp({super.key});

      // This widget is the root of your application.
      @override
      Widget build(BuildContext context,WidgetRef ref) {
        final themeMode = ref.watch(themeProvider); // this is bool
        final isFirstTime = authPrefs.isFirstTimeOpen();



        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          initialRoute:isFirstTime?  RoutesName.onboarding : RoutesName.splash,
          onGenerateRoute: Routes.generateRoute,
        );
      }
    }

