import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Notifications', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            child: ListTile(
              leading: const Icon(Icons.notifications, color: Colors.blueGrey),
              title: Text('Notification ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  'Room Number: ${index + 1}, Time: ${DateTime.now().toString().substring(0, 16)}'),
              // trailing: Icon(Icons.delete, color: Colors.red),
            ),
          );
        },
      ),
    );
  }
}
