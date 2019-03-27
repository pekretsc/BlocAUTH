import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('LoginPage'),
            onPressed: () {
              Navigator.pushNamed(context, '/LoginPage');
            },
          ),
          RaisedButton(
            child: Text('TestPage'),
            onPressed: () {
              Navigator.pushNamed(context, '/testPage');
            },
          ),
          RaisedButton(
            child: Text('FireDBPage'),
            onPressed: () {
              Navigator.pushNamed(context, '/FireDBPage');
            },
          ),
          RaisedButton(
            child: Text('CounterPage'),
            onPressed: () {
              Navigator.pushNamed(context, '/CounterPage');
            },
          ),
        ],
      ),
    );
  }
}
