import 'dart:async';

import 'package:flutter_app/Enums.dart';
import 'package:flutter_app/Event.dart';
import 'package:rxdart/rxdart.dart';

class DBBloc {
  var _uiInput = UIInput();

  final _StateController = BehaviorSubject<UIInput>();
  StreamSink<UIInput> get _inBlockResource => _StateController.sink;
  // For state, exposing only a stream which outputs data
  Stream<UIInput> get BlockResource => _StateController.stream;

  final _BlockResourceEventController = StreamController<Event>();
  // For events, exposing only a sink which is an input
  Sink<Event> get XEventSink => _BlockResourceEventController.sink;

  DBBloc() {
    _inBlockResource.add(_uiInput);
    // Whenever there is a new event, we want to map it to a new state
    _BlockResourceEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(Event event) {
    if (event is Event)
      //ToDO Manipulate BlockResource here based on event

      _inBlockResource.add(_uiInput);
  }

  void dispose() {
    _StateController.close();
    _BlockResourceEventController.close();
  }
}

class UIInput {
  UIState uiState = UIState.NOT_DETERMINED;

  @override
  String toString() {
    // TODO: implement toString
    return uiState.toString();
  }
}
