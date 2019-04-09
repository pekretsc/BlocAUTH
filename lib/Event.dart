import 'package:meta/meta.dart';

abstract class Event {}

class LogInEvent extends Event {
  String email;
  String password;
  LogInEvent({@required this.email, @required this.password});
}

class SignInEvent extends Event {
  String email;
  String password;
  SignInEvent({@required this.email, @required this.password});
}

class PWChacngeEvent extends Event {
  String email;
  PWChacngeEvent({@required this.email});
}

class DBAddEvent extends Event {}

class DBChangeEvent extends Event {}

class DBGetEvent extends Event {}

class DBGetSpecificValueEvent extends Event {
  String docName;
  String keyOfValue;
  String collectionName;
  DBGetSpecificValueEvent(
      {@required this.collectionName,
      @required this.docName,
      @required this.keyOfValue});
}

class DBUpdateStringEvent extends Event {
  String docName;
  String keyOfValue;
  String collectionName;
  String newString;
  DBUpdateStringEvent(
      {@required this.collectionName,
      @required this.docName,
      @required this.keyOfValue,
      @required this.newString});
}

class DBUpdateIntEvent extends Event {
  String docName;
  String keyOfValue;
  String collectionName;
  int newNumber;
  DBUpdateIntEvent(
      {@required this.collectionName,
      @required this.docName,
      @required this.keyOfValue,
      @required this.newNumber});
}

class DBUpdateDoubleEvent extends Event {
  String docName;
  String keyOfValue;
  String collectionName;
  double newNumber;
  DBUpdateDoubleEvent(
      {@required this.collectionName,
      @required this.docName,
      @required this.keyOfValue,
      @required this.newNumber});
}

class DBUpdateMapValueSpecificEventEvent extends Event {
  String docName;
  String keyOfValue;
  String mapValueKey;
  String collectionName;
  dynamic newValue;
  DBUpdateMapValueSpecificEventEvent({
    @required this.collectionName,
    @required this.docName,
    @required this.keyOfValue,
    @required this.newValue,
    @required this.mapValueKey,
  });
}

class DBUpdateMapValuesEventEvent extends Event {
  String docName;
  String keyOfValue;
  String collectionName;
  Map<String, dynamic> newValues;
  DBUpdateMapValuesEventEvent({
    @required this.collectionName,
    @required this.docName,
    @required this.keyOfValue,
    @required this.newValues,
  });
}

class DBToggleBoolEvent extends Event {
  String docName;
  String keyOfValue;
  String collectionName;

  DBToggleBoolEvent({
    @required this.collectionName,
    @required this.docName,
    @required this.keyOfValue,
  });
}

class DBDeleteEvent extends Event {}

class LoadCounterDBEvent extends Event {}

class AddCounterToDBEvent extends Event {}

class DeleteCounterToDBEvent extends Event {}

class AddEvent extends Event {
  String docID;
  AddEvent(this.docID);
}

class SubEvent extends Event {
  String docID;
  SubEvent(this.docID);
}
