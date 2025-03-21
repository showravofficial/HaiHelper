import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';

// Providers for password visibility and text
final passwordVisibilityProvider = StateProvider<bool>((ref) => false);
final confirmPasswordVisibilityProvider = StateProvider<bool>((ref) => false);
final passwordProvider = StateProvider<String>((ref) => '');
final confirmPasswordProvider = StateProvider<String>((ref) => '');
final passwordErrorProvider = StateProvider<String?>((ref) => null);
final confirmPasswordErrorProvider = StateProvider<String?>((ref) => null);

class ResetPasswordScreen extends ConsumerWidget {
  const ResetPasswordScreen({super.key});

  void validatePasswords(WidgetRef ref) {
    final password = ref.read(passwordProvider);
    final confirmPassword = ref.read(confirmPasswordProvider);
    
    // Reset error messages
    ref.read(passwordErrorProvider.notifier).state = null;
    ref.read(confirmPasswordErrorProvider.notifier).state = null;

    if (password.isEmpty) {
      ref.read(passwordErrorProvider.notifier).state = 'Password is required';
      return;
    }

    if (confirmPassword.isEmpty) {
      ref.read(confirmPasswordErrorProvider.notifier).state = 'Confirm password is required';
      return;
    }

    if (password != confirmPassword) {
      ref.read(confirmPasswordErrorProvider.notifier).state = 'Passwords do not match';
      return;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPasswordVisible = ref.watch(passwordVisibilityProvider);
    final isConfirmPasswordVisible = ref.watch(confirmPasswordVisibilityProvider);
    final passwordError = ref.watch(passwordErrorProvider);
    final confirmPasswordError = ref.watch(confirmPasswordErrorProvider);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.screen_bg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 
                          MediaQuery.of(context).padding.top - 
                          MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back button aligned to left
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black54),
                          onPressed: () => context.pop(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Hai text in purple
                    const Text(
                      'Hai',
                      style: TextStyle(
                        color: Color(0xFF7B6EF6),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Reset Password text
                    const Text(
                      'Reset Password',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Generated New Password text in purple
                    const Text(
                      'Generated New Password',
                      style: TextStyle(
                        color: Color(0xFF7B6EF6),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle text
                    const Text(
                      'Enter your new password here and\nmake it different from previous',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Password fields with adjusted spacing
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            obscureText: !isPasswordVisible,
                            onChanged: (value) {
                              ref.read(passwordProvider.notifier).state = value;
                              validatePasswords(ref);
                            },
                            decoration: InputDecoration(
                              hintText: 'New Password',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  ref.read(passwordVisibilityProvider.notifier).state = !isPasswordVisible;
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              errorText: passwordError,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Confirm Password field
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            obscureText: !isConfirmPasswordVisible,
                            onChanged: (value) {
                              ref.read(confirmPasswordProvider.notifier).state = value;
                              validatePasswords(ref);
                            },
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  ref.read(confirmPasswordVisibilityProvider.notifier).state = !isConfirmPasswordVisible;
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              errorText: confirmPasswordError,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.020),

                    // Reset button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          validatePasswords(ref);
                          final hasError = ref.read(passwordErrorProvider) != null || 
                                          ref.read(confirmPasswordErrorProvider) != null;
                          if (!hasError) {
                            // Handle successful password reset
                            context.push('/signin');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7B6EF6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16), // Add bottom padding
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 