import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/customer_provider.dart';
import '../../customer/screens/add_customer_screen.dart';
import '../../customer/screens/customer_detail_screen.dart';
import '../../../core/widgets/balance_card.dart';
import '../../notifications/screens/notification_screen.dart';
import '../../profile/screens/profile_screen.dart';
import 'package:hive/hive.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final searchController = TextEditingController();

  List filteredList = [];
  int selectedTab = 0;

  /// ⭐⭐⭐ AUTO REMINDER TRIGGER WHEN APP OPENS ⭐⭐⭐

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      /// ⭐ BUSINESS PROFILE LOAD
      context.read<CustomerProvider>().loadBusinessProfile();

      final box = Hive.box('settings');
      final mobile = box.get('mobile');

      if (mobile != null) {
        await context.read<CustomerProvider>().loadCustomers(mobile);
      }

      /// ⭐ AUTO REMINDER CHECK
      context.read<CustomerProvider>().checkAutoReminders();
    });
  }

  Widget _buildCreateBusinessUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Setup your Business Profile",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          const Text(
            "Add your business name and mobile number to continue",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Create Business Profile"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Consumer<CustomerProvider>(
          builder: (context, provider, child) {
            /// ⭐ FIRST TIME USER
            if (!provider.isBusinessCreated) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Setup your Business Profile",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: const Text("Create Business Profile"),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ProfileScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            /// ⭐ NORMAL USER UI
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.purple,
                        backgroundImage: provider.businessImage,
                        child: provider.businessImage == null
                            ? Text(
                                provider.businessName[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.businessName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(provider.businessPhone),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit Profile"),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ProfileScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.add_business),
                    title: const Text("Create New Business"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void searchPerson(String value, List people) {
    if (value.isEmpty) {
      setState(() => filteredList = people);
      return;
    }

    final results = people.where((p) {
      return p.name.toLowerCase().contains(value.toLowerCase());
    }).toList();

    setState(() => filteredList = results);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);

    final people = selectedTab == 0 ? provider.customers : provider.suppliers;
    final listToShow = searchController.text.isEmpty ? people : filteredList;

    double totalCustomerBalance = 0;
    for (var c in provider.customers) {
      if (c.balance > 0) {
        totalCustomerBalance += c.balance;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,

        title: Row(
          children: [
            Image.asset("assets/images/main-screen20.png", height: 60),
            const Spacer(),

            /// 👤 PROFILE ICON (NEW)
            Consumer<CustomerProvider>(
              builder: (context, provider, child) {
                return GestureDetector(
                  onTap: () => _openProfileSheet(context),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFF0C2752),
                    backgroundImage: provider.businessImage,
                    child: provider.businessImage == null
                        ? Text(
                            provider.businessName.isNotEmpty
                                ? provider.businessName[0].toUpperCase()
                                : "B",
                            style: const TextStyle(color: Colors.white),
                          )
                        : null,
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
          ],
        ),

        actions: [
          /// 🔔 NOTIFICATION ICON
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationScreen()),
              );
            },
          ),

          /// SHARE ICON
          IconButton(
            icon: const Icon(Icons.share, color: Colors.green),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Share app coming soon")),
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0C2752),
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCustomerScreen()),
          );

          if (result != null) {
            context.read<CustomerProvider>().addPerson(
              result['name'],
              result['phone'],
              result['address'],
              result['type'].toUpperCase(),
            );
          }
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BalanceCard(showYouGive: selectedTab == 1),
            const SizedBox(height: 16),

            /// SEARCH
            TextField(
              controller: searchController,
              onChanged: (v) => searchPerson(v, people),
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                _tabButton("Customer", 0),
                const SizedBox(width: 10),
                _tabButton("Supplier", 1),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: listToShow.isEmpty
                  ? Center(
                      child: Text(
                        selectedTab == 0
                            ? "No customers found"
                            : "No suppliers found",
                      ),
                    )
                  : ListView.builder(
                      itemCount: listToShow.length,
                      itemBuilder: (context, index) {
                        final person = listToShow[index];
                        final balance = person.balance;

                        return _personTile(
                          context,
                          person,
                          amount: "₹${balance.abs().toStringAsFixed(0)}",
                          isDue: balance > 0,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
            searchController.clear();
            filteredList = [];
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selectedTab == index
                ? const Color(0xFF0C2752)
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selectedTab == index ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _personTile(
    BuildContext context,
    dynamic person, {
    required String amount,
    required bool isDue,
  }) {
    final provider = Provider.of<CustomerProvider>(context, listen: false);
    final image = provider.getCustomerImage(person);

    return Card(
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1E8E3E),
          backgroundImage: image,
          child: image == null
              ? Text(
                  person.name[0],
                  style: const TextStyle(color: Colors.white),
                )
              : null,
        ),
        title: Text(person.name),
        subtitle: const Text('Tap to view transactions'),
        trailing: Text(
          amount,
          style: TextStyle(
            color: isDue ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CustomerDetailScreen(customerName: person.name),
            ),
          );
        },
      ),
    );
  }
}
