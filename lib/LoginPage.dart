import 'package:flutter/material.dart';
import 'package:flutter_app/Enums.dart';
import 'package:flutter_app/Event.dart';
import 'package:flutter_app/InstanceProvider.dart';
import 'package:flutter_app/User.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: LoginBody(),
    );
  }
}

class LoginBody extends StatelessWidget {
  Entrys entrys = Entrys();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: InstanceProvider().stateBloc.userState,
      builder: (context, AsyncSnapshot<MyUser> snapshot) {
        if (snapshot.data == null) {
          return Container(
            child: Text('1'),
          );
        } else {
          Entrys().setERRORTEXT(snapshot.data.error);
          switch (snapshot.data.authStatus) {
            case AuthStatus.NOT_DETERMINED:
              return UIElements(snapshot);
              break;
            case AuthStatus.LOGING_IN:
              return Loading();
              break;
            case AuthStatus.FAILED:
              return UIElements(snapshot);
              break;
            case AuthStatus.LOGED_IN:
              Navigator.pushNamed(context, 'testPage');
              break;
            default:
              return Container();
          }
        }
      },
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[CircularProgressIndicator()],
    );
  }
}

class UIElements extends StatelessWidget {
  AsyncSnapshot<MyUser> snapshot;

  UIElements(this.snapshot);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          autovalidate: true,
          initialValue: Entrys().getEMAIL(),
          validator: (val) {
            Entrys().setEMAIL(val);
          },
          decoration: InputDecoration(hintText: 'Email'),
        ),
        TextFormField(
          autovalidate: true,
          initialValue: Entrys().getPASSWORD(),
          validator: (val) {
            Entrys().setPASSWORD(val);
          },
          decoration: InputDecoration(hintText: 'Password'),
        ),
        RaisedButton(
          child: Text('LogIn'),
          onPressed: () {
            InstanceProvider().stateBloc.authStatusEvent.add(LogInEvent(
                email: Entrys().getPASSWORD(),
                password: Entrys().getPASSWORD()));
          },
        )
      ],
    );
  }
}

class Entrys {
  static final Entrys _singleton = Entrys._internal();

  String _email;
  String _password;
  String _errorMessage;

  factory Entrys() {
    return _singleton;
  }

  Entrys._internal() {
    _email = '';
    _password = '';
    _errorMessage = '';
  }

  String getEMAIL() {
    return _email;
  }

  String getPASSWORD() {
    return _password;
  }

  String getERRORTEXT() {
    return _errorMessage;
  }

  void setEMAIL(String email) {
    _email = email;
  }

  void setPASSWORD(String password) {
    _password = password;
  }

  void setERRORTEXT(String errrorMessage) {
    _errorMessage = errrorMessage;
  }
}
