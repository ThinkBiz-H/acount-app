import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications"), centerTitle: true),
      body: ListView(
        children: const [
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.notifications)),
            title: Text("Reminder"),
            subtitle: Text("You have pending payments to collect"),
          ),

          ListTile(
            leading: CircleAvatar(child: Icon(Icons.notifications)),
            title: Text("Backup"),
            subtitle: Text("Your data was backed up successfully"),
          ),

          ListTile(
            leading: CircleAvatar(child: Icon(Icons.notifications)),
            title: Text("Welcome"),
            subtitle: Text("Thanks for using SmartBahi ❤️"),
          ),
        ],
      ),
    );
  }
}
