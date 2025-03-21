import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';

class ManageSubscriptionScreen extends StatelessWidget {
  const ManageSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  const Text(
                    'Manage Subscription',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF7B6EF6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton.icon(
                    label: Text('Buy Now', style: TextStyle(color: Colors.black)),
                    icon: SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset(
                        'assets/icons/buynow.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    onPressed: () => context.push('/subscription'),
                  ),
                ],
              ),
            ),

            // Logo and Title
            const SizedBox(height: 40),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF7B6EF6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'hai',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Hai Helper',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            // Subscription Details
            _SubscriptionDetailItem(
              label: 'Amount',
              value: '2.95\$',
              valueColor: const Color(0xFF7B6EF6),
            ),
            _SubscriptionDetailItem(
              label: 'Begins',
              value: '18 March,2024',
            ),
            _SubscriptionDetailItem(
              label: 'Ends',
              value: '18 April,2024',
            ),
            _SubscriptionDetailItem(
              label: 'Type',
              value: 'Premium',
              valueColor: Colors.green,
            ),

            const Spacer(),

            // Buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle renew
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B6EF6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Renew',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Handle cancel
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF7B6EF6),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(
                          color: Color(0xFF7B6EF6),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
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
}

class _SubscriptionDetailItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SubscriptionDetailItem({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: valueColor ?? Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 