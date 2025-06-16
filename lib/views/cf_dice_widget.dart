import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cf_constants.dart';
import '../models/cf_game.dart';

class DiceDisplay extends StatefulWidget {
  final List<String> imagePaths;

  const DiceDisplay({super.key, required this.imagePaths});

  @override
  State<DiceDisplay> createState() => _DiceDisplayState();
}

class _DiceDisplayState extends State<DiceDisplay> {

  bool _isRollButtonEnabled = true;
  bool _isClearButtonEnabled = false;
  final String _activeRollButtonImagePath = Constants.rollButtonEnabled; // Replace with your active image
  final String _disabledRollButtonImagePath = Constants.rollButtonDisabled; // Replace with your disabled image
  final String _activeClearButtonImagePath = Constants.clearButtonEnabled; // Replace with your active image
  final String _disabledClearButtonImagePath = Constants.clearButtonDisabled; // Replace with your disabled image

  void _handleRollButtonPressed() {
    final appState = Provider.of<AppState>(context, listen: false);

    if (_isRollButtonEnabled) {
      // Perform your action when the button is pressed
      if (kDebugMode) {
        print('Roll Button Pressed!');
      }
      appState.rollDice();

      setState(() {
        _isRollButtonEnabled = false; // Disable the button
        _isClearButtonEnabled = true; // Disable the button

        widget.imagePaths[0] = Constants.cfFaces[appState.selectionData.dice1 - 1];
        widget.imagePaths[1] = Constants.cfFaces[appState.selectionData.dice2 - 1];
        widget.imagePaths[2] = Constants.cfFaces[appState.selectionData.dice3 - 1];
        if (kDebugMode) {
          print('Roll set state!');
          print('Dice1: ${ widget.imagePaths[0]}');
          print('Dice2: ${ widget.imagePaths[1]}');
          print('Dice3: ${ widget.imagePaths[2]}');
        }
      }
      );
    }
  }

  void _handleClearButtonPressed() {
   // final appState = context.watch<AppState>();
    final appState = Provider.of<AppState>(context, listen: false);
    if (_isClearButtonEnabled) {
      // Perform your action when the button is pressed
      if (kDebugMode) {
        print('Clear Button Pressed!');
      }
      appState.clearDice();
      context.read<AppState>().clearPlayerChoices();

      setState(() {
        _isClearButtonEnabled = false; // Disable the button
        _isRollButtonEnabled = true;
        widget.imagePaths[0] = Constants.blankCFFace;
        widget.imagePaths[1] = Constants.blankCFFace;
        widget.imagePaths[2] = Constants.blankCFFace;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagePaths.length != 3) {
      return const Center(
        child: Text('DiceDisplay requires exactly 3 images'),
      );
    }

    return OrientationBuilder(
      builder: (context, orientation) {
        final appState = Provider.of<AppState>(context, listen: false);
        if (appState.getGameState() == 0)
          {
            _isRollButtonEnabled = true;
            _isClearButtonEnabled = false;
          }
        else
          {
            _isRollButtonEnabled = false;
            _isClearButtonEnabled = true;
          }
        final isLandscape = orientation == Orientation.landscape;

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final imageSize = isLandscape ? screenHeight / 5 : screenWidth / 5;

            return Flex(
                direction: isLandscape ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  // roll button
                  ElevatedButton(
                    // onPressed is null when disabled, which gives a default disabled look.
                    // The image change provides additional visual feedback.
                    onPressed: _isRollButtonEnabled ? _handleRollButtonPressed : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero, // Remove default padding if you want image to fill
                      shape: const CircleBorder(), // Or RoundedRectangleBorder, etc.
                      // You can customize disabledBackgroundColor and foregroundColor (for text/icon color)
                      // if the default disabled look isn't enough.
                      // disabledBackgroundColor: Colors.grey.withOpacity(0.1),
                    ).copyWith(
                      // Ensure splash effect is disabled when the button itself is disabled
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.disabled)) return Colors.transparent;
                          return null; // Use the default overlay color
                        },
                      ),
                    ),
                    child: Image.asset(
                      _isRollButtonEnabled ? _activeRollButtonImagePath : _disabledRollButtonImagePath,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                      // Optional: Add a color overlay for disabled state if your image doesn't have one
                      color: _isRollButtonEnabled ? null : Colors.grey.withOpacity(0.5),
                      colorBlendMode: _isRollButtonEnabled ? null : BlendMode.dstATop,
                    ),
                  ),

                  // clear button
                  ElevatedButton(
                    // onPressed is null when disabled, which gives a default disabled look.
                    // The image change provides additional visual feedback.
                    onPressed: _isClearButtonEnabled ? _handleClearButtonPressed : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero, // Remove default padding if you want image to fill
                      shape: const CircleBorder(), // Or RoundedRectangleBorder, etc.
                      // You can customize disabledBackgroundColor and foregroundColor (for text/icon color)
                      // if the default disabled look isn't enough.
                      // disabledBackgroundColor: Colors.grey.withOpacity(0.1),
                    ).copyWith(
                      // Ensure splash effect is disabled when the button itself is disabled
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.disabled)) return Colors.transparent;
                          return null; // Use the default overlay color
                        },
                      ),
                    ),
                    child: Image.asset(
                      _isClearButtonEnabled ? _activeClearButtonImagePath : _disabledClearButtonImagePath,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                      // Optional: Add a color overlay for disabled state if your image doesn't have one
                      color: _isClearButtonEnabled ? null : Colors.grey.withOpacity(0.5),
                      colorBlendMode: _isClearButtonEnabled ? null : BlendMode.dstATop,
                    ),
                  ),


                  Container(
                    width: imageSize,
                    height: imageSize,
                    padding: const EdgeInsets.all(4.0),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.asset(
                        Constants.cfFaces[appState.selectionData.dice1 - 1],
                      ),
                    ),
                  ),
                  Container(
                    width: imageSize,
                    height: imageSize,
                    padding: const EdgeInsets.all(4.0),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.asset(
                        Constants.cfFaces[appState.selectionData.dice2 - 1],
                      ),
                    ),
                  ),
                  Container(
                    width: imageSize,
                    height: imageSize,
                    padding: const EdgeInsets.all(4.0),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.asset(
                        Constants.cfFaces[appState.selectionData.dice3 - 1],
                      ),
                    ),
                  ),
                ]);
          },
        );
      },
    );
  }

  Widget rollButton() {
    final appState = context.watch<AppState>();
    return ElevatedButton(
      onPressed: () {
        appState.rollDice();
        if (mounted) { // Check if the widget is still in the tree
          setState(() {

          });
        }
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.green[700]!, width: 2.0),
          ),
        ),
      ),
      child: Text('Roll'),
    );
  }
}
