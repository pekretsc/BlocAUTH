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

class PWChacngeEvent extends Event {}