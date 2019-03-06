import 'dart:async';

import 'package:flutter_app/Event.dart';
import 'package:rxdart/rxdart.dart';

enum AuthStatus {
  NOT_DETERMINED,
  LOGED_IN,
  SIGNING_IN,
  FAILED,
  SIGNED_IN_NOTVERYFIED
}

class StateBloc {
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
    _inBlockResource.add(_authStatus); // NOT NULL ANYMORE
    // Whenever there is a new event, we want to map it to a new state
    _EventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(Event event) {
    if (event is LogInEvent) {
      // _authStatus = logIN();
      _authStatus = AuthStatus.LOGED_IN;
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
}
