import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('TestPage'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: GridView.count(
                crossAxisCount: 2,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  Text('1'),
                  Text('10'),
                  Text('100'),
                  Text('100'),
                  Text('10'),
                  Text('10'),
                  Text('100'),
                  Text('100'),
                  Text('10000'),
                  Text('10000'),
                  Text('100'),
                  Text('100'),
                  Text('14'),
                  Text('61'),
                  Text('16'),
                  Text('18'),
                  Text('19'),
                  Text('133'),
                  Text('341'),
                  Text('51'),
                  Text('561'),
                  Text('1'),
                  Text('156'),
                  Text('1'),
                  Text('61'),
                  Text('1'),
                  Text('173'),
                  Text('123'),
                  Text('51'),
                  Text('16'),
                  Text('1'),
                  Text('165'),
                  Text('17'),
                  Text('1'),
                  Text('761'),
                  Text('1'),
                  Text('16'),
                  Text('1'),
                  Text('761'),
                  Text('1'),
                  Text('1'),
                  Text('176'),
                  Text('1'),
                  Text('167'),
                  Text('1'),
                  Text('13'),
                  Text('1'),
                  Text('341'),
                  Text('1'),
                  Text('61'),
                  Text('671'),
                  Text('1'),
                  Text('431'),
                  Text('1'),
                  Text('156'),
                  Text('31'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
