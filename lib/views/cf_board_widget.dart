import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../cf_constants.dart';
import '../models/cf_game.dart';

class CfBoardWidget extends StatefulWidget {
  final List<String> imagePaths;
  const CfBoardWidget({super.key, required this.imagePaths});

  @override
  State<CfBoardWidget> createState() => _CfBoardWidgetState();
}

class _CfBoardWidgetState extends State<CfBoardWidget> {
  String targetImagePath = Constants.cfFaces[0];
  List<String> get imagePaths => widget.imagePaths;

  @override
  Widget build(BuildContext context) {
    if (imagePaths.length != 6) {
      return const Center(
        child: Text('ImageTable requires exactly 6 images'),
      );
    }

    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;
        final numRows = isLandscape ? 2 : 3;
        final numCols = isLandscape ? 3 : 2;

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final appState = Provider.of<AppState>(context, listen: false);

            // Calculate the available width and height for the Table
            final availableWidth = constraints.maxWidth;
            final availableHeight = constraints.maxHeight;

            // Calculate the ideal size for each cell to fit without scrolling
            final cellWidth = availableWidth / numCols;
            final cellHeight = availableHeight / numRows;

            // Use the smaller dimension to ensure images fit and maintain aspect ratio
            final imageDimension = cellWidth < cellHeight ? cellWidth : cellHeight;

            List<TableRow> tableRows = [];
            int imageIndex = 0;

            for (int i = 0; i < numRows; i++) {
              List<Widget> rowChildren = [];
              for (int j = 0; j < numCols; j++) {
                if (imageIndex < imagePaths.length) { // Check if there's an image for the current cell
                  final currentImagePath = imagePaths[imageIndex];
                  rowChildren.add(
                    SizedBox( // Use SizedBox to constrain the cell size
                      width: cellWidth,
                      height: cellHeight,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: DragTarget<String>(
                          builder: (BuildContext context, List<String?> candidateData, List<dynamic> rejectedData) {
                            // Check if any draggable is hovering over this target
                            bool isHovering = candidateData.isNotEmpty;
                            return Container(
                              decoration: BoxDecoration(
                                border: isHovering
                                    ? Border.all(color: Colors.blue, width: 6) // Blue border when hovering
                                    : null, // No border otherwise
                              ),
                              child: FittedBox(
                                fit: BoxFit.contain, // Scale image to fit within the cell
                                child: Image.asset(
                                  currentImagePath,
                                  // Ensure the image itself doesn't try to be infinitely large
                                  width: imageDimension,
                                  height: imageDimension,
                                ),
                              ),
                            );
                          },
                          onWillAcceptWithDetails: (data) {
                            // This callback is called when a draggable is starting to hover
                            // You can use it to decide if the target should accept the draggable
                            // For now, we accept all string data (image paths)
                            return true;
                          },
                          onAcceptWithDetails: (data) {
                            // This callback is called when a draggable is dropped and accepted

                            // You can implement logic here, e.g., swapping images or checking for matches
                            setState(() {
                              if (kDebugMode) {
                                print('Dropped ${data.data} onto cell with $currentImagePath');
                              }
                              appState.setPlayerChoice(int.parse(data.data), currentImagePath);
                              // Force a redraw of the FourimageDisplay widget
//                              appState.notifyListeners();

                            });
                          },
                          onLeave: (data) {
                            // This callback is called when a draggable leaves the target area
                          },
                        ),
                      ),
                    ),
                  );
                  imageIndex++;
                }
              }
              tableRows.add(TableRow(children: rowChildren));
            }

            return Table(
              // defaultColumnWidth: FixedColumnWidth(imageDimension), // This can help enforce consistent cell sizes
              border: TableBorder.all(color: Colors.grey, width: 0.5), // Optional: for debugging layout
              children: tableRows,
            );
          },
        );
      },
    );
  }

}

