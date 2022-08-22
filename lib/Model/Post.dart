import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String post;
  Timestamp sendTime;
  String uid;

  Post({required this.post, required this.sendTime, required this.uid});
}