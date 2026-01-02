import 'package:flutter/material.dart';
import '../cf_constants.dart';
import '../widgets/cf_board_widget.dart';
import '../widgets/cf_dice_widget.dart';
import '../widgets/cf_players_widget.dart';
import 'money_wheel.dart';

class CfGamePage extends StatefulWidget {
  const CfGamePage({super.key});

  @override
  State<CfGamePage> createState() => _CFGamePageState();
}

class _CFGamePageState extends State<CfGamePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.gameName),
        actions: [

          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MoneyPage()),
              );
            },
            icon: const Icon(Icons.monetization_on),
            label: const Text('Bonus Wheel'),
          ),
          const SizedBox(width: 8), // Add some spacing

        ],

      ),
      body: gameBody(context),

    );
  }


  Widget gameBody(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return portrait();
    } else {
      return landscape();
    }
  }

  Widget portrait() {
    return
      Center(
        child: Column(
          children: [
            FourImageDisplay(
            ),

            Expanded(
              flex: 1,
              child:
              CfBoardWidget(
                imagePaths: [
                  Constants.cfFaces[0],
                  Constants.cfFaces[1],
                  Constants.cfFaces[2],
                  Constants.cfFaces[3],
                  Constants.cfFaces[4],
                  Constants.cfFaces[5],
                ],
              ),
            ),

            DiceDisplay(
              imagePaths: [
                Constants.blankCFFace,
                Constants.blankCFFace,
                Constants.blankCFFace,
              ],
            ),
          ],
        ),
      );
  }

  Widget landscape() {
    return
      Center(
        child: Row(
          children: [
            FourImageDisplay(
            ),

            Expanded(
              flex: 1,
              child:
              CfBoardWidget(
                imagePaths: [
                  Constants.cfFaces[0],
                  Constants.cfFaces[1],
                  Constants.cfFaces[2],
                  Constants.cfFaces[3],
                  Constants.cfFaces[4],
                  Constants.cfFaces[5],
                ],
              ),
            ),

            DiceDisplay(
              imagePaths: [
                Constants.blankCFFace,
                Constants.blankCFFace,
                Constants.blankCFFace,
              ],
            ),
          ],
        ),
      );
  }

}