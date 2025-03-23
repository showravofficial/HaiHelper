import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haihelper/features/splash/presentation/screens/splash_screen.dart';
import 'package:haihelper/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:haihelper/features/auth/presentation/screens/auth_screen.dart';
import 'package:haihelper/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:haihelper/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:haihelper/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:haihelper/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:haihelper/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:haihelper/features/auth/presentation/screens/password_success_screen.dart';
import 'package:haihelper/features/user/presentation/screens/budget_category_screen.dart';
import 'package:haihelper/features/user/presentation/screens/budget_information_screen.dart';
import 'package:haihelper/features/settings/presentation/screens/budget.dart';
import 'package:haihelper/features/chat/presentation/screens/chat_screen.dart';
import 'package:haihelper/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:haihelper/features/settings/presentation/screens/settings_screen.dart';
import 'package:haihelper/features/settings/presentation/screens/manage_subscription_screen.dart';
import 'package:haihelper/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:haihelper/features/settings/presentation/screens/terms_conditions_screen.dart';
import 'package:haihelper/features/settings/presentation/screens/help_support_screen.dart';
import 'package:haihelper/features/settings/presentation/screens/about_us_screen.dart';
import 'package:haihelper/features/settings/presentation/screens/subscription_screen.dart';
import 'package:haihelper/features/history/presentation/screens/history_screen.dart';
import 'package:haihelper/core/screens/main_screen.dart';

import '../../features/settings/presentation/screens/selected_budget_screen.dart';
import '../../features/user/presentation/screens/budget_end_date_screen.dart';
import '../../features/user/presentation/screens/budget_start_date_screen.dart';


final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/manage-subscription',
      builder: (context, state) => const ManageSubscriptionScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/signin',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/forget-password',
      builder: (context, state) => const ForgetPasswordScreen(),
    ),
    GoRoute(
      path: '/email-verification',
      builder: (context, state) => const EmailVerificationScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/password-success',
      builder: (context, state) => const PasswordSuccessScreen(),
    ),
    GoRoute(
      path: '/privacy-policy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: '/terms-conditions',
      builder: (context, state) => const TermsConditionsScreen(),
    ),
    GoRoute(
      path: '/help-support',
      builder: (context, state) => const HelpSupportScreen(),
    ),
    GoRoute(
      path: '/selected-budget-screen',
      builder: (context, state) => const SelectedBudgetScreen(),
    ),
    GoRoute(
      path: '/about-us',
      builder: (context, state) => const AboutUsScreen(),
    ),
    GoRoute(
      path: '/budget-category',
      builder: (context, state) => const BudgetCategoryScreen(),
    ),
    GoRoute(
      path: '/budget-start-date',
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>;
        return BudgetStartDateScreen(
          selectedCategory: params['category'] as String,
          budget: params['budget'] as double,
        );
      },
    ),
    GoRoute(
      path: '/budget-end-date',
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>;
        return BudgetEndDateScreen(
          selectedCategory: params['category'] as String,
          budget: params['budget'] as double,
          startDate: params['startDate'] as DateTime,
        );
      },
    ),
    GoRoute(
      path: '/subscription',
      builder: (context, state) => const SubscriptionScreen(),
    ),
    GoRoute(
      path: '/budget-information',
      builder: (context, state) => const BudgetInformationScreen(),
    ),
    GoRoute(
      path: '/settings/budget',
      builder: (context, state) => const BudgetScreen(),
    ),
  ],
);

// Route names as constants for type-safe navigation
class AppRoutes {
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  
  // Add more route names as needed
} 