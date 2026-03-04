// ignore_for_file: non_constant_identifier_names, sort_child_properties_last

import 'package:flutter/material.dart';

class ListOfVendors extends StatefulWidget {
  const ListOfVendors({super.key});

  @override
  State<ListOfVendors> createState() => _ListOfVendorsState();
}

class _ListOfVendorsState extends State<ListOfVendors> {
  final TextEditingController _search = TextEditingController();

  // Define a list of user data
  final List<Map<String, dynamic>> users = [
    {
      'id': '1',
      'name': 'Musa Gbadamosi',
      'imageUrl':
          'https://res.cloudinary.com/damufjozr/image/upload/v1717752047/avatar_nwakgu.png',
      'isOnline': true,
      'messageText': 'Patronage'
    },
    {
      'id': '2',
      'name': 'Jane Doe',
      'imageUrl': 'https://randomuser.me/api/portraits/women/1.jpg',
      'isOnline': false,
      'messageText': 'Available on request'
    },
    {
      'id': '3',
      'name': 'John Smith',
      'imageUrl': 'https://randomuser.me/api/portraits/men/2.jpg',
      'isOnline': true,
      'messageText': 'Ready for orders'
    },
    // Add more users as needed
  ];

  Widget UserList(
      {required String id,
      required String name,
      required String imageUrl,
      required bool isOnline,
      required String messageText}) {
    return GestureDetector(
      onTap: () {
        // Handle onTap action here
        // Get.to(MyChatApp(
        //   userId: id,
        //   name: name,
        //   img: imageUrl,
        //   isOnline: isOnline,
        // ));
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl), // Set the image
              maxRadius: 30,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name, // Display user's name
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      isOnline ? 'Online' : 'Offline', // Display online status
                      style: TextStyle(
                        color: isOnline ? Colors.green : Colors.red,
                      ),
                    ),
                    Text(
                      messageText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {},
                child: const Text("Send request"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color
                  shadowColor: Colors.grey, // Shadow color
                  elevation: 5, // Elevation
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Form(
          child: TextFormField(
            controller: _search,
            decoration: const InputDecoration(
              labelText: "Search For vendors",
              labelStyle: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onFieldSubmitted: (String _) {
              setState(() {});
            },
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return UserList(
            id: user['id'],
            name: user['name'],
            imageUrl: user['imageUrl'],
            isOnline: user['isOnline'],
            messageText: user['messageText'],
          );
        },
      ),
    );
  }
}
