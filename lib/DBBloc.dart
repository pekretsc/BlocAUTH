import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/Enums.dart';
import 'package:flutter_app/Event.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  var _uiInput = UIInput();

  final _StateController = BehaviorSubject<UIInput>();
  StreamSink<UIInput> get _inBlockResource {
    return _StateController.sink;
  }

  // For state, exposing only a stream which outputs data
  Stream<UIInput> get BlockResource {
    return _StateController.stream;
  }

  final _BlockResourceEventController = StreamController<Event>();
  // For events, exposing only a sink which is an input
  Sink<Event> get XEventSink => _BlockResourceEventController.sink;

  UserBloc() {
    _inBlockResource.add(_uiInput);
    _uiInput._db.listen((QuerySnapshot snapshot) {
      refresh(snapshot.documents);
    });
    _BlockResourceEventController.stream.listen(_mapEventToState);
  }
  void refresh(List<DocumentSnapshot> documents) {
    _uiInput.currentDocs(documents);
    _inBlockResource.add(_uiInput);
  }

  void _mapEventToState(Event event) {
    if (event is DBAddEvent) {
      _uiInput.add();
    }
    if (event is DBDeleteEvent) {
      _uiInput.delete();
    }
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
  Stream<QuerySnapshot> _db = Firestore.instance.collection('User').snapshots();
  List<DocumentSnapshot> _documents;
  List<String> documentText = [];
  @override
  String toString() {
    // TODO: implement toString
    return uiState.toString();
  }

  void currentDocs(List<DocumentSnapshot> documents) {
    try {
      if (documents.length > 0) {
        documents.forEach((DocumentSnapshot d) {
          documentText.add(d.toString());
          documents.add(d);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  add() {
    try {
      Firestore.instance.runTransaction((Transaction transaction) async {
        CollectionReference reference = Firestore.instance.collection('User');
        await reference.add({'titel': '${documentText.length.toString()}user'});
      });
    } catch (e) {
      print(e.toString());
    }
  }

  delete() {
    try {
      Firestore.instance.runTransaction((Transaction transaction) async {
        _documents = Firestore.instance.collection('User').snapshots()
            as List<DocumentSnapshot>;
        await transaction.delete(_documents.last.reference);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  get userStrem {
    return this._db;
  }

  get currentDocuments {
    return _documents;
  }
}
