import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BudgetPeriodScreen extends StatelessWidget {
  const BudgetPeriodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedPeriod = ValueNotifier<String>('Yearly');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const LinearProgressIndicator(
                      value: 0.2, // 40% progress
                      minHeight: 8,
                      backgroundColor: Color(0xFFE8E8E8),
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B6EF6)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Total Allocated Budget',
                      style: TextStyle(
                        color: Color(0xFF2D3142),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your total Budget',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Period Selection Buttons
                    ValueListenableBuilder<String>(
                      valueListenable: selectedPeriod,
                      builder: (context, value, child) {
                        return Column(
                          children: [
                            _buildPeriodButton(
                              label: 'Yearly',
                              isSelected: value == 'Yearly',
                              onPressed: () => selectedPeriod.value = 'Yearly',
                            ),
                            const SizedBox(height: 16),
                            _buildPeriodButton(
                              label: 'Monthly',
                              isSelected: value == 'Monthly',
                              onPressed: () => selectedPeriod.value = 'Monthly',
                            ),
                            const SizedBox(height: 16),
                            _buildPeriodButton(
                              label: 'Weekly',
                              isSelected: value == 'Weekly',
                              onPressed: () => selectedPeriod.value = 'Weekly',
                            ),
                          ],
                        );
                      },
                    ),
                    const Spacer(),
                    // Next button
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7B6EF6).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to budget category screen
                            context.push('/budget-category', extra: selectedPeriod.value);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7B6EF6),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodButton({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF7B6EF6) : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black54,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isSelected ? Colors.transparent : Colors.grey.shade300,
              width: 1,
            ),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
} 