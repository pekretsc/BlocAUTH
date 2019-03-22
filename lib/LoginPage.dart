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
              return GhostNavigator();
              break;
            default:
              return Container();
          }
        }
      },
    );
  }
}

class GhostNavigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GhostNavigator();
  }
}

class _GhostNavigator extends State<GhostNavigator> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => callNavigator(context));
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
    return Container();
  }

  void callNavigator(BuildContext context) {
    Navigator.pushNamed(context, '/FireDBPage');
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(
          backgroundColor: Colors.transparent,
        )
      ],
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
            if (!RegExp(
                    r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9][a-zA-Z0-9-]{0,253}\.)*[a-zA-Z0-9][a-zA-Z0-9-]{0,253}\.[a-zA-Z0-9]{2,}$")
                .hasMatch(val)) return 'Email not Valid';
          },
          decoration: InputDecoration(hintText: 'Email'),
        ),
        TextFormField(
          obscureText: true,
          autovalidate: true,
          initialValue: Entrys().getPASSWORD(),
          validator: (val) {
            Entrys().setPASSWORD(val);
            if (val.length < 6) {
              return 'password is to short';
            }
          },
          decoration: InputDecoration(hintText: 'Password'),
        ),
        RaisedButton(
          child: Text('LogIn'),
          onPressed: () {
            InstanceProvider().stateBloc.authStatusEvent.add(LogInEvent(
                email: Entrys().getEMAIL(), password: Entrys().getPASSWORD()));
          },
        ),
        RaisedButton(
          child: Text('SignIn'),
          onPressed: () {
            InstanceProvider().stateBloc.authStatusEvent.add(SignInEvent(
                email: Entrys().getEMAIL(), password: Entrys().getPASSWORD()));
//            showDialog(
//                context: context,
//                builder: (context) {
//                  return SignInDialog();
//                  });
          },
        )
      ],
    );
  }
}

class SignInDialog extends StatefulWidget {
  String newPassword = '';
  String errorMessage = '';
  bool enable = false;
  Color color = Colors.transparent;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignInDialogState();
  }
}

class _SignInDialogState extends State<SignInDialog> {
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
    return Container(
      child: Card(
        margin: EdgeInsets.all(100),
        child: Column(
          children: <Widget>[
            TextFormField(
              obscureText: true,
              autovalidate: true,
              onEditingComplete: () {
                if (widget.newPassword != Entrys().getPASSWORD()) {
                  widget.enable = false;
                }
                if (widget.newPassword == Entrys().getPASSWORD()) {
                  widget.enable = true;
                  widget.color = Colors.blueGrey;
                }
              },
              validator: (val) {
                widget.newPassword = val;
                if (val != Entrys().getPASSWORD()) {
                  widget.enable = false;
                  return 'passwords do not match';
                }
                if (val == Entrys().getPASSWORD()) {
                  widget.enable = true;
                  widget.color = Colors.blueGrey;
                  return '';
                }
              },
              decoration: InputDecoration(hintText: 'Password'),
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  color: widget.color,
                  child: Text('SignIn'),
                  onPressed: () {
                    if (widget.enable) {
                      if (widget.newPassword == Entrys().getPASSWORD()) {
                        InstanceProvider().stateBloc.authStatusEvent.add(
                            SignInEvent(
                                email: Entrys().getEMAIL(),
                                password: Entrys().getPASSWORD()));
                        Navigator.pop(context);
                      } else {
                        widget.errorMessage =
                            'confirmed passwords do not match';
                      }
                    }
                  },
                ),
                RaisedButton(
                    child: Text('Cancle'),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
          ],
        ),
      ),
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
