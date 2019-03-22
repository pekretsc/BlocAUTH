import 'package:flutter/material.dart';
import 'package:flutter_app/DBBloc.dart';
import 'package:flutter_app/Event.dart';

class FireDBPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FireDBPageState();
  }
}

class _FireDBPageState extends State<FireDBPage> {
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
    DBBloc db = DBBloc();
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('FireDBPage'),
        ),
        body: StreamBuilder(
            stream: db.BlockResource,
            builder: (context, AsyncSnapshot snapshot) {
              String text = 'Text';
              if (snapshot.data != null) {
                text = snapshot.data.toString();
              }
              return Column(
                children: <Widget>[
                  Text('$text'),
                  RaisedButton(
                    child: Text('Add Document'),
                    onPressed: () {
                      db.XEventSink.add(DBAddEvent());
                    },
                  ),
                  RaisedButton(
                    child: Text('Change Document'),
                    onPressed: () {
                      db.XEventSink.add(DBChangeEvent());
                    },
                  ),
                  RaisedButton(
                    child: Text('Get Document'),
                    onPressed: () {
                      db.XEventSink.add(DBGetEvent());
                    },
                  ),
                  RaisedButton(
                    child: Text('Delete Document'),
                    onPressed: () {
                      db.XEventSink.add(DBDeleteEvent());
                    },
                  ),
                ],
              );
            }));
  }
}
