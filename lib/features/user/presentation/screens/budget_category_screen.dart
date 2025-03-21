import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final budgetAmountProvider = StateProvider<String>((ref) => '');

class BudgetCategoryScreen extends ConsumerWidget {
  const BudgetCategoryScreen({super.key});

  final List<String> categories = const [
    'Behaviour support',
    'Choice and control',
    'Finding and keeping a job',
    'Health and wellbeing',
    'Improved daily living skills',
    'Improved living arrangements',
    'Increased social and community participation',
    'Lifelong learning',
    'Relationships',
    'Support coordination and psychosocial recovery coaches',
  ];

  void _showBudgetDialog(BuildContext context, WidgetRef ref, String category) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Budget',
                  style: TextStyle(
                    color: Color(0xFF7B6EF6),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: -5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      ref.read(budgetAmountProvider.notifier).state = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Type',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xFF7B6EF6),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7B6EF6).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Consumer(
                    builder: (context, ref, _) {
                      final budgetAmount = ref.watch(budgetAmountProvider);
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: budgetAmount.isNotEmpty ? () {
                            Navigator.pop(context);
                            // Navigate to budget start date screen with category and budget data
                            context.push('/budget-start-date', extra: {
                              'category': category,
                              'budget': double.parse(budgetAmount),
                              'period': 'Monthly', // You might want to pass this from previous screen
                            });
                          } : null,
                          child: const Center(
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

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
                      value: 0.4, // 40% progress
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    // Title
                    const Text(
                      'Budget Category',
                      style: TextStyle(
                        color: Color(0xFF7B6EF6),
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Categories List
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: categories.map((category) {
                            final isSelected = selectedCategory == category;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: isSelected 
                                      ? const Color(0xFF7B6EF6)
                                      : Colors.white,
                                  boxShadow: [
                                    if (!isSelected)
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(30),
                                    onTap: () {
                                      ref.read(selectedCategoryProvider.notifier).state = category;
                                      ref.read(budgetAmountProvider.notifier).state = '';
                                      _showBudgetDialog(context, ref, category);
                                    },
                                    child: Center(
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                          color: isSelected 
                                              ? Colors.white 
                                              : const Color(0xFF7B6EF6),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
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