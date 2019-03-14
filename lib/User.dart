import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/Enums.dart';

class MyUser {
  FirebaseUser user;
  FirebaseAuth auth;
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  bool isVeryfied = false;
  String error = '';

  MyUser({this.auth});

  Future<FirebaseUser> getUser() async {
    return await auth.currentUser().catchError((e) {
      print('GetUserFail');
    });
  }
}
