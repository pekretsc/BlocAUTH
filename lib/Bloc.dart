import 'dart:async';
import 'package:flutter_app/Authentification.dart';
import 'package:flutter_app/Enums.dart';
import 'package:flutter_app/Event.dart';
import 'package:rxdart/rxdart.dart';

class StateBloc {
  FireBaseAuth _auth = FireBaseAuth();
  AuthStatus _authStatus;

  final _StateController = BehaviorSubject<AuthStatus>();
  StreamSink<AuthStatus> get _inBlockResource => _StateController.sink;
  // For state, exposing only a stream which outputs data
  Stream<AuthStatus> get authStatusSnap => _StateController.stream;

  final _EventController = StreamController<Event>();
  // For events, exposing only a sink which is an input
  Sink<Event> get authStatusEvent => _EventController.sink;

  StateBloc() {
    _authStatus = AuthStatus.NOT_DETERMINED;
    _inBlockResource.add(_authStatus);
    print(_inBlockResource.toString()); // NOT NULL ANYMORE
    // Whenever there is a new event, we want to map it to a new state
    _EventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(Event event) {
    if (event is LogInEvent) {
      _authStatus = AuthStatus.LOGING_IN;
      //ToDO Future login -> set AuthState to LogedIN on success or fail on Fail
      authaction(event.email, event.password);
      print('login');
    }
    if (event is SignInEvent) {
      // _authStatus = signIN();
      _authStatus = AuthStatus.SIGNED_IN_NOTVERYFIED;
      print('signin');
    }
    if (event is PWChacngeEvent) {
      // _authStatus = pwChange();

      _authStatus = AuthStatus.FAILED;
      print('pwChange');
    }

    _inBlockResource.add(_authStatus);
  }

  void dispose() {
    _StateController.close();
    _EventController.close();
  }

  Future<void> authaction(String email, String password) async {
    _auth.signIn(email, password).whenComplete(() {
      _authStatus = AuthStatus.LOGED_IN;
      _inBlockResource.add(_authStatus);
    }).catchError((e) {
      print(e.toString());
      print(e.code);
      print(e.message);
      _authStatus = AuthStatus.FAILED;
      _inBlockResource.add(_authStatus);
    });
  }

  Future<AuthStatus> signUp(Future<String> signIn) async {
    signIn.whenComplete(() {
      return AuthStatus.LOGED_IN;
    });
    return AuthStatus.LOGING_IN;
  }
}
