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
    UserBloc db = UserBloc();
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('FireDBPage'),
        ),
        body: StreamBuilder(
            stream: db.BlockResource,
            builder: (context, AsyncSnapshot<UIInput> snapshot) {
              return ListView.builder(
                  itemCount: snapshot.data.documentText.length,
                  itemBuilder: (context, int index) {
                    return ListTile(
                      title: Text(snapshot.data.documentText[index]),
                      subtitle: Text(snapshot.data.documentText[index]),
                    );
                  });
            }),
        bottomNavigationBar: BottomNavigationBar(items: [
          BottomNavigationBarItem(
              icon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    db.XEventSink.add(DBAddEvent());
                  }),
              title: Text('Add')),
          BottomNavigationBarItem(
              icon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    db.XEventSink.add(DBDeleteEvent());
                  }),
              title: Text('Del')),
        ]));
  }
}
