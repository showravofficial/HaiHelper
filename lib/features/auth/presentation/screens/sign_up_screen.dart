import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final passwordVisibilityProvider = StateProvider<bool>((ref) => false);
final confirmPasswordVisibilityProvider = StateProvider<bool>((ref) => false);
final passwordProvider = StateProvider<String>((ref) => '');
final confirmPasswordProvider = StateProvider<String>((ref) => '');
final passwordMatchProvider = StateProvider<bool>((ref) => true);

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPasswordVisible = ref.watch(passwordVisibilityProvider);
    final isConfirmPasswordVisible = ref.watch(confirmPasswordVisibilityProvider);
    final passwordMatch = ref.watch(passwordMatchProvider);

    // Function to check if passwords match
    void checkPasswords(String password, String confirmPassword) {
      if (password.isNotEmpty && confirmPassword.isNotEmpty) {
        ref.read(passwordMatchProvider.notifier).state = password == confirmPassword;
      }
    }

    return Scaffold(
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
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black54),
                      onPressed: () => context.go('/auth'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Hai title
                  const Text(
                    'Hai',
                    style: TextStyle(
                      color: Color(0xFF7B6EF6),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Create account text
                  const Text(
                    'Create account',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),

                  const SizedBox(height: 24),

                  // Form fields
                  buildTextField(
                    hintText: 'Username',
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 16),

                  buildTextField(
                    hintText: 'E-mail',
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 16),

                  buildTextField(
                    hintText: 'Mobile',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 16),

                  // Password field
                  buildTextField(
                    hintText: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: !isPasswordVisible,
                    onChanged: (value) {
                      ref.read(passwordProvider.notifier).state = value;
                      checkPasswords(
                        value,
                        ref.read(confirmPasswordProvider),
                      );
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        ref.read(passwordVisibilityProvider.notifier).state =
                            !isPasswordVisible;
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Confirm Password field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextField(
                        hintText: 'Confirm Password',
                        icon: Icons.lock_outline,
                        obscureText: !isConfirmPasswordVisible,
                        onChanged: (value) {
                          ref.read(confirmPasswordProvider.notifier).state = value;
                          checkPasswords(
                            ref.read(passwordProvider),
                            value,
                          );
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            isConfirmPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            ref.read(confirmPasswordVisibilityProvider.notifier).state =
                                !isConfirmPasswordVisible;
                          },
                        ),
                      ),
                      if (!passwordMatch && ref.read(confirmPasswordProvider).isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                          child: Text(
                            'Passwords do not match',
                            style: TextStyle(
                              color: Colors.red[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Sign Up button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: passwordMatch ? () {
                        context.go('/budget-information');
                      } : null, // Disable button if passwords don't match
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B6EF6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Social login buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Image.asset(AppAssets.google),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    void Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 25,
            spreadRadius: -5,
            offset: Offset(0, 20),
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 10,
            spreadRadius: -5,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: TextFormField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(
            icon,
            color: Colors.grey,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}