import 'dart:async';
import 'dart:io';

import 'package:crabfish/providers/player_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cf_game.dart';

class FourImageDisplay extends StatefulWidget {
  const FourImageDisplay({super.key});

  @override
  _FourImageDisplayState createState() => _FourImageDisplayState();
}

class _FourImageDisplayState extends State<FourImageDisplay> {
  Map<int, List<int>> _bonusScores = {};
  Map<int, int> _currentBonusIndex = {};
  Map<int, Timer> _bonusTimers = {};
  Map<int, Timer> _flashTimers = {};
  Map<int, bool> _showBonusHighlight = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appState = context.watch<AppState>();
    if (appState.bonusScores.isNotEmpty && _bonusScores.isEmpty) {
      _bonusScores = Map.from(appState.bonusScores);
      _startBonusDisplay();
    }
    if (appState.bonusScores.isEmpty && _bonusScores.isNotEmpty) {
      _bonusTimers.values.forEach((timer) => timer.cancel());
      _flashTimers.values.forEach((timer) => timer.cancel());
      _bonusTimers.clear();
      _flashTimers.clear();
      _bonusScores.clear();
      _currentBonusIndex.clear();
      _showBonusHighlight.clear();
      setState(() {});
    }
  }

  void _startBonusDisplay() {
    _bonusScores.forEach((playerIndex, scores) {
      if (scores.isNotEmpty) {
        _currentBonusIndex[playerIndex] = 0;
        _showBonusHighlight[playerIndex] = true;

        _bonusTimers[playerIndex] = Timer.periodic(const Duration(seconds: 3), (timer) {
          if (!mounted) {
            timer.cancel();
            return;
          }
          setState(() {
            if (_currentBonusIndex[playerIndex]! < scores.length - 1) {
              _currentBonusIndex[playerIndex] = _currentBonusIndex[playerIndex]! + 1;
            } else {
              timer.cancel();
              _flashTimers[playerIndex]?.cancel();
              _bonusScores.remove(playerIndex);
              _showBonusHighlight.remove(playerIndex);
            }
          });
        });

        _flashTimers[playerIndex] = Timer.periodic(const Duration(milliseconds: 500), (timer) {
          if (!mounted) {
            timer.cancel();
            return;
          }
          setState(() {
            _showBonusHighlight[playerIndex] = !(_showBonusHighlight[playerIndex] ?? true);
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _bonusTimers.values.forEach((timer) => timer.cancel());
    _flashTimers.values.forEach((timer) => timer.cancel());
    super.dispose();
  }

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
                    child: Draggable<String>(
                      data: index.toString(),
                      feedback: _buildDraggableFeedback(index),
                      childWhenDragging: _buildDraggableChildWhenDragging(),
                      onDragStarted: () {
                        if (kDebugMode) {
                          print("Drag started");
                        }
                      },
                      onDragCompleted: () {
                        if (kDebugMode) {
                          print("Drag completed on a target");
                        }
                      },
                      onDraggableCanceled: (velocity, offset) {
                        if (kDebugMode) {
                          print("Drag canceled (dropped outside a target)");
                        }
                      },
                      child: _buildDraggableChild(index),
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

  Widget _buildPlayerImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Image.asset('assets/images/avatars/blankPlayer.jpg', package: 'player_model', fit: BoxFit.cover);
    }

    if (imagePath.startsWith('assets/')) {
      if (imagePath.contains('avatars/')) {
        return Image.asset(imagePath, package: 'player_model', fit: BoxFit.cover);
      } else {
        return Image.asset(imagePath, fit: BoxFit.cover);
      }
    } else {
      return Image.file(File(imagePath), fit: BoxFit.cover);
    }
  }

  Widget _buildDraggableChild(int index) {
    final playerProvider = context.watch<PlayerProvider>();
    final appState = context.watch<AppState>();
    final player = playerProvider.players[index];
    final playerChoiceImagePath = appState.getPlayerChoiceImage(index);
    final hasChoice = appState.hasChoiceImage(index);
    final matchColor = appState.getColorForPlayer(index);

    final isBonusActive = _bonusScores.containsKey(index);
    final showHighlight = _showBonusHighlight[index] ?? true;
    Color borderColor;
    if (isBonusActive) {
      borderColor = showHighlight ? matchColor : Colors.transparent;
    } else {
      borderColor = matchColor;
    }

    int? bonusToShow;
    if (_bonusScores.containsKey(index) && _currentBonusIndex.containsKey(index)) {
      final scores = _bonusScores[index]!;
      final bonusIndex = _currentBonusIndex[index]!;
      if (scores.isNotEmpty && bonusIndex < scores.length) {
        bonusToShow = scores[bonusIndex];
      }
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                width: 120,
                height: 120,
                child: _buildPlayerImage(player.imagePath),
              ),
            ),
            if (hasChoice && playerChoiceImagePath != null && playerChoiceImagePath.isNotEmpty)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    playerChoiceImagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (bonusToShow != null)
              Center(
                child: Text(
                  '+$bonusToShow',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: matchColor,
                    shadows: const [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(5.0, 5.0),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${player.name}: ${player.score}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildDraggableFeedback(int index) {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    final player = playerProvider.players[index];

    return Opacity(
      opacity: 0.7,
      child: Material(
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
            child: _buildPlayerImage(player.imagePath),
          ),
        ),
      ),
    );
  }

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
