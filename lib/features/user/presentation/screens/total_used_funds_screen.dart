import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TotalUsedFundsScreen extends StatelessWidget {
  final String selectedPeriod;
  final String selectedCategory;
  final DateTime startDate;
  final DateTime endDate;
  final double totalAllocatedFunds;

  const TotalUsedFundsScreen({
    super.key,
    required this.selectedPeriod,
    required this.selectedCategory,
    required this.startDate,
    required this.endDate,
    required this.totalAllocatedFunds,
  });

  @override
  Widget build(BuildContext context) {
    final fundsController = TextEditingController();

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
                      value: 1.0, // 100% progress
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
                      'Total Used funds',
                      style: TextStyle(
                        color: Color(0xFF2D3142),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Funds Input Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 25,
                            spreadRadius: -5,
                            offset: const Offset(0, 20),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            spreadRadius: -5,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: fundsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Type',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter used funds';
                          }
                          final usedFunds = double.tryParse(value);
                          if (usedFunds == null) {
                            return 'Please enter a valid number';
                          }
                          if (usedFunds > totalAllocatedFunds) {
                            return 'Used funds cannot exceed allocated funds';
                          }
                          return null;
                        },
                      ),
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
                        child: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: fundsController,
                          builder: (context, value, child) {
                            final isValid = value.text.isNotEmpty &&
                                double.tryParse(value.text) != null &&
                                double.parse(value.text) <= totalAllocatedFunds;
                            return ElevatedButton(
                              onPressed: isValid
                                  ? () {
                                      // Navigate to home with all selections
                                      context.go('/main', extra: {
                                        'period': selectedPeriod,
                                        'category': selectedCategory,
                                        'startDate': startDate,
                                        'endDate': endDate,
                                        'totalAllocatedFunds': totalAllocatedFunds,
                                        'totalUsedFunds': double.parse(value.text),
                                      });
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7B6EF6),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                                disabledBackgroundColor: Colors.grey[300],
                              ),
                              child: const Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
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
} 