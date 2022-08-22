import 'package:chinese_sns/Model/Users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../Model/Post.dart';
import '../Utils/firebase.dart';

class PostPage extends StatefulWidget {
  final String uid;
  PostPage({required this.uid});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<Post> postList = [];
  List<Users> userList = [];
  //Firebaseデータ取得
  Future<void> getPost() async {
    postList = await Firestore.getPost();
  }
  // Future<void> getUser() async {
  //   userList = await Firestore.getUser();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('post').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            //ネット不安定時にくるくるを表示
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return FutureBuilder(
              future: getPost(),
              builder: (context, snapshot) {
                return ListView.builder(
                    itemCount: postList.length,
                    itemBuilder: (context, index) {
                      Post _post = postList[index];
                      DateTime sendTime = _post.sendTime.toDate();

                      return Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(_post.uid),
                              subtitle: Text(_post.post),
                              leading: const SizedBox(
                                width: 60.0,
                                height: 60.0,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage('https://matsumarudesu.com/wp-content/uploads/2021/02/IMG_2576-1024x576.png'),
                                  radius: 16,
                                ),
                              ),
                              trailing: Text(intl.DateFormat('MM/dd HH:mm').format(sendTime),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
            );
          },
        )
    );
  }
}
