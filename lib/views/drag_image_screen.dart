import 'package:flutter/material.dart';

import '../cf_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Drag Image Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MultiDragImageScreen(),
    );
  }
}

// Enum to identify our draggable items and targets
enum DraggableItem { item1, item2 }
enum TargetArea { targetA, targetB }

class MultiDragImageScreen extends StatefulWidget {
  const MultiDragImageScreen({super.key});

  @override
  State<MultiDragImageScreen> createState() => _MultiDragImageScreenState();
}

class _MultiDragImageScreenState extends State<MultiDragImageScreen> {
  // --- Image Paths ---
  final String draggableImage1Path =  'assets/images/avatars/female01.png';
  final String draggableImage2Path =  'assets/images/avatars/female02.png';
  final String targetImageAPath =  Constants.cfFaces[0];
  final String targetImageBPath =  Constants.cfFaces[1];

  // --- State for Hovering ---
  // Keep track of which target is being hovered over by which item
  // Key: TargetArea, Value: DraggableItem (if hovering, else null)
  final Map<TargetArea, DraggableItem?> _hoveringState = {
    TargetArea.targetA: null,
    TargetArea.targetB: null,
  };

  // --- State for Dropped Items ---
  // Key: TargetArea, Value: Path of the dropped image (if any)
  final Map<TargetArea, String?> _droppedImages = {
    TargetArea.targetA: null,
    TargetArea.targetB: null,
  };

  // --- State for which draggable is currently being dragged ---
  String? _currentlyDraggedImagePath;

  void _onDragStarted(String imagePath) {
    setState(() {
      _currentlyDraggedImagePath = imagePath;
    });
  }

  void _onDragEnded() {
    setState(() {
      _currentlyDraggedImagePath = null;
      // Reset all hover states when drag ends, regardless of where it was dropped
      _hoveringState[TargetArea.targetA] = null;
      _hoveringState[TargetArea.targetB] = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag One of Two Images'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // --- Row of Draggable Images ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDraggableItem(
                  imagePath: draggableImage1Path,
                  data: DraggableItem.item1,
                ),
                _buildDraggableItem(
                  imagePath: draggableImage2Path,
                  data: DraggableItem.item2,
                ),
              ],
            ),

            const SizedBox(height: 40),

