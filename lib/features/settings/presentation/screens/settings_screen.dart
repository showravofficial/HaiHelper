import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


final isDarkModeProvider = StateProvider<bool>((ref) => false);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);

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
                  const Text(
                    'Setting',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF7B6EF6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Switch(
                  //   value: isDarkMode,
                  //   onChanged: (value) {
                  //     ref.read(isDarkModeProvider.notifier).state = value;
                  //   },
                  //   activeColor: const Color(0xFF7B6EF6),
                  // ),
                ],
              ),
            ),

            // Settings List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SettingItem(
                    icon: Icons.history,
                    title: 'History',
                    onTap: () => context.push('/history'),
                  ),
                  _SettingItem(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Budget Update',
                    onTap: () => context.push('/settings/budget'),
                  ),
                  _SettingItem(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Selected Budget',
                    onTap: () => context.push('/selected-budget-screen'),
                  ),
                  _SettingItem(
                    icon: Icons.flash_on,
                    title: 'Manage Subscription',
                    onTap: () => context.push('/manage-subscription'),
                  ),
                  _SettingItem(
                    icon: Icons.lock_outline,
                    title: 'Privacy & Security',
                    onTap: () => context.push('/privacy-policy'),
                  ),
                  _SettingItem(
                    icon: Icons.description_outlined,
                    title: 'Terms & Condition',
                    onTap: () => context.push('/terms-conditions'),
                  ),
                  _SettingItem(
                    icon: Icons.headphones_outlined,
                    title: 'Help & Support',
                    onTap: () => context.push('/help-support'),
                  ),
                  _SettingItem(
                    icon: Icons.info_outline,
                    title: 'About Us',
                    onTap: () => context.push('/about-us'),
                  ),
                  _SettingItem(
                    icon: Icons.logout,
                    title: 'Log out',
                    isDestructive: true,
                    onTap: () {
                      // Handle logout
                      context.go('/auth');
                    },
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

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive 
              ? Colors.red.withOpacity(0.1)
              : const Color(0xFF7B6EF6).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : const Color(0xFF7B6EF6),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: isDestructive ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isDestructive ? Colors.red : Colors.grey,
      ),
      onTap: onTap,
    );
  }
} 