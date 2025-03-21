import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slide_to_act/slide_to_act.dart';
import '../../../../core/constants/app_assets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              AppAssets.onboarding,
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.black.withOpacity(0.1),
                  //     shape: BoxShape.circle,
                  //   ),
                  //   child: IconButton(
                  //     icon: const Icon(
                  //       Icons.arrow_back,
                  //       color: Colors.white,
                  //     ),
                  //     onPressed: () => Navigator.pop(context),
                  //   ),
                  // ),
                  const Spacer(),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Empower with ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: 'Hai Helper',
                          style: TextStyle(
                            color: Color(0xFF7B6EF6),
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'An online companion to help navigate\nthe NDIS landscape!',
                    style: TextStyle(
                      color: Color(0xff959595),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SlideAction(
                    text: "Let's start",
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    innerColor: const Color(0xff7872FF),
                    outerColor: Colors.black.withOpacity(0.3),
                    sliderButtonIcon: const Row(
                      children: [
                        Icon(Icons.arrow_forward_ios, color: Colors.white),
                        Icon(Icons.arrow_forward_ios, color: Colors.white),
                        Icon(Icons.arrow_forward_ios, color: Colors.white),
                      ],
                    ),
                    borderRadius: 12,
                    elevation: 0,
                    height: 56,
                    sliderRotate: false,
                    onSubmit: () {
                      context.go('/auth');
                      return null;
                    },
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