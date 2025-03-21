import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_assets.dart';

// Provider for selected button state
final selectedButtonProvider = StateProvider<String>((ref) => 'login');

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedButton = ref.watch(selectedButtonProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              AppAssets.onboarding2,
              fit: BoxFit.cover,
            ),
          ),
          // Dark Overlay
          // Positioned.fill(
          //   child: Container(
          //     color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
          //   ),
          // ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Spacer(),
                  const Text(
                    'Hai Helper',
                    style: TextStyle(
                      color: Color(0xff7872FF),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign up and try the Assistant Interface',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(50, 50, 93, 0.25),
                          blurRadius: 100,
                          spreadRadius: -20,
                          offset: Offset(0, 50),
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          blurRadius: 60,
                          spreadRadius: -30,
                          offset: Offset(0, 30),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(selectedButtonProvider.notifier).state = 'login';
                          context.go('/signin');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedButton == 'login' 
                              ? const Color(0xff7872FF) 
                              : Colors.white,
                          foregroundColor: selectedButton == 'login' 
                              ? Colors.white 
                              : const Color(0xff7872FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Color(0xff7872FF)),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(50, 50, 93, 0.25),
                          blurRadius: 100,
                          spreadRadius: -20,
                          offset: Offset(0, 50),
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          blurRadius: 60,
                          spreadRadius: -30,
                          offset: Offset(0, 30),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(selectedButtonProvider.notifier).state = 'register';
                          context.go('/signup');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedButton == 'register' 
                              ? const Color(0xff7872FF) 
                              : Colors.white,
                          foregroundColor: selectedButton == 'register' 
                              ? Colors.white 
                              : const Color(0xff7872FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Color(0xff7872FF)),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 