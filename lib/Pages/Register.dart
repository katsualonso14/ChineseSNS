import 'dart:io';

import 'package:chinese_sns/Pages/PostPage.dart';
import 'package:chinese_sns/Utils/Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  // RegisterPage({required Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  late TextEditingController nameInputController;
  late TextEditingController emailInputController;
  late TextEditingController pwdInputController;
  File? image;
  final picker = ImagePicker();

  @override
  initState() {
    nameInputController = TextEditingController();
    emailInputController = TextEditingController();
    pwdInputController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("アカウント作成"),
        backgroundColor: Colors.orange,
      ),
      body: registerscreen(),
    );
  }

  Widget registerscreen() {
    return Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
            child: Form(
              key: _registerFormKey,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      getImageFromGallery();
                    },
                    child: CircleAvatar(
                      foregroundImage: image == null ? null: FileImage(image!),
                      radius: 70,
                      child: Icon(Icons.add),
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Name*', hintText: "Name"),
                    controller: nameInputController,
                    validator: (value) {
                      if (value!.length < 3) {
                        return "名前は3文字以上で入力してください";
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Email*', hintText: "example@gmail.com"),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Password*', hintText: "********"),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  Padding(
                      padding: EdgeInsets.all(10.0)
                  ),
                  ElevatedButton(
                    child: Text(
                      "アカウント作成",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.orange
                    ),
                    onPressed: () async {
                      // フォームが有効か否かチェック
                      if (_registerFormKey.currentState!.validate()) {
                        var result = await Auth.signUp(email: emailInputController.text, password: pwdInputController.text);
                        if(result is UserCredential) {
                          await upLoadImage(result.user!.uid);
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ],
              ),
            )
        )
    );
  }

  //文字列チェック関数
  String? emailValidator(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return '正しいEmailのフォーマットで入力してください';
    }
  }
  // ８文字以上をチェック
  String? pwdValidator(String? value) {
    if (value!.length < 8) {
      return 'パスワードは8文字以上で入力してください';
    }
  }
  //画像読み込み
  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }

  }

  //画像のアップロード
  Future<void> upLoadImage(String uid) async {
    final FirebaseStorage strongeInstance = FirebaseStorage.instance;
    final Reference ref = strongeInstance.ref();
    await ref.child(uid).putFile(image!);
    String downloadURL = await strongeInstance.ref(uid).getDownloadURL();
    print(downloadURL);
  }


}