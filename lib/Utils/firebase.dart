
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/Post.dart';

class Firestore {

  static final FirebaseFirestore _firebaseInstance = FirebaseFirestore.instance;
  static final posts = _firebaseInstance.collection('post');
  static final users = _firebaseInstance.collection('users');

  //お風呂投稿データ取得
  static Future<List<Post>>getPost() async{
    List<Post> postList = [];
    final snapshot = await posts.get();

    await Future.forEach<QueryDocumentSnapshot<Map<String, dynamic>>>(snapshot.docs, (doc){

      Post post = Post(
          post: doc.data()['post'],
          sendTime: doc.data()['sendTime'],
          uid: doc.data()['uid'],
      );
      postList.add(post);
    });
    //時間順に並べる
    postList.sort((a,b) => b.sendTime.compareTo(a.sendTime));
    return postList;
  }

}