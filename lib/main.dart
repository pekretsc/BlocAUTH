import 'package:flutter/material.dart';
import 'package:flutter_app/FireDBPage.dart';
import 'package:flutter_app/HomePage.dart';
import 'package:flutter_app/InstanceProvider.dart';
import 'package:flutter_app/LoginPage.dart';
import 'package:flutter_app/TestPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  InstanceProvider instanceProvider;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    widget.instanceProvider = InstanceProvider();
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
    return MaterialApp(
      routes: {
        '/': (context) => HomePage(),
        '/testPage': (context) => TestPage(),
        '/FireDBPage': (context) => FireDBPage(),
        '/LoginPage': (context) => LoginPage()
      },
    );
  }
}
