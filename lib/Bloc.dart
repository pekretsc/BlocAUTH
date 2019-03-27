import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/Enums.dart';
import 'package:flutter_app/Event.dart';
import 'package:flutter_app/User.dart';
import 'package:rxdart/rxdart.dart';

class StateBloc {
  MyUser _user = MyUser(auth: FirebaseAuth.instance);

  final _StateController = BehaviorSubject<MyUser>();
  StreamSink<MyUser> get _inBlockResource => _StateController.sink;
  Stream<MyUser> get userState => _StateController.stream;

  final _EventController = StreamController<Event>();
  Sink<Event> get authStatusEvent => _EventController.sink;

  StateBloc() {
    _inBlockResource.add(_user);
    //print(_inBlockResource.toString()); // NOT NULL ANYMORE
    // Whenever there is a new event, we want to map it to a new state
    _EventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(Event event) async {
    if (event is LogInEvent) {
      _addStatusToStream(AuthStatus.LOGING_IN);
      String s =
          await logIn(event.email, event.password).then((String a) async {
        if (a == '') {
          _user.user = await _user.auth.currentUser();
          if (!_user.user.isEmailVerified) {
            _user.user.sendEmailVerification();
          }
          _addStatusToStream(AuthStatus.LOGED_IN);
        } else {
          _user.error = a;
          _addStatusToStream(AuthStatus.FAILED);
        }
      });
    }
    if (event is SignInEvent) {
      _addStatusToStream(AuthStatus.LOGING_IN);
      String s =
          await signUp(event.email, event.password).then((String a) async {
        if (a == '') {
          _user.user = await _user.auth.currentUser();
          _user.user.sendEmailVerification();
          _addStatusToStream(AuthStatus.LOGED_IN);
        } else {
          _user.error = a;
          _addStatusToStream(AuthStatus.FAILED);
        }
      });
    }
    if (event is PWChacngeEvent) {
      print('pwChange');
      String s = await changePW(event.email);
    }

    _inBlockResource.add(_user);
  }

  void _addStatusToStream(AuthStatus a) {
    _user.authStatus = a;
    _inBlockResource.add(_user);
  }

  void dispose() {
    _EventController.close();
  }

  Future<String> logIn(String email, String password) async {
    print(email);
    print(password);
    try {
      FirebaseUser user = await _user.auth
          .signInWithEmailAndPassword(email: email, password: password);
      return '';
    } on Exception catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<String> signUp(String email, String password) async {
    print(email);
    print(password);
    try {
      FirebaseUser user = await _user.auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return '';
    } on Exception catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<String> changePW(String email) async {
    _user.auth.sendPasswordResetEmail(email: email);
    return 'Please check your Inbox';
  }
}
