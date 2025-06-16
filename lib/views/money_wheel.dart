import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';


class MoneyPage extends StatefulWidget {
  const MoneyPage({super.key});

  @override
  MoneyPageState createState() => MoneyPageState();
}

class MoneyPageState extends State<MoneyPage> {
  late StreamController<int> selected;

  @override
  void initState() {
    super.initState();
    selected = StreamController<int>.broadcast();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  FortuneItemStyle oddStyle = FortuneItemStyle(
    color: Colors.red, // <-- custom circle slice fill color
    borderColor: Colors.white, // <-- custom circle slice stroke color
    borderWidth: 3, // <-- custom circle slice stroke width
  );
  FortuneItemStyle evenStyle = FortuneItemStyle(
    color: Colors.black, // <-- custom circle slice fill color
    borderColor: Colors.white, // <-- custom circle slice stroke color
    borderWidth: 3, // <-- custom circle slice stroke width
  );
  FortuneItemStyle wStyle20 = FortuneItemStyle(
    color: Colors.green, // <-- custom circle slice fill color
    borderColor: Colors.white, // <-- custom circle slice stroke color
    borderWidth: 3, // <-- custom circle slice stroke width
  );
  FortuneItemStyle wStyle50 = FortuneItemStyle(
    color: Colors.blueAccent, // <-- custom circle slice fill color
    borderColor: Colors.white, // <-- custom circle slice stroke color
    borderWidth: 3, // <-- custom circle slice stroke width
  );
  FortuneItemStyle wStyle100 = FortuneItemStyle(
    color: Colors.redAccent, // <-- custom circle slice fill color
    borderColor: Colors.white, // <-- custom circle slice stroke color
    borderWidth: 3, // <-- custom circle slice stroke width
  );
  FortuneItemStyle wStyle500 = FortuneItemStyle(
    color: Colors.purpleAccent, // <-- custom circle slice fill color
    borderColor: Colors.white, // <-- custom circle slice stroke color
    borderWidth: 3, // <-- custom circle slice stroke width
  );
  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Crab Fish: Bonus Wheel'
            ''),
      ),
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return portrait(context);
    } else {
      return landscape(context);
    }
  }

  Widget portrait(BuildContext context) {
    return Column(children: <Widget>[


      Expanded(
        flex: 1,
        child: fWheelPT(context),
      ),
    ]);
  }

  Widget landscape(BuildContext context) {
    return Row(children: <Widget>[

      Expanded(
        flex: 2,
        child: fWheelLS(context),
      ),
    ]);
  }

  Widget fWheelPT(BuildContext context) {
    final items = <String>[
      '100',
      '20',
      '50',
      '20',
      '100',
      '20',
      '50',
      '20',
      '50',
      '20',
      '500',
      '20',
      '50',
      '20',
      '100',
      '20',
      '50',
      '20',
      '50',
      '20',
    ];

    int returnVal = 0;

    return
      GestureDetector(
        onTap: () {
          setState(() {

            returnVal = Fortune.randomInt(0, items.length);
            if (kDebugMode) {
              print("====> random val2:$returnVal");
            }

            selected.add(
              returnVal,
            );

          });
        },
        child: Column(
          children: [
            Expanded(
              child: FortuneWheel(
                selected: selected.stream,
                items: [
                  FortuneItem(child: Text('0'), style: evenStyle),
                  FortuneItem(child: Text('20'), style: wStyle20),
                  FortuneItem(child: Text('50'), style: wStyle50),
                  FortuneItem(child: Text('20'), style: wStyle20),
                  FortuneItem(child: Text('100'), style: wStyle100),
                  FortuneItem(child: Text('20'), style: wStyle20),
                  FortuneItem(child: Text('50'), style: wStyle50),
                  FortuneItem(child: Text('20'), style: wStyle20),
                  FortuneItem(child: Text('50'), style: wStyle50),
                  FortuneItem(child: Text('20'), style: wStyle20),
                  FortuneItem(child: Text('500'), style: wStyle500),
                  FortuneItem(child: Text('20'), style: wStyle20),
                  FortuneItem(child: Text('50'), style: wStyle50),
                  FortuneItem(child: Text('20'), style: wStyle20),
                  FortuneItem(child: Text('100'), style: wStyle100),
                  FortuneItem(child: Text('20'), style: wStyle20),
                  FortuneItem(child: Text('50'), style: wStyle50),
                  FortuneItem(child: Text('20'), style: wStyle20),
                  FortuneItem(child: Text('50'), style: wStyle50),
                  FortuneItem(child: Text('20'), style: wStyle20),
                ],
              ),
            ),
          ],
        ),

    );
  }

  Widget fWheelLS(BuildContext context) {
    final items = <String>[
      '100',
      '20',
      '50',
      '20',
      '100',
      '20',
      '50',
      '20',
      '50',
      '20',
      '500',
      '20',
      '50',
      '20',
      '100',
      '20',
      '50',
      '20',
      '50',
      '20',
    ];

    int returnVal = 0;

    return
      GestureDetector(
        onTap: () {
          setState(() {

            returnVal = Fortune.randomInt(0, items.length);
            if (kDebugMode) {
              print("====> random val2:$returnVal");
            }

            selected.add(
              returnVal,
            );

          });
        },
        child: Column(
          children: [
            Expanded(
              child: FortuneWheel(
                selected: selected.stream,
                items: [
                  FortuneItem(child: Text('0'), style: evenStyle),
                  FortuneItem(child: Text('20'), style: wStyle20),
                  FortuneItem(child: Text('50'), style: wStyle50),
                  FortuneItem(child: Text('20'), style: wStyle20),
                  FortuneItem(child: Text('100'), style: wStyle100),
                  FortuneItem(child: Text('20'), style: wStyle20),
                  FortuneItem(child: Text('50'), style: wStyle50),
                  FortuneItem(child: Text('20'), style: wStyle20),
                  FortuneItem(child: Text('50'), style: wStyle50),
                  FortuneItem(child: Text('20'), style: wStyle20),
                  FortuneItem(child: Text('500'), style: wStyle500),
                  FortuneItem(child: Text('20'), style: wStyle20),
                  FortuneItem(child: Text('50'), style: wStyle50),
                  FortuneItem(child: Text('20'), style: wStyle20),
                  FortuneItem(child: Text('100'), style: wStyle100),
                  FortuneItem(child: Text('20'), style: wStyle20),
                  FortuneItem(child: Text('50'), style: wStyle50),
                  FortuneItem(child: Text('20'), style: wStyle20),
                  FortuneItem(child: Text('50'), style: wStyle50),
                  FortuneItem(child: Text('20'), style: wStyle20),
                ],
              ),
            ),
          ],
        ),
      );
  }




  String fixNum(int numToFix) {
    String tempString = numToFix.toString();

    if (numToFix < 10)
    {
      tempString = '0$tempString';
    }

    return tempString;
  }

}
