import 'package:flutter/material.dart';
import 'package:flutter_app/Enums.dart';
import 'package:flutter_app/Event.dart';
import 'package:flutter_app/InstanceProvider.dart';

class LoginPage extends StatefulWidget {
  String email;
  String password;
  String rePassword;
  String test = '';
  AuthStatus _authStatus;

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
    WidgetsBinding.instance
        .addPostFrameCallback((_) => executeAfterWholeBuildProcess(context));
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
    widget.test = '${widget.test} not executed';
    // TODO: implement build
    return Material(
        child: Scaffold(
      appBar: AppBar(
        title: Text('LoginPage'),
      ),
      body: StreamBuilder(
          stream: InstanceProvider().stateBloc.authStatusSnap,
          builder: (context, AsyncSnapshot snapshot) {
            widget._authStatus = snapshot.data;
            widget.rebuild++;
            print(widget._authStatus.toString());
            print(snapshot.data.toString());
            print(widget.rebuild.toString());
            return Column(
              children: <Widget>[
                TextFormField(
                  autovalidate: true,
                  decoration: InputDecoration(hintText: 'Email'),
                  validator: (value) {
                    widget.email = value;
                  },
                ),
                TextFormField(
                  autovalidate: true,
                  obscureText: true,
                  decoration: InputDecoration(hintText: 'Password'),
                  validator: (value) {
                    widget.password = value;
                  },
                ),
                FlatButton(
                    onPressed: () {
                      InstanceProvider().stateBloc.authStatusEvent.add(
                          LogInEvent(
                              email: widget.email, password: widget.password));
                    },
                    child: Text('Login')),
                FlatButton(
                    onPressed: () {
                      InstanceProvider().stateBloc.authStatusEvent.add(
                          SignInEvent(
                              email: widget.email, password: widget.password));
                    },
                    child: Text('SignIn')),
                FlatButton(onPressed: () {}, child: Text('ChangePW')),
              ],
            );
          }),
    ));
  }

  void executeAfterWholeBuildProcess(BuildContext context) {
    print('executeAfterWholeBuildProcess');
  }
}
