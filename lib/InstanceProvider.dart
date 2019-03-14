import 'package:flutter_app/Bloc.dart';

class InstanceProvider {
  StateBloc stateBloc;
  int rebuild = 0;

  static final InstanceProvider _singleton = InstanceProvider._internal();

  factory InstanceProvider() {
    return _singleton;
  }

  InstanceProvider._internal() {
    stateBloc = StateBloc();
  }
}
