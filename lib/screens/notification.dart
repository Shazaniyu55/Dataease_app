// ignore_for_file: prefer_const_constructors

import 'package:dataapp/assistant/assistant.dart';
import 'package:dataapp/services/tokenServie.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late VtuApi vtuApi;
  late TokenService tokenService;

  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    tokenService = TokenService();
    vtuApi = VtuApi();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      String? token = await tokenService.getToken();

      var result = await vtuApi.getUserNotify(token: token!);

      setState(() {
        notifications = List<Map<String, dynamic>>.from(result["data"]);
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching notifications: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void markAsRead(int index) {
    setState(() {
      notifications[index]["isRead"] = true;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationDetailScreen(
          title: notifications[index]["title"] ?? "",
          body: notifications[index]["message"] ?? "",
          date: DateTime.parse(notifications[index]["createdAt"]),
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
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(child: Text("No notifications available"))
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];

                    DateTime date =
                        DateTime.parse(notification["createdAt"]);

                    return Dismissible(
                      key: Key(notification["_id"] ?? index.toString()),
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
                        tileColor: notification["isRead"] == true
                            ? Colors.grey[200]
                            : Colors.white,
                        leading: Icon(
                          notification["isRead"] == true
                              ? Icons.mark_email_read
                              : Icons.notifications,
                          color: notification["isRead"] == true
                              ? Colors.grey
                              : Colors.blueAccent,
                        ),
                        title: Text(
                          notification["title"] ?? "",
                          style: TextStyle(
                            fontWeight: notification["isRead"] == true
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          notification["message"] ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          "${date.hour}:${date.minute.toString().padLeft(2, '0')}",
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey),
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
        title: Text(
          "Notification Detail",
          style: TextStyle(color: Colors.white),
        ),
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