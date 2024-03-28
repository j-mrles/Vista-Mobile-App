import 'package:flutter/material.dart';


class VistaFeed extends StatelessWidget {
  final List<String> posts = [
    "Welcome to Vista!",
    "This is a sample post.",
    // Add more sample posts here
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(posts[index]),
          ),
        );
      },
    );
  }
}
