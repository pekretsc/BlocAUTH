import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/Enums.dart';
import 'package:flutter_app/Event.dart';
import 'package:rxdart/rxdart.dart';

class CounterBloc {
  CounterDB _conter = CounterDB();

  final _StateController = BehaviorSubject<CounterDB>();
  StreamSink<CounterDB> get _inBlockResource => _StateController.sink;
  // For state, exposing only a stream which outputs data
  Stream<CounterDB> get BlockResource => _StateController.stream;

  final _BlockResourceEventController = StreamController<Event>();
  // For events, exposing only a sink which is an input
  Sink<Event> get XEventSink => _BlockResourceEventController.sink;

  CounterBloc() {
    _conter.dbStream.listen((_) {
      refresh();
    });
    //ToDO Init CouterDB
    // Whenever there is a new event, we want to map it to a new state
    _BlockResourceEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(Event event) {
    if (event is LoadCounterDBEvent) {
      refresh();
    }
    if (event is AddCounterToDBEvent) {
      refresh();
    }
    if (event is DeleteCounterToDBEvent) {
      refresh();
    }
    if (event is AddEvent) {
      addOneToCounter(event.docID);
    }
    if (event is SubEvent) {}
  }

  void dispose() {
    _StateController.close();
    _BlockResourceEventController.close();
  }

  void refresh() async {
    _inBlockResource.add(_conter);
  }

  void addOneToCounter(String docID) async {
    _conter.addOne(docID).then((_) {
      _inBlockResource.add(_conter);
    });
    _inBlockResource.add(_conter);
  }
}

class CounterDB {
  List<DocumentSnapshot> counterDocs = [];
  List<Counter> counterList = [];
  Firestore db = Firestore.instance;
  Stream<QuerySnapshot> dbStream;

  final _StateController = BehaviorSubject<UIState>();
  StreamSink<UIState> get _inBlockResource => _StateController.sink;
  // For state, exposing only a stream which outputs data
  Stream<UIState> get BlockResource => _StateController.stream;

  UIState uiState;
  CounterDB() {
    uiState = UIState.NOT_DETERMINED;
    refresh();
    dbStream = db.collection('Counter').snapshots().asBroadcastStream();
  }

  Future<void> refresh() async {
    counterDocs = [];
    counterList = [];
    QuerySnapshot counterCollection =
        await db.collection('Counter').getDocuments().then((snapshot) {
      counterDocs = snapshot.documents;
      counterDocs.forEach((DocumentSnapshot doc) {
        counterList.add(Counter(doc));
      });
    });
  }

  Future<void> addNewCounterToDB() {
    db.runTransaction((Transaction add) async {
      CollectionReference r = db.collection('Counter');
      await r.add({
        'Counter': 0,
        'DateTimeOfCreation': DateTime.now().millisecondsSinceEpoch
      }).then((_) {
        refresh();
      });
    });
  }

  Future<void> addOne(String docID) {
    //ToDO finde richtiges Doc
    //ToDO lese alten wert aus
    //ToDO schreibe neuen wert in doc

    db
        .collection('Counter')
        .document(docID)
        .get()
        .then((DocumentSnapshot snap) {
      int counterVal;
      if (snap.data.containsKey('Counter')) {
        db.runTransaction((Transaction tx) async {
          DocumentSnapshot postSnapshot = await tx.get(snap.reference);
          if (postSnapshot.exists) {
            await tx.update(snap.reference, <String, dynamic>{
              'Counter': postSnapshot.data['Counter'] + 1
            }).then((_) {
              print('Added');
            });
          }
        });
      }
    });
  }
}

class Counter {
  int counter;
  int id;
  String docKey;

  Counter(DocumentSnapshot doc) {
    counter = doc.data['Counter'];
    id = doc.data['DateTimeOfCreation'];
    docKey = doc.reference.documentID;
  }
}
