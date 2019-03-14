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

class LoginBody extends StatefulWidget {
  String email;
  String password;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginBodyState();
  }
}

class _LoginBodyState extends State<LoginBody> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

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
          switch (snapshot.data.authStatus) {
            case AuthStatus.NOT_DETERMINED:
              return UIElements(widget, snapshot);
              break;
            case AuthStatus.LOGING_IN:
              return Loading();
              break;
            case AuthStatus.FAILED:
              return UIElements(widget, snapshot);
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
  LoginBody body;
  AsyncSnapshot<MyUser> snapshot;

  UIElements(this.body, this.snapshot);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          initialValue: body.email,
          validator: (val) {
            body.email = val;
          },
          decoration: InputDecoration(hintText: 'Email'),
        ),
        TextFormField(
          initialValue: body.password,
          validator: (val) {
            body.password = val;
          },
          decoration: InputDecoration(hintText: 'Password'),
        ),
        RaisedButton(
          child: Text('LogIn'),
          onPressed: () {
            InstanceProvider()
                .stateBloc
                .authStatusEvent
                .add(LogInEvent(email: body.email, password: body.password));
          },
        )
      ],
    );
  }
}
