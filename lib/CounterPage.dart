import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/Event.dart';
import 'package:rxdart/rxdart.dart';

class CounterPage extends StatelessWidget {
  CounterBloc _cBloc = CounterBloc();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: StreamBuilder(
          stream: _cBloc.BlockResource,
          builder: (context, AsyncSnapshot<CounterDB> snapshot) {
            //ToDO Snapshot für UI Aufbereiten
            //ToDO Snapshot sollte eine Liste von Counter Objekten sein  die im grunde nur den aktuellen Wert des Counters beinhalten
            //ToDO für jeden index in der liste muss ein Element zur representation des Counters angelegt und angeteigt werden
            List<CounterWidget> counters = createCouters(snapshot);
            return Container(); //ToDO UI anzeigen und mit Datenfüllen
          }),
    );
  }

  List<CounterWidget> createCouters(AsyncSnapshot<CounterDB> snapshot) {
    List<CounterWidget> counters = [];
    if (snapshot.data != null) {}
    return counters;
  }
}

class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}

class CounterBloc {
  CounterDB _conter = CounterDB();

  final _StateController = BehaviorSubject<CounterDB>();
  StreamSink<CounterDB> get _inBlockResource => _StateController.sink;
  // For state, exposing only a stream which outputs data
  Stream<CounterDB> get BlockResource => _StateController.stream;

  final _BlockResourceEventController = StreamController<Event>();
  // For events, exposing only a sink which is an input
  Sink<Event> get XEventSink => _BlockResourceEventController.sink;

  XResource() {
    _inBlockResource.add(_conter);
    //ToDO Init CouterDB
    // Whenever there is a new event, we want to map it to a new state
    _BlockResourceEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(Event event) {
    if (event is LoadCounterDBEvent) {
      //ToDO reload CouterDB
    }
    if (event is AddCounterToDBEvent) {}
    if (event is DeleteCounterToDBEvent) {}
    _inBlockResource.add(_conter);
  }

  void dispose() {
    _StateController.close();
    _BlockResourceEventController.close();
  }
}

class CounterDB {
  List<Counter> counterList = [];
}

class Counter {
  int counter;
  int id;
  Counter() {
    refresh();
  }
  Future<void> refresh() {}
}