            // --- Row of Target Images ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTargetArea(
                  targetAreaId: TargetArea.targetA,
                  baseImagePath: targetImageAPath,
                  acceptedItemData: DraggableItem.item1, // Example: Target A accepts Item 1
                ),
                _buildTargetArea(
                  targetAreaId: TargetArea.targetB,
                  baseImagePath: targetImageBPath,
                  acceptedItemData: DraggableItem.item2, // Example: Target B accepts Item 2
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _droppedImages[TargetArea.targetA] = null;
                  _droppedImages[TargetArea.targetB] = null;
                  _hoveringState[TargetArea.targetA] = null;
                  _hoveringState[TargetArea.targetB] = null;
                });
              },
              child: const Text("Reset Targets"),
            )
          ],
        ),
      ),
    );
  }

  // --- Helper to Build Draggable Item ---
  Widget _buildDraggableItem({required String imagePath, required DraggableItem data}) {
    // Check if this item has been dropped on any target already
    bool isAlreadyDropped = _droppedImages.containsValue(imagePath);

    if (isAlreadyDropped && _currentlyDraggedImagePath != imagePath) {
      // If dropped and not currently being re-dragged, show a placeholder or nothing
      return Container(
        width: 100 + 16, // Original width + padding
        height: 100 + 16, // Original height + padding
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300)
        ),
        child: Center(child: Text('Dropped', style: TextStyle(color: Colors.grey.shade500))),
      );
    }

    return Draggable<Map<String, dynamic>>( // Pass a map with image path and item type
      data: {'path': imagePath, 'item': data},
      feedback: _buildDraggableFeedback(imagePath),
      childWhenDragging: _buildDraggableChildWhenDragging(imagePath),
      onDragStarted: () => _onDragStarted(imagePath),
      onDragCompleted: _onDragEnded, // Called if dropped on a target
      onDraggableCanceled: (velocity, offset) => _onDragEnded(), // Called if dropped elsewhere
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          imagePath,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image, size: 100, color: Colors.redAccent),
        ),
      ),
    );
  }

  // --- Draggable Feedback (Thumbnail) ---
  Widget _buildDraggableFeedback(String imagePath) {
    return Opacity(
      opacity: 0.75,
      child: Material(
        elevation: 6.0,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue.shade300, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(
            imagePath,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 70, color: Colors.redAccent),
          ),
        ),
      ),
    );
  }

  // --- Child When Dragging (Placeholder) ---
  Widget _buildDraggableChildWhenDragging(String imagePath) {
    return Container(
      width: 100 + 16, // Match original size including padding
      height: 100 + 16,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400, width: 1.5, style: BorderStyle.solid),
      ),
      child: Center(child: Text("...", style: TextStyle(color: Colors.grey.shade600, fontSize: 24))),
    );
  }

  // --- Helper to Build Target Area ---
  Widget _buildTargetArea({
    required TargetArea targetAreaId,
    required String baseImagePath,
    required DraggableItem acceptedItemData, // Define which item this target accepts
  }) {
    bool isHovering = _hoveringState[targetAreaId] != null;
    String? droppedImagePathOnThisTarget = _droppedImages[targetAreaId];

    return DragTarget<Map<String, dynamic>>(
      onWillAcceptWithDetails: (details) {
        final incomingData = details.data;
        // Check if this target should accept this specific item
        // For simplicity, you could make targets accept specific items or any.
        // Here, we check if the 'item' type matches what this target expects.
        // bool canAccept = incomingData['item'] == acceptedItemData;
        bool canAccept = true; // For this example, allow any drop for simplicity of border

        if (canAccept) {
          setState(() {
            _hoveringState[targetAreaId] = incomingData['item'] as DraggableItem;
          });
        }
        return canAccept;
      },
      onAcceptWithDetails: (details) {
        final incomingData = details.data;
        final droppedPath = incomingData['path'] as String;
        final droppedItem = incomingData['item'] as DraggableItem;

        print("Item ${droppedItem.name} dropped on Target ${targetAreaId.name}");
        setState(() {
          // If another draggable was already on this target, "return" it by nullifying its dropped status
          _droppedImages.forEach((key, value) {
            if (value == droppedPath && key != targetAreaId) {
              _droppedImages[key] = null;
            }
          });

          _droppedImages[targetAreaId] = droppedPath;
          _hoveringState[targetAreaId] = null; // Clear hover state after drop
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dropped ${droppedItem.name} onto ${targetAreaId.name}!')),
        );
      },
      onLeave: (data) {
        setState(() {
          _hoveringState[targetAreaId] = null;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 150,
          height: 150,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: droppedImagePathOnThisTarget != null ? Colors.green.withOpacity(0.05) : Colors.grey.shade200,
            border: Border.all(
              color: isHovering ? Colors.blueAccent : Colors.transparent,
              width: isHovering ? 3.0 : 0.0,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: droppedImagePathOnThisTarget != null
                ? Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  baseImagePath, // Base image in background
                  fit: BoxFit.contain,
                  width: 140, height: 140,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 130, color: Colors.red),
                ),
                Image.asset(
                  droppedImagePathOnThisTarget, // Dropped image on top
                  width: 90, // Smaller overlay
                  height: 90,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 90, color: Colors.red),
                ),
              ],
            )
                : Image.asset(
              baseImagePath,
              fit: BoxFit.contain,
              width: 140, height: 140,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, size: 130, color: Colors.red),
            ),
          ),
        );
      },
    );
  }
}