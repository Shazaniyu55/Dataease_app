// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Dummy notifications data
  List<Map<String, dynamic>> notifications = [
    {
      "id": 1,
      "title": "Payment Successful",
      "body": "Your data purchase of 1GB on Airtel was successful.",
      "isRead": false,
      "date": DateTime.now().subtract(Duration(minutes: 5))
    },
    {
      "id": 2,
      "title": "New Offer Available",
      "body": "Get 2GB bonus data on MTN for 30 days!",
      "isRead": false,
      "date": DateTime.now().subtract(Duration(hours: 1))
    },
    {
      "id": 3,
      "title": "Wallet Updated",
      "body": "Your wallet balance has been credited with ₦5000.",
      "isRead": true,
      "date": DateTime.now().subtract(Duration(days: 1))
    },
  ];

  void markAsRead(int index) {
    setState(() {
      notifications[index]["isRead"] = true;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationDetailScreen(
          title: notifications[index]["title"],
          body: notifications[index]["body"],
          date: notifications[index]["date"],
        ),
      ),
    );
  }

  void deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Notification deleted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];

          return Dismissible(
            key: Key(notification["id"].toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              color: Colors.redAccent,
              child: Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) => deleteNotification(index),
            child: ListTile(
              onTap: () => markAsRead(index),
              tileColor: notification["isRead"] ? Colors.grey[200] : Colors.white,
              leading: Icon(
                notification["isRead"] ? Icons.mark_email_read : Icons.notifications,
                color: notification["isRead"] ? Colors.grey : Colors.blueAccent,
              ),
              title: Text(
                notification["title"],
                style: TextStyle(
                  fontWeight: notification["isRead"] ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              subtitle: Text(
                notification["body"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                "${notification["date"].hour}:${notification["date"].minute.toString().padLeft(2, '0')}",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}

class NotificationDetailScreen extends StatelessWidget {
  final String title;
  final String body;
  final DateTime date;

  const NotificationDetailScreen({
    super.key,
    required this.title,
    required this.body,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification Detail", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              body,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}