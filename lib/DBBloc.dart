import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Enums.dart';
import 'package:flutter_app/Event.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class DBBloc {
  var _state = DBState.Done;
  var _instance = Firestore.instance;
  String value = 'Hallo';

  final _StateController = BehaviorSubject<DBState>();
  StreamSink<DBState> get _inBlockResource {
    return _StateController.sink;
  }

  // For state, exposing only a stream which outputs data
  Stream<DBState> get BlockResource {
    return _StateController.stream;
  }

  final _BlockResourceEventController = StreamController<Event>();
  // For events, exposing only a sink which is an input
  Sink<Event> get XEventSink => _BlockResourceEventController.sink;

  DBBloc() {
    _inBlockResource.add(_state);
    _BlockResourceEventController.stream.listen(_mapEventToState);
  }
  void refreshState({@required DBState newState}) {
    _state = newState;
    _inBlockResource.add(_state);
  }

  void _setValue(String newValue) {
    this.value = newValue;
  }

  void _mapEventToState(Event event) async {
    if (event is DBAddEvent) {
      _setValue('ADDEvent');
      _state = DBState.Working;
    }
    if (event is DBDeleteEvent) {
      _state = DBState.Done;
    }
    if (event is DBUpdateStringEvent) {
      refreshState(newState: DBState.Working);
      await _changeStringValueOfDoc(
              collectionName: event.collectionName,
              documentName: event.docName,
              keyOfValue: event.keyOfValue,
              newValue: event.newString)
          .then((_) {
        value = event.newString;
        refreshState(newState: DBState.Done);
      });
    }

    if (event is DBUpdateIntEvent) {
      refreshState(newState: DBState.Working);
      await _changeIntValueOfDoc(
              collectionName: event.collectionName,
              documentName: event.docName,
              keyOfValue: event.keyOfValue,
              newValue: event.newNumber)
          .then((_) {
        value = event.newNumber.toString();
        refreshState(newState: DBState.Done);
      });
    }

    if (event is DBUpdateDoubleEvent) {
      refreshState(newState: DBState.Working);
      await _changeDoubleValueOfDoc(
              collectionName: event.collectionName,
              documentName: event.docName,
              keyOfValue: event.keyOfValue,
              newValue: event.newNumber)
          .then((_) {
        value = event.newNumber.toString();
        refreshState(newState: DBState.Done);
      });
    }

    if (event is DBGetSpecificValueEvent) {
      refreshState(newState: DBState.Working);
      String newValue = await _getSpecificStringValueFromDocument(
          collectionName: event.collectionName,
          documentName: event.docName,
          keyOfValue: event.keyOfValue);
      if (newValue != '') {
        value = newValue;
        refreshState(newState: DBState.Done);
      }
    }

    if (event is DBUpdateMapValueSpecificEventEvent) {
      refreshState(newState: DBState.Working);
      await _mapChangeValueInMap(
              collectionName: event.collectionName,
              documentName: event.docName,
              keyOfValue: event.keyOfValue,
              mapKeyVal: event.mapValueKey,
              newValue: event.newValue)
          .then((_) {
        value = 'true';
        refreshState(newState: DBState.Done);
      });
    }

    if (event is DBUpdateMapValuesEventEvent) {
      refreshState(newState: DBState.Working);
    }

    if (event is DBToggleBoolEvent) {
      refreshState(newState: DBState.Working);
      await _toogleBoolean(
        collectionName: event.collectionName,
        documentName: event.docName,
        keyOfValue: event.keyOfValue,
      ).then((_) {
        value = 'true';
        refreshState(newState: DBState.Done);
      });
    }
    //ToDO Manipulate BlockResource here based on event

    _inBlockResource.add(_state);
  }

  void dispose() {
    _StateController.close();
    _BlockResourceEventController.close();
  }

  Future<DocumentSnapshot> _getSpecificDocument(
      {@required String collectionName, @required String documentName}) async {
    try {
      DocumentSnapshot doc = await _instance
          .collection(collectionName)
          .document(documentName)
          .get()
          .catchError((error) {
        print(error.message);
        print(error.toString());
      });
      if (doc == null)
        return null;
      else
        return doc;
    } catch (e) {
      print('fail getDoc');
      return null;
    }
  }

  Future<String> _getSpecificStringValueFromDocument(
      {@required String collectionName,
      @required String documentName,
      @required String keyOfValue}) async {
    try {
      DocumentSnapshot doc = await _getSpecificDocument(
              collectionName: collectionName, documentName: documentName)
          .catchError((error) {
        print(error.message);
        print(error.toString());
      });
      String docValue = doc.data[keyOfValue] as String;
      print(docValue);
      return docValue;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  Future<void> _changeStringValueOfDoc(
      {@required String collectionName,
      @required String documentName,
      @required String keyOfValue,
      @required String newValue}) async {
    try {
      final DocumentReference postRef =
          _instance.collection(collectionName).document(documentName);
      _instance.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        if (postSnapshot.exists) {
          await tx.update(postRef, <String, String>{keyOfValue: newValue});
        }
      }).catchError((error) {
        print(error.message);
        print(error.toString());
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _changeIntValueOfDoc(
      {@required String collectionName,
      @required String documentName,
      @required String keyOfValue,
      @required int newValue}) async {
    try {
      final DocumentReference postRef =
          _instance.collection(collectionName).document(documentName);
      _instance.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        if (postSnapshot.exists) {
          await tx.update(postRef, <String, int>{keyOfValue: newValue});
        }
      }).catchError((error) {
        print(error.message);
        print(error.toString());
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _changeDoubleValueOfDoc(
      {@required String collectionName,
      @required String documentName,
      @required String keyOfValue,
      @required double newValue}) async {
    try {
      final DocumentReference postRef =
          _instance.collection(collectionName).document(documentName);
      _instance.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        if (postSnapshot.exists) {
          await tx.update(postRef, <String, double>{keyOfValue: newValue});
        }
      }).catchError((error) {
        print(error.message);
        print(error.toString());
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _toogleBoolean({
    @required String collectionName,
    @required String documentName,
    @required String keyOfValue,
  }) async {
    bool oldval;
    try {
      final DocumentReference postRef =
          _instance.collection(collectionName).document(documentName);
      _instance.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        if (postSnapshot.exists) {
          oldval = postSnapshot.data[keyOfValue];
          oldval = !oldval;
          await tx.update(postRef, <String, bool>{keyOfValue: oldval});
        }
      }).catchError((error) {
        PlatformException e = error as PlatformException;
        print(e.message);
        print(oldval.toString());
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _mapAddValueInMap(
      {@required String collectionName,
      @required String documentName,
      @required String keyOfValue,
      @required String mapKeyVal,
      @required dynamic newValue}) async {
    final DocumentReference postRef =
        _instance.collection(collectionName).document(documentName);

    _instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);

      if (postSnapshot.exists) {
        try {} catch (error) {
          print(error.message);
          print(error.toString());
        }
        try {} catch (error) {
          print(error.message);
          print(error.toString());
        }
      }
    });
  }

  Future<void> _mapChangeValueInMap(
      {@required String collectionName,
      @required String documentName,
      @required String keyOfValue,
      @required String mapKeyVal,
      @required dynamic newValue}) async {
    try {
      Map<dynamic, dynamic> mapValues;
      final DocumentReference postRef =
          _instance.collection(collectionName).document(documentName);
      _instance.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        if (postSnapshot.exists) {
          try {
            mapValues = postSnapshot.data[keyOfValue];
            mapValues[mapKeyVal] = newValue;
          } catch (error) {
            print(error.message);
            print(error.toString());
          }
          try {
            await tx.update(postRef, <String, Map<dynamic, dynamic>>{
              keyOfValue: mapValues
            }).catchError((error) {
              print(error.message);
              print(error.toString());
            });
          } catch (error) {
            print(error.message);
            print(error.toString());
          }
        }
      }).catchError((error) {
        print(error.message);
        print(error.toString());
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _MapChangeMultipleValuesInMap(
      {@required String collectionName,
      @required String documentName,
      @required String keyOfValue,
      @required Map<String, dynamic> newValues}) async {
    try {
      Map<String, dynamic> mapValues;
      final DocumentReference postRef =
          _instance.collection(collectionName).document(documentName);
      _instance.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        if (postSnapshot.exists) {
          mapValues = postSnapshot.data[keyOfValue];
          mapValues.addAll(newValues);
          await tx.update(
              postRef, <String, Map<String, dynamic>>{keyOfValue: mapValues});
        }
      }).catchError((error) {
        print(error.message);
        print(error.toString());
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
