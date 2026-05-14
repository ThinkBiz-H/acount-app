// import 'package:flutter/material.dart';
// import '../../features/dashboard/screens/dashboard_screen.dart';
// import '../../features/plan/screens/plan_screen.dart';
// import 'more_sheet.dart';

// class AppBottomNav extends StatefulWidget {
//   const AppBottomNav({super.key});

//   @override
//   State<AppBottomNav> createState() => _AppBottomNavState();
// }

// class _AppBottomNavState extends State<AppBottomNav> {
//   int _index = 0;

//   final _pages = const [DashboardScreen(), PlanScreen(), SizedBox()];

//   void _onTap(int i) {
//     if (i == 2) {
//       showModalBottomSheet(
//         context: context,
//         backgroundColor: Colors.transparent,
//         builder: (_) => const MoreSheet(),
//       );
//       return;
//     }
//     setState(() => _index = i);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_index],

//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _index,
//         onTap: _onTap,

//         /// ICON COLORS
//         selectedIconTheme: const IconThemeData(color: Color(0xFF0C2752)),
//         unselectedIconTheme: const IconThemeData(color: Colors.grey),

//         /// TEXT COLORS
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.grey,

//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Ledger'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.workspace_premium),
//             label: 'My Plan',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.expand_less), label: 'More'),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/plan/screens/plan_screen.dart';
import '../../features/gold/screens/gold_screen.dart'; // 👈 ADD THIS
import 'more_sheet.dart';

class AppBottomNav extends StatefulWidget {
  const AppBottomNav({super.key});

  @override
  State<AppBottomNav> createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav> {
  int _index = 0;

  final _pages = const [
    DashboardScreen(),
    PlanScreen(),
    GoldScreen(), // 👈 ADD THIS
    SizedBox(),
  ];

  void _onTap(int i) {
    if (i == 3) {
      
      // 👈 index changed (More is now 4th)
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => const MoreSheet(),
      );
      return;
    }
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: _onTap,

        /// ICON COLORS
        selectedIconTheme: const IconThemeData(color: Color(0xFF0C2752)),
        unselectedIconTheme: const IconThemeData(color: Colors.grey),

        /// TEXT COLORS
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Ledger'),

          BottomNavigationBarItem(
            icon: Icon(Icons.workspace_premium),
            label: 'My Plan',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on), // 👈 Gold icon
            label: 'Gold',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.expand_less), label: 'More'),
        ],
      ),
    );
  }
}
