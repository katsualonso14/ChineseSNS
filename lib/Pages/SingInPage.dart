import 'package:chinese_sns/Pages/PostPage.dart';
import 'package:chinese_sns/Pages/Register.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  const SignInPage({Key? key}) : super(key: key);
  _SignInPage createState() => _SignInPage();
}

  class _SignInPage extends State<SignInPage> {
  String Email = "";
  String Password = "";
  // 登録・ログインに関する情報を表示
  String infoText = "";

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  late TextEditingController nameInputController;
  late TextEditingController emailInputController;
  late TextEditingController pwdInputController;

  initState() {
    nameInputController = TextEditingController();
    emailInputController = TextEditingController();
    pwdInputController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min, //カラムの位置を調整できるように軸方向のサイズを最小に
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Email*', hintText: "example@gmail.com"),
                controller: emailInputController,
                keyboardType: TextInputType.emailAddress,
                validator: emailValidator,
                onChanged: (String value) {
                  setState(() {
                    Email = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Password*', hintText: "********"),
                controller: pwdInputController,
                obscureText: true,
                validator: pwdValidator,
                onChanged: (String value) {
                  setState(() {
                    Password = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  _showModalPicker(context);
                },
                child: Text(_selectedItem),
              ),

              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // メール/パスワードでログイン
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result =
                    await auth.signInWithEmailAndPassword(
                      email: Email,
                      password: Password,
                    );
                    // ログインに成功した場合
                    final User user = result.user!;
                    setState(() {
                      infoText = "ログインOK：${user.email}";
                    });
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context){
                          return PostPage(auth.currentUser!.uid);
                        })
                    );
                  } catch (e) {
                    // ログインに失敗した場合
                    setState(() {
                      infoText = "ログインNG：${e.toString()}";
                    });
                  }
                },
                child: const Text("Login"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orangeAccent, //ボタンの背景色
                ),
              ),
              const SizedBox(height: 8),
              Text(infoText),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return RegisterPage();
                      })
                  );
                },
                child: const Text(
                  'AccountRegister',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //pickerは要修正
  void _showModalPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery
              .of(context)
              .size
              .height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _items.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedItemChanged,
            ),
          ),
        );
      },
    );
  }

  String _selectedItem = 'Teacher or Student';

  final List<String> _items = [
    'Teacher',
    'Student',
  ];

  Widget _pickerItem(String str) {
    return Text(
      str,
      style: const TextStyle(fontSize: 32),
    );
  }

  void _onSelectedItemChanged(int index) {
    setState(() {
      _selectedItem = _items[index];
    });
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
}