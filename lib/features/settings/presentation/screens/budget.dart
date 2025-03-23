import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Change to a map provider to store multiple selections
final selectedCategoriesProvider = StateProvider<Map<String, double>>((ref) => {});
final budgetAmountProvider = StateProvider<String>((ref) => '');
final dialogButtonSelectionProvider = StateProvider<String>((ref) => 'submit');

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  final Map<String, List<String>> budgetSections = const {
    'Core Supports Budget': [
      'Consumables',
      'Daily Activities',
      'Assistance with Social and Community Participation',
      'Transport',
    ],
    'Capacity Building Budget': [
      'Choice and Control',
      'Daily Activity',
      'Employment',
      'Health and Wellbeing',
      'Home Living',
      'Lifelong Learning',
      'Relationships',
      'Social and Community Participation',
    ],
    'Capital Supports Budget': [
      'Assistive Technology',
      'Home Modifications',
      'Vehicle Modifications',
      'Specialist Disability Accommodation',
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadSavedCategories();
  }

  // Load any previously saved categories on init
  Future<void> _loadSavedCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedCategories = prefs.getStringList('selected_categories') ?? [];

    Map<String, double> categoriesMap = {};
    for (String category in selectedCategories) {
      final amount = prefs.getDouble('budget_amount_$category');
      if (amount != null) {
        categoriesMap[category] = amount;
      }
    }

    ref.read(selectedCategoriesProvider.notifier).state = categoriesMap;
  }

  Future<void> _saveBudgetData(String category, double amount) async {
    final prefs = await SharedPreferences.getInstance();

    // Use the same keys as BudgetCategoryScreen
    final selectedCategories = prefs.getStringList('selected_categories') ?? [];

    // Only add if not already in the list
    if (!selectedCategories.contains(category)) {
      selectedCategories.add(category);
      await prefs.setStringList('selected_categories', selectedCategories);
    }

    // Save individual category amount
    await prefs.setDouble('budget_amount_$category', amount);
    await prefs.setBool('is_budget_set', true);
  }

  void _showBudgetDialog(BuildContext context, WidgetRef ref, String category) {
    // Pre-fill the field if category already has a value
    final currentCategories = ref.read(selectedCategoriesProvider);
    if (currentCategories.containsKey(category)) {
      ref.read(budgetAmountProvider.notifier).state =
          currentCategories[category]!.toStringAsFixed(2);
    } else {
      ref.read(budgetAmountProvider.notifier).state = '';
    }

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
                Text(
                  category,
                  style: const TextStyle(
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
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    controller: TextEditingController(
                        text: ref.read(budgetAmountProvider)
                    ),
                    onChanged: (value) {
                      ref.read(budgetAmountProvider.notifier).state = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter amount',
                      prefixText: '💲 ',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, _) {
                          final selectedButton = ref.watch(dialogButtonSelectionProvider);
                          return Container(
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: selectedButton == 'cancel'
                                  ? const Color(0xFF7B6EF6)
                                  : Colors.grey[100],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  ref.read(dialogButtonSelectionProvider.notifier).state = 'cancel';
                                  Navigator.pop(context);
                                },
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: selectedButton == 'cancel'
                                          ? Colors.white
                                          : const Color(0xFF7B6EF6),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Submit Button
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, _) {
                          final selectedButton = ref.watch(dialogButtonSelectionProvider);
                          final budgetAmount = ref.watch(budgetAmountProvider);
                          return Container(
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: selectedButton == 'submit'
                                  ? const Color(0xFF7B6EF6)
                                  : Colors.grey[100],
                              boxShadow: selectedButton == 'submit' ? [
                                BoxShadow(
                                  color: const Color(0xFF7B6EF6).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ] : null,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: budgetAmount.isNotEmpty ? () async {
                                  ref.read(dialogButtonSelectionProvider.notifier).state = 'submit';
                                  try {
                                    final amount = double.tryParse(budgetAmount);
                                    if (amount == null) {
                                      throw Exception('Invalid amount');
                                    }

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

                                    // Save to SharedPreferences
                                    await _saveBudgetData(category, amount);

                                    // Update state with multiple categories
                                    final currentSelections = Map<String, double>.from(
                                        ref.read(selectedCategoriesProvider));
                                    currentSelections[category] = amount;
                                    ref.read(selectedCategoriesProvider.notifier).state = currentSelections;

                                    // Close dialog and show confirmation
                                    if (context.mounted) {
                                      Navigator.pop(context); // Remove loading indicator
                                      Navigator.pop(context); // Close budget dialog

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Budget updated: $category \$${amount.toStringAsFixed(2)}'),
                                          backgroundColor: const Color(0xFF7B6EF6),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      Navigator.pop(context); // Remove loading indicator if showing
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Failed to update budget'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                } : null,
                                child: Center(
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: selectedButton == 'submit'
                                          ? Colors.white
                                          : const Color(0xFF7B6EF6),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
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
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF2D3142),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, WidgetRef ref, String category) {
    final selectedCategories = ref.watch(selectedCategoriesProvider);
    final isSelected = selectedCategories.containsKey(category);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isSelected ? const Color(0xFF7B6EF6) : Colors.white,
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
              _showBudgetDialog(context, ref, category);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  const Text('💲', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF7B6EF6),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Show the amount if selected
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '\$${selectedCategories[category]?.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategories = ref.watch(selectedCategoriesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          const Text(
                            'Budget Categories',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF7B6EF6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (selectedCategories.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${selectedCategories.length} categories selected',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // Categories List with Sections
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: budgetSections.entries.map((section) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(section.key),
                        ...section.value.map((category) {
                          return _buildCategoryItem(context, ref, category);
                        }).toList(),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}