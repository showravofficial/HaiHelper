import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B6EF6).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF7B6EF6),
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Terms & Condition',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF7B6EF6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // For alignment
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSection(
                    title: 'Acceptance of Terms',
                    content: 'By accessing and using Hai Helper, you accept and agree to be bound by the terms and conditions of this agreement.',
                  ),
                  _buildSection(
                    title: 'User Registration',
                    content: 'You must register for an account to access certain features. You agree to provide accurate information and maintain its accuracy.',
                  ),
                  _buildSection(
                    title: 'Subscription Terms',
                    content: '''
• Subscription fees are billed in advance
• Auto-renewal is enabled by default
• Cancellations take effect at the end of the current billing period
• No refunds for partial subscription periods''',
                  ),
                  _buildSection(
                    title: 'User Responsibilities',
                    content: '''
• Maintain confidentiality of your account
• Use the service legally and appropriately
• Not share account access with others
• Report unauthorized account use''',
                  ),
                  _buildSection(
                    title: 'Service Availability',
                    content: 'We strive to provide uninterrupted service but do not guarantee continuous access. Maintenance and updates may cause temporary interruptions.',
                  ),
                  _buildSection(
                    title: 'Intellectual Property',
                    content: 'All content, features, and functionality are owned by Hai Helper and protected by international copyright laws.',
                  ),
                  _buildSection(
                    title: 'Limitation of Liability',
                    content: 'Hai Helper is not liable for any indirect, incidental, special, or consequential damages resulting from your use of the service.',
                  ),
                  _buildSection(
                    title: 'Changes to Terms',
                    content: 'We reserve the right to modify these terms at any time. Continued use of the service constitutes acceptance of modified terms.',
                  ),
                  _buildSection(
                    title: 'Termination',
                    content: 'We may terminate or suspend your account for violations of these terms, illegal activities, or as required by law.',
                  ),
                  _buildSection(
                    title: 'Governing Law',
                    content: 'These terms are governed by and construed in accordance with applicable laws, without regard to conflict of law principles.',
                  ),

                  // Version and last updated
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'Version 1.0 - Last Updated: March 2024',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Handle contact support
                      },
                      child: const Text(
                        'Contact Support',
                        style: TextStyle(
                          color: Color(0xFF7B6EF6),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 