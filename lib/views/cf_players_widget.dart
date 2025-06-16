import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cf_game.dart';


class FourImageDisplay extends StatefulWidget {

  FourImageDisplay({Key? key})
      : super(key: key);

  @override
  _FourImageDisplayState createState() => _FourImageDisplayState();
}

class _FourImageDisplayState extends State<FourImageDisplay> {
  @override
  Widget build(BuildContext context) {

    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;

        return LayoutBuilder(

          builder: (BuildContext context, BoxConstraints constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final imageSize = isLandscape ? screenHeight / 4 : screenWidth / 4;

            return Flex(
              direction: isLandscape ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return Container(
                  width: imageSize,
                  height: imageSize,
                  padding: const EdgeInsets.all(4.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child:
                    // --- Draggable Image ---
                    Draggable<String>(
                      data: index.toString(), // Data associated with this draggable
                      feedback: _buildDraggableFeedback(index), // Thumbnail shown during drag
                      childWhenDragging: _buildDraggableChildWhenDragging(), // What's left behind
                      onDragStarted: () {
                        if (kDebugMode) {
                          print("Drag started");
                        }
                      },
                      onDragCompleted: () {
                        if (kDebugMode) {
                          print("Drag completed on a target");
                        }
                        // Optionally hide the original if it's successfully dropped
                        // setState(() {
                        //   // Logic to hide or change the original draggable if needed
                        // });
                      },
                      onDraggableCanceled: (velocity, offset) {
                        if (kDebugMode) {
                          print("Drag canceled (dropped outside a target)");
                        }
                      },
                      child:
                          _buildDraggableChild(index), // Initial appearance of the draggable
                    ),
                  ),
                );
              }),
            );
          },
        );
      },
    );
  }

  // Widget for the initial appearance of the draggable image
  Widget _buildDraggableChild(int index) {
    final playerColor = context.watch<AppState>().getColorForPlayer(index);
    final playerImage = context.watch<AppState>().getPlayerImage(index);
    if (kDebugMode) {
      print("Player: $index, Image: , Color: $playerColor");
    }
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: playerColor, width: 8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: 120,
        height: 120,
        child: playerImage,
      ),
    );
  }

  // Widget shown while dragging (the thumbnail)
  Widget _buildDraggableFeedback(int index) {
    final appState = Provider.of<AppState>(context, listen: false);

    return Opacity(
      opacity: 0.7, // Make it slightly transparent
      child: Material( // Material is needed for elevation and shadow if desired
        elevation: 4.0,
        child: Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SizedBox(
            width: 120,
            height: 120,
            child: appState.getPlayerImage(index),
          ),
        ),
      ),
    );
  }

  // Widget shown at the original position of the draggable while it's being dragged
  Widget _buildDraggableChildWhenDragging() {
    return Container(
      width: 120 + 16, // Original width + padding
      height: 120 + 16, // Original height + padding
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        border: Border.all(color: Colors.grey.shade400, width: 2, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: Text("Dragging...", style: TextStyle(color: Colors.white70))),
    );
  }

}