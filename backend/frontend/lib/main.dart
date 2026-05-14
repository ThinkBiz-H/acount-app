// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:provider/provider.dart';
// import 'providers/bill_template_provider.dart';
// import 'features/customer/screens/customer_list_screen.dart';
// import 'features/customer/screens/customer_sms_settings_screen.dart';
// import 'features/supplier/screens/supplier_statement_screen.dart';

// import 'providers/customer_provider.dart';
// import 'core/providers/language_provider.dart';
// import 'core/screens/splash_screen.dart';
// import 'features/stock/models/stock_item.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Hive.initFlutter();
//   Hive.registerAdapter(StockItemAdapter());

//   await Future.wait([
//     Hive.openBox('bills'),
//     Hive.openBox<StockItem>('stock'),
//     Hive.openBox('settings'),
//   ]);

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => CustomerProvider()),
//         ChangeNotifierProvider(create: (_) => LanguageProvider()),
//         ChangeNotifierProvider(create: (_) => BillTemplateProvider()),
//       ],
//       child: Consumer<LanguageProvider>(
//         builder: (context, langProvider, _) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             locale: langProvider.locale,

//             theme: ThemeData(
//               primarySwatch: Colors.green,
//               scaffoldBackgroundColor: const Color(0xfff6f6f6),
//               appBarTheme: const AppBarTheme(
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.black,
//                 elevation: 0,
//               ),
//             ),

//             routes: {
//               "/supplierStatement": (_) => const SupplierStatementScreen(),
//               "/customerList": (_) => const CustomerListScreen(),

//               "/smsSettings": (context) {
//                 final name =
//                     ModalRoute.of(context)!.settings.arguments as String;
//                 return CustomerSmsSettingsScreen(customerName: name);
//               },
//             },

//             home: const SplashScreen(),
//           );
//         },
//       ),
//     );
//   }
// }

// aaj ye code kiya hai

// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:provider/provider.dart';

// import 'providers/bill_template_provider.dart';
// import 'providers/customer_provider.dart';

// import 'core/providers/language_provider.dart';
// import 'core/screens/splash_screen.dart';

// import 'features/customer/screens/customer_list_screen.dart';
// import 'features/customer/screens/customer_sms_settings_screen.dart';
// import 'features/supplier/screens/supplier_statement_screen.dart';
// import 'features/security/screens/pin_lock_screen.dart';

// import 'features/stock/models/stock_item.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Hive.initFlutter();
//   Hive.registerAdapter(StockItemAdapter());

//   await Future.wait([
//     Hive.openBox('bills'),
//     Hive.openBox<StockItem>('stock'),
//     Hive.openBox('settings'),
//   ]);

//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   DateTime? lastPausedTime;
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<CustomerProvider>(
//         context,
//         listen: false,
//       ).checkAutoReminders();
//     });
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   /// 🔐 APP LIFECYCLE (AUTO LOCK)

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     final settingsBox = Hive.box('settings');
//     final bool appLockEnabled = settingsBox.get("appLock", defaultValue: false);

//     if (!appLockEnabled) return;

//     if (state == AppLifecycleState.paused) {
//       lastPausedTime = DateTime.now();
//     }

//     if (state == AppLifecycleState.resumed) {
//       if (lastPausedTime == null) return;

//       final diff = DateTime.now().difference(lastPausedTime!);

//       /// 1 minute 30 sec = 90 seconds
//       if (diff.inSeconds > 90) {
//         Navigator.of(
//           context,
//         ).push(MaterialPageRoute(builder: (_) => const PinLockScreen()));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final settingsBox = Hive.box('settings');
//     final bool appLockEnabled = settingsBox.get("appLock", defaultValue: false);

//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => CustomerProvider()),
//         ChangeNotifierProvider(create: (_) => LanguageProvider()),
//         ChangeNotifierProvider(create: (_) => BillTemplateProvider()),
//       ],
//       child: Consumer<LanguageProvider>(
//         builder: (context, langProvider, _) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             locale: langProvider.locale,

//             theme: ThemeData(
//               primarySwatch: Colors.green,
//               scaffoldBackgroundColor: const Color(0xfff6f6f6),
//               appBarTheme: const AppBarTheme(
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.black,
//                 elevation: 0,
//               ),
//             ),

//             routes: {
//               "/supplierStatement": (_) => const SupplierStatementScreen(),
//               "/customerList": (_) => const CustomerListScreen(),

//               "/smsSettings": (context) {
//                 final name =
//                     ModalRoute.of(context)!.settings.arguments as String;
//                 return CustomerSmsSettingsScreen(customerName: name);
//               },
//             },

//             /// 🔐 APP START LOCK
//             home: appLockEnabled ? const PinLockScreen() : const SplashScreen(),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'providers/bill_template_provider.dart';
import 'providers/customer_provider.dart';

import 'core/providers/language_provider.dart';
import 'core/screens/splash_screen.dart';

import 'features/customer/screens/customer_list_screen.dart';
import 'features/customer/screens/customer_sms_settings_screen.dart';
import 'features/supplier/screens/supplier_statement_screen.dart';
import 'features/security/screens/pin_lock_screen.dart';

import 'features/stock/models/stock_item.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(StockItemAdapter());

  await Future.wait([
    Hive.openBox('bills'),
    Hive.openBox<StockItem>('stock'),
    Hive.openBox('settings'),
  ]);

  await Hive.box<StockItem>('stock').clear();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  DateTime? lastPausedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 🔐 APP LIFECYCLE (AUTO LOCK)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final settingsBox = Hive.box('settings');
    final bool appLockEnabled = settingsBox.get("appLock", defaultValue: false);

    if (!appLockEnabled) return;

    if (state == AppLifecycleState.paused) {
      lastPausedTime = DateTime.now();
    }

    if (state == AppLifecycleState.resumed) {
      if (lastPausedTime == null) return;

      final diff = DateTime.now().difference(lastPausedTime!);

      if (diff.inSeconds > 90) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const PinLockScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsBox = Hive.box('settings');
    final bool appLockEnabled = settingsBox.get("appLock", defaultValue: false);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => BillTemplateProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, langProvider, _) {
          // 🔥 SAFE PLACE FOR PROVIDER CALL
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<CustomerProvider>().checkAutoReminders();
          });

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: langProvider.locale,

            theme: ThemeData(
              primarySwatch: Colors.green,
              scaffoldBackgroundColor: const Color(0xfff6f6f6),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
              ),
            ),

            routes: {
              "/supplierStatement": (_) => const SupplierStatementScreen(),
              "/customerList": (_) => const CustomerListScreen(),

              "/smsSettings": (context) {
                final name =
                    ModalRoute.of(context)!.settings.arguments as String;
                return CustomerSmsSettingsScreen(customerName: name);
              },
            },

            /// 🔐 APP START LOCK
            home: appLockEnabled ? const PinLockScreen() : const SplashScreen(),
          );
        },
      ),
    );
  }
}
