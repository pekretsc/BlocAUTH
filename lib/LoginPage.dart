import 'package:flutter/material.dart';
import 'package:flutter_app/Event.dart';
import 'package:flutter_app/InstanceProvider.dart';

class LoginPage extends StatefulWidget {
  String email;
  String password;
  String rePassword;

  int rebuild = 0;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
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
    return Material(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'LoginPage',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: StreamBuilder(
            stream: InstanceProvider().stateBloc.authStatusSnap,
            builder: (context, snapshot) {
              widget.rebuild++;
              print(widget.rebuild);
              return Form(
                autovalidate: true,
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Email'),
                        initialValue: '',
                        validator: (value) {
                          print(snapshot.data.toString());
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Pasword'),
                        initialValue: '',
                        validator: (value) {
                          print(snapshot.data.toString());
                        },
                      ),
                      FlatButton(
                        onPressed: () {
                          print('test_');
                          InstanceProvider()
                              .stateBloc
                              .authStatusEvent
                              .add(LogInEvent());
                        },
                        child: Text('Login'),
                      ),
                      FlatButton(
                        onPressed: () {
                          print('test_');
                          InstanceProvider()
                              .stateBloc
                              .authStatusEvent
                              .add(SignInEvent());
                        },
                        child: Text('SignUp'),
                      ),
                      FlatButton(
                        onPressed: () {
                          print('test_');
                          InstanceProvider()
                              .stateBloc
                              .authStatusEvent
                              .add(PWChacngeEvent());
                        },
                        child: Text('Reset PW'),
                      ),
                      Text(snapshot.data.toString()),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
