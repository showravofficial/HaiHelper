import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                        'Privacy & Security',
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
                    title: 'Data Collection',
                    content: 'We collect information that you provide directly to us, including but not limited to your name, email address, and usage data to improve our services.',
                  ),
                  _buildSection(
                    title: 'How We Use Your Information',
                    content: 'Your information is used to provide and improve our services, communicate with you, and ensure a secure experience while using our application.',
                  ),
                  _buildSection(
                    title: 'Data Security',
                    content: 'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access or disclosure.',
                  ),
                  _buildSection(
                    title: 'Third-Party Services',
                    content: 'We may use third-party services that collect, monitor and analyze this information to improve our service\'s functionality.',
                  ),
                  _buildSection(
                    title: 'Your Rights',
                    content: 'You have the right to access, correct, or delete your personal information. You can also opt out of certain data collection practices.',
                  ),
                  _buildSection(
                    title: 'Updates to This Policy',
                    content: 'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.',
                  ),
                  _buildSection(
                    title: 'Contact Us',
                    content: 'If you have any questions about this Privacy Policy, please contact us at support@haihelper.com',
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