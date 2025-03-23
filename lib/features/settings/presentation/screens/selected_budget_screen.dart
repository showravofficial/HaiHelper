import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedBudgetScreen extends StatefulWidget {
  const SelectedBudgetScreen({super.key});

  @override
  State<SelectedBudgetScreen> createState() => _SelectedBudgetScreenState();
}

class _SelectedBudgetScreenState extends State<SelectedBudgetScreen> {
  List<String> selectedCategories = [];
  Map<String, double> categoryAmounts = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBudgetData();
  }

  Future<void> _loadBudgetData() async {
    final prefs = await SharedPreferences.getInstance();
    final categories = prefs.getStringList('selected_categories') ?? [];

    Map<String, double> amounts = {};
    for (String category in categories) {
      final amount = prefs.getDouble('budget_amount_$category') ?? 0.0;
      amounts[category] = amount;
    }

    setState(() {
      selectedCategories = categories;
      categoryAmounts = amounts;
      isLoading = false;
    });
  }

  Future<void> _updateBudget() async {
    // Save updated amounts back to SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Save updated list of categories
    await prefs.setStringList('selected_categories', selectedCategories);

    // Save individual category amounts
    for (String category in selectedCategories) {
      await prefs.setDouble('budget_amount_$category', categoryAmounts[category] ?? 0.0);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Budget updated successfully')),
    );
  }

  Future<void> _deleteCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      selectedCategories.remove(category);
      categoryAmounts.remove(category);
    });

    // Remove from SharedPreferences
    await prefs.remove('budget_amount_$category');
    await prefs.setStringList('selected_categories', selectedCategories);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$category removed from budget'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            setState(() {
              selectedCategories.add(category);
              categoryAmounts[category] = 0.0;
            });
            await prefs.setStringList('selected_categories', selectedCategories);
          },
        ),
      ),
    );
  }

  void _editAmount(String category) {
    final TextEditingController controller = TextEditingController(
      text: (categoryAmounts[category] ?? 0.0).toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update $category budget'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixText: '\$ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newAmount = double.tryParse(controller.text) ?? 0.0;
              setState(() {
                categoryAmounts[category] = newAmount;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF7569FF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Selected Budget',
          style: TextStyle(
            color: Color(0xFF7569FF),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Items',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    'Amount',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: selectedCategories.length,
                itemBuilder: (context, index) {
                  final category = selectedCategories[index];
                  final amount = categoryAmounts[category] ?? 0.0;

                  return Dismissible(
                    key: Key(category),
                    direction: DismissDirection.startToEnd, // Only left to right
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      _deleteCategory(category);
                    },
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: Text("Are you sure you want to remove $category from your budget?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text("Delete"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      onTap: () => _editAmount(category),
                      title: Row(
                        children: [
                          const Text('\$ ', style: TextStyle(color: Colors.black)),
                          Text(
                            category,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      trailing: Text(
                        '\$${amount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Color(0xFF7569FF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateBudget,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7569FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Update Budget',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}