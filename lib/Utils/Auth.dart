import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Auth {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User? currentFirebaseUser;

  // Auth登録
  static Future<dynamic> signUp({required String email,  required String password}) async {
    try {
      UserCredential newAccount =  await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      print('auth登録完了');
      return newAccount;
    } on FirebaseAuthException catch (e) {
      print('auth登録失敗');
      return false;
    }
  }

  //サインイン処理
  static Future<dynamic> signIn({required String email,  required String password}) async {
    try {
      // メール/パスワードでログイン
      final UserCredential _result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      currentFirebaseUser = _result.user;
      // ログインに成功した場合
     print('Authサインイン成功');
     return true;
    } catch (e) {
      // ログインに失敗した場合
      print('Autuサインエラー: $e');
      return false;
    }
  }

}