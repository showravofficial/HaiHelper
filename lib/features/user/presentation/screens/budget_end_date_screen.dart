import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BudgetEndDateScreen extends StatelessWidget {
  final String selectedCategory;
  final double budget;
  final DateTime startDate;

  const BudgetEndDateScreen({
    super.key,
    required this.selectedCategory,
    required this.budget,
    required this.startDate,
  });

  // Function to save budget data to SharedPreferences
  Future<void> _saveBudgetData(DateTime endDate) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('budget_category', selectedCategory);
      await prefs.setDouble('budget_amount', budget);
      await prefs.setString('budget_start_date', startDate.toIso8601String());
      await prefs.setString('budget_end_date', endDate.toIso8601String());
      await prefs.setBool('is_budget_set', true);
    } catch (e) {
      debugPrint('Error saving budget data: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ValueNotifier<DateTime?>(null);

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
                      'Budget plan end date',
                      style: TextStyle(
                        color: Color(0xFF2D3142),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Date Input Field
                    ValueListenableBuilder<DateTime?>(
                      valueListenable: selectedDate,
                      builder: (context, value, child) {
                        return Container(
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
                            readOnly: true,
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: startDate.add(const Duration(days: 1)),
                                firstDate: startDate.add(const Duration(days: 1)),
                                lastDate: startDate.add(const Duration(days: 365)),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Color(0xFF7B6EF6),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                selectedDate.value = picked;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Date',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              suffixIcon: Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.grey[500],
                              ),
                            ),
                            controller: TextEditingController(
                              text: value != null
                                  ? '${value.day}/${value.month}/${value.year}'
                                  : '',
                            ),
                          ),
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
                        child: ValueListenableBuilder<DateTime?>(
                          valueListenable: selectedDate,
                          builder: (context, value, child) {
                            return ElevatedButton(
                              onPressed: value != null
                                  ? () async {
                                      try {
                                        // Show loading indicator
                                        if (context.mounted) {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return const Center(
                                                child: CircularProgressIndicator(
                                                  color: Color(0xFF7B6EF6),
                                                ),
                                              );
                                            },
                                          );
                                        }

                                        // Save data to SharedPreferences
                                        await _saveBudgetData(value);

                                        // Remove loading indicator and navigate
                                        if (context.mounted) {
                                          Navigator.pop(context); // Remove loader
                                          context.go('/main');
                                        }
                                      } catch (e) {
                                        // Handle error
                                        if (context.mounted) {
                                          Navigator.pop(context); // Remove loader
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Failed to save budget data'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
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