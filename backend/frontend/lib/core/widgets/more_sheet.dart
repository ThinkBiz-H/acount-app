import 'package:flutter/material.dart';
import '../../features/account/screens/accounts_screen.dart'; // ⭐ FIXED
import '../../features/profile/screens/profile_screen.dart';
import '../../features/help/help_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/billing/screens/billing_screen.dart';
import '../../features/stock/screens/stock_screen.dart';
import '../../features/profile/screens/multi_device_screen.dart';
import '../../features/reminder/screens/reminder_customers_screen.dart';

class MoreSheet extends StatelessWidget {
  const MoreSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          /// FIRST ROW
          _row(context, [
            _item(Icons.account_balance, 'Account', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AccountsScreen()), // ⭐ FIXED
              );
            }),
            _item(Icons.person, 'Profile', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            }),
            _item(Icons.help_outline, 'Help', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpScreen()),
              );
            }),
            _item(Icons.settings, 'Settings', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            }),
          ]),

          const SizedBox(height: 24),

          /// SECOND ROW
          _row(context, [
            _item(Icons.receipt_long, 'Bills', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BillingScreen()),
              );
            }),
            _item(Icons.inventory, 'Stock', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StockScreen()),
              );
            }),
            _item(Icons.devices, 'Multi\nDevice', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MultiDeviceScreen()),
              );
            }),
            _item(Icons.notifications, 'Reminder', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ReminderCustomersScreen(),
                ),
              );
            }),
          ]),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: children,
    );
  }

  Widget _item(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          // CircleAvatar(
          //   radius: 26,
          //   backgroundColor: Colors.green.shade50,
          //   child: Icon(icon, color: Colors.green),
          // ),
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFF0C2752),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
