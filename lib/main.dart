import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants/app_colors.dart';
import 'features/auth/presentation/auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase if credentials are provided in env or project setup
  // Supabase.initialize(url: 'YOUR_URL', anonKey: 'YOUR_KEY');

  runApp(const SintaksApp());
}

class SintaksApp extends StatelessWidget {
  const SintaksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sintaks',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.dark(
          surface: AppColors.background,
          primary: AppColors.electricCyan,
          secondary: AppColors.neonViolet,
          tertiary: AppColors.emerald,
          error: AppColors.roseError,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: const AuthPage(),
    );
  }
}
