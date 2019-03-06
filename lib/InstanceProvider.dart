import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/Bloc.dart';
import 'package:meta/meta.dart';

class InstanceProvider {
  FirebaseAuth _auth;
  FirebaseUser _firebaseUser;
  StateBloc stateBloc;
  int rebuild = 0;

  static final InstanceProvider _singleton = InstanceProvider._internal();

  factory InstanceProvider() {
    return _singleton;
  }

  InstanceProvider._internal() {
    stateBloc = StateBloc();
    _auth = FirebaseAuth.instance;
  }

  String getAUTHString() {
    return _auth.toString();
  }
}

class User {
  FirebaseUser firebaseUser;
  String username;
  String userID;
  String email;

  User({@required this.firebaseUser}) {
    username = firebaseUser.email;
    userID = firebaseUser.uid;
    email = firebaseUser.email;
  }
}
