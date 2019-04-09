import 'package:flutter/material.dart';
import 'package:flutter_app/DBBloc.dart';
import 'package:flutter_app/Enums.dart';
import 'package:flutter_app/Event.dart';

class FireDBPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FireDBPageState();
  }
}

class _FireDBPageState extends State<FireDBPage> {
  ScrollController sc = ScrollController();
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
    String newText = '';
    dynamic dynamicValue;
    String keyMapValue = '';
    String mapValueKey = '';
    bool checkBoxval = true;
    Map<String, dynamic> testmap = {
      'String': 'newString',
      'Bool': false,
      'Name': 'newIndex',
      'Number': 9,
      'Double': 3.21
    };
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('FireDBPage'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: sc,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: <Widget>[
                RaisedButton(
                  child: Text('test'),
                  onPressed: () {
                    db.XEventSink.add(DBAddEvent());
                  },
                ),
                RaisedButton(
                  child: Text('test2'),
                  onPressed: () {
                    db.XEventSink.add(DBDeleteEvent());
                  },
                ),
                RaisedButton(
                  child: Text('GetSpecificValue'),
                  onPressed: () {
                    db.XEventSink.add(DBGetSpecificValueEvent(
                        collectionName: 'Counter',
                        docName: '1',
                        keyOfValue: 'Name'));
                  },
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        autovalidate: true,
                        validator: (value) {
                          newText = value;
                        },
                      ),
                      RaisedButton(
                        child: Text('ChageValue'),
                        onPressed: () {
                          db.XEventSink.add(DBUpdateStringEvent(
                            collectionName: 'Counter',
                            docName: '1',
                            keyOfValue: 'String',
                            newString: newText,
                          ));
                        },
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: checkBoxval,
                  tristate: true,
                  onChanged: (_) {
                    checkBoxval = !checkBoxval;
                    db.XEventSink.add(DBToggleBoolEvent(
                      collectionName: 'Counter',
                      docName: '1',
                      keyOfValue: 'Bool',
                    ));
                  },
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Key for Map'),
                        autovalidate: true,
                        validator: (value) {
                          keyMapValue = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Key for Value'),
                        autovalidate: true,
                        validator: (value) {
                          mapValueKey = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'New Value'),
                        autovalidate: true,
                        validator: (value) {
                          dynamicValue = int.parse(value);
                        },
                      ),
                      RaisedButton(
                        child: Text('ChageSpecificValue'),
                        onPressed: () {
                          db.XEventSink.add(DBUpdateMapValueSpecificEventEvent(
                              collectionName: 'Counter',
                              docName: '1',
                              keyOfValue: keyMapValue,
                              mapValueKey: mapValueKey,
                              newValue: dynamicValue));
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Key for Map'),
                        autovalidate: true,
                        validator: (value) {
                          keyMapValue = value;
                        },
                      ),
                      RaisedButton(
                        child: Text('Change Multi Falue and Add new'),
                        onPressed: () {
                          db.XEventSink.add(DBUpdateMapValuesEventEvent(
                              collectionName: 'Counter',
                              docName: '1',
                              keyOfValue: 'MapIn',
                              newValues: {
                                'String': 'newString',
                                'NewNumber': 9,
                                'OldNumber': 8,
                              }));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: db.BlockResource,
            builder: (context, AsyncSnapshot<DBState> snapshot) {
              switch (snapshot.data) {
                case DBState.Working:
                  return Loading();
                  break;
                case DBState.Done:
                  return Container(
                      width: double.infinity,
                      height: 50,
                      color: Colors.blueGrey,
                      child: Center(
                        child: Text(db.value),
                      ));
                  break;
                case DBState.Failed:
                  return Container(
                      width: double.infinity,
                      height: 50,
                      color: Colors.blueGrey,
                      child: Center(
                        child: Text(db.value),
                      ));
                  break;

                default:
                  return Container();
              }
            },
          ),
        ],
      ),
    );
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
