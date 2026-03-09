import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'config/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/signup_screen.dart';
import 'presentation/screens/auth/forgot_password_screen.dart';
import 'presentation/screens/auth/agent_signup_screen.dart';
import 'presentation/screens/auth/agent_review_status_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/property/property_listing_screen.dart';
import 'presentation/screens/property/property_detail_screen.dart';
import 'presentation/screens/favorites/favorites_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';
import 'presentation/screens/admin/admin_dashboard_screen.dart';
import 'presentation/screens/admin/agent_applications_screen.dart';
import 'presentation/screens/settings/about_screen.dart';
import 'presentation/screens/settings/notifications_screen.dart';
import 'presentation/screens/settings/help_support_screen.dart';
import 'presentation/screens/settings/privacy_policy_screen.dart';
import 'data/models/property_model.dart';
import 'data/providers/favorites_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://nzxjosqmpslefqiagvbh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im56eGpvc3FtcHNsZWZxaWFndmJoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMwMzQ3NjYsImV4cCI6MjA4ODYxMDc2Nn0.9DmunTOV7FrRi2X6JTfwZY6hzBq8HYmZU-0nVdGQS1I',
  );

  // Initialize Firebase with explicit platform options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    debugPrint('App will continue without Firebase services.');
  }
  
  // Set status bar to transparent (skip on web)
  if (!kIsWeb) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }
  
  // Initialize providers
  final favoritesProvider = FavoritesProvider();
  await favoritesProvider.loadFavorites();
  
  final themeProvider = ThemeProvider();
  
  runApp(MyApp(
    favoritesProvider: favoritesProvider,
    themeProvider: themeProvider,
  ));
}

class MyApp extends StatelessWidget {
  final FavoritesProvider favoritesProvider;
  final ThemeProvider themeProvider;
  
  const MyApp({
    Key? key,
    required this.favoritesProvider,
    required this.themeProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: favoritesProvider),
        ChangeNotifierProvider.value(value: themeProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Nestify - Real Estate App',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            initialRoute: '/',
            onGenerateRoute: (settings) {
              // Handle routes with arguments
              if (settings.name == '/property-detail') {
                final property = settings.arguments;
                return MaterialPageRoute(
                  builder: (context) => PropertyDetailScreen(
                    property: property as PropertyModel,
                  ),
                );
              }
              
              // Default routes
              return null;
            },
            routes: {
              '/': (context) => const SplashScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignupScreen(),
              '/agent-signup': (context) => const AgentSignupScreen(),
              '/agent-review-status': (context) => const AgentReviewStatusScreen(),
              '/forgot-password': (context) => const ForgotPasswordScreen(),
              '/home': (context) => const HomeScreen(),
              '/property-listing': (context) => const PropertyListingScreen(),
              '/favorites': (context) => const FavoritesScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/admin-dashboard': (context) => const AdminDashboardScreen(),
              '/agent-applications': (context) => const AgentApplicationsScreen(),
              '/about': (context) => const AboutScreen(),
              '/notifications': (context) => const NotificationsScreen(),
              '/help-support': (context) => const HelpSupportScreen(),
              '/privacy-policy': (context) => const PrivacyPolicyScreen(),
            },
          );
        },
      ),
    );
  }
}
