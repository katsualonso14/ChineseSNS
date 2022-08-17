import 'package:flutter/material.dart';

class PostPage extends StatelessWidget {
  PostPage(this.uid);
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.red,
          child: Text('uid is $uid'),
        ),
      ),
    );
  }
}

class Users {
  String uid;

  Users({required this.uid});
}