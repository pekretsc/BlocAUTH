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
      _user.authStatus = AuthStatus.LOGING_IN;
      _inBlockResource.add(_user);
      await logIn(event.email, event.password).catchError((e) {
        _user.error = 'Please enter your mail address and password';
        _user.authStatus = AuthStatus.FAILED;
        _inBlockResource.add(_user);
      });
      print('login');
    }
    if (event is SignInEvent) {
      _user.authStatus = AuthStatus.LOGING_IN;
      _inBlockResource.add(_user);
      signUp(event.email, event.password);
      print('signin verification mail send');
    }
    if (event is PWChacngeEvent) {
      print('pwChange');
    }
    _inBlockResource.add(_user);
  }

  void dispose() {
    _EventController.close();
  }

  Future<void> logIn(String email, String password) async {
    _user.user = await _user.auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      _user.error = e.toString();
      print(e.toString());
      print(e.runtimeType.toString());
      _user.authStatus = AuthStatus.FAILED;
      _inBlockResource.add(_user);
    }).whenComplete(() {
      _user.authStatus = AuthStatus.LOGED_IN;
      _user.auth.currentUser().then((user) {
        _user.isVeryfied = user.isEmailVerified;
      });
      _inBlockResource.add(_user);
    });
  }

  Future<void> signUp(String email, String password) async {
    _user.user = await _user.auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      _user.error = e.toString();
      print(e.toString());
      print(e.runtimeType.toString());
      _user.authStatus = AuthStatus.FAILED;
      _inBlockResource.add(_user);
    }).whenComplete(() {
      _user.authStatus = AuthStatus.LOGED_IN;
      _inBlockResource.add(_user);
      _user.auth.currentUser().then((user) {
        user.sendEmailVerification();
      });
    });
  }

  Future<AuthStatus> changePW(String email, String password) async {
    return AuthStatus.FAILED;
  }
}
