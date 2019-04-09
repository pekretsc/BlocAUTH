import 'package:flutter/material.dart';
import 'package:flutter_app/CounterBloc.dart';
import 'package:flutter_app/Event.dart';

class CounterPage extends StatelessWidget {
  CounterBloc _cBloc = CounterBloc();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Example 1'),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _cBloc.XEventSink.add(AddCounterToDBEvent());
              }),
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _cBloc.XEventSink.add(LoadCounterDBEvent());
              }),
          IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                _cBloc.XEventSink.add(DeleteCounterToDBEvent());
              }),
        ],
      ),
      body: StreamBuilder(
          stream: _cBloc.BlockResource,
          builder: (context, AsyncSnapshot<CounterDB> snapshot) {
            //ToDO Snapshot für UI Aufbereiten
            //ToDO Snapshot sollte eine Liste von Counter Objekten sein  die im grunde nur den aktuellen Wert des Counters beinhalten
            //ToDO für jeden index in der liste muss ein Element zur representation des Counters angelegt und angeteigt werden
            if (snapshot.hasData) {
              List<Widget> cardList = [];
              snapshot.data.counterList.forEach((c) {
                cardList.add(CounterCard(c, _cBloc));
              });

              return GridView.count(crossAxisCount: 2, children: cardList);
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}

class CounterCard extends StatelessWidget {
  Counter c;
  CounterBloc cBloc;
  CounterCard(
    this.c,
    this.cBloc,
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(c.docKey),
          Text(c.counter.toString()),
          Text(c.id.toString()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    cBloc.XEventSink.add(AddEvent(c.docKey));
                  }),
              IconButton(
                  icon: Icon(Icons.minimize),
                  onPressed: () {
                    cBloc.XEventSink.add(SubEvent(c.docKey));
                  })
            ],
          ),
        ],
      ),
    );
  }
}
