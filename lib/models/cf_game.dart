import 'dart:io';
import 'dart:math';
import 'package:crabfish/models/settings_service.dart';
import 'package:crabfish/models/smart_image.dart';
import 'package:crabfish/providers/player_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:player_model/player.dart';
import '../cf_constants.dart';

class SelectionData {
  String playerName0;
  String playerName1;
  String playerName2;
  String playerName3;

  SmartImage? playerImage0;
  SmartImage? playerImage1;
  SmartImage? playerImage2;
  SmartImage? playerImage3;
  String? playerImage0Choice = "";
  String? playerImage1Choice = "";
  String? playerImage2Choice = "";
  String? playerImage3Choice = "";
  int dice1 = 1;
  int dice2 = 1;
  int dice3 = 1;
  int playerTotal0 = 20;
  int playerTotal1 = 20;
  int playerTotal2 = 20;
  int playerTotal3 = 20;
  int startingMoney = 20;
  int standardBet = 1;
  int payout1 = 2;
  int payout2 = 3;
  int payout3 = 10;
  int gameState = 0;
  String? selectedImage;


  SelectionData(
              {
                this.playerName0 = "none",
                this.playerName1 = "none",
                this.playerName2 = "none",
                this.playerName3 = "none",
                this.dice1 = 7,
                this.dice2 = 7,
                this.dice3 = 7
              }
              );
}

// --- ChangeNotifier for State Management ---
class AppState extends ChangeNotifier {
  final SelectionData _selectionData = SelectionData();
  Map<int, List<int>> bonusScores = {};

  SelectionData get selectionData => _selectionData;

  void clearBonusScores() {
    bonusScores.clear();
    notifyListeners();
  }

  int _getBonusSpinScore() {
    final scores = [0, 20, 50, 20, 100, 20, 50, 20, 50, 20, 500, 20, 50, 20, 100, 20, 50, 20, 50, 20];
    final random = Random();
    return scores[random.nextInt(scores.length)];
  }

  void rollDice(PlayerProvider playerProvider, SettingsService settingsService) {
    _selectionData.dice1 = _rollSingleDice();
    _selectionData.dice2 = _rollSingleDice();
    _selectionData.dice3 = _rollSingleDice();
    clearBonusScores();

    for (int i = 0; i < playerProvider.players.length; i++) {
      int winnings = getWinningsForPlayer(i);
      if (settingsService.integrateMoneyWheel) {
        int matches = getNumberOfMatchesForPlayer(i);
        if (matches > 0) {
          bonusScores[i] = [];
          for (int j = 0; j < matches; j++) {
            int bonus = _getBonusSpinScore();
            winnings += bonus;
            bonusScores[i]!.add(bonus);
          }
        }
      }
      addToTotalForPlayer(i, winnings, playerProvider);
    }

    _selectionData.gameState = 1;
    notifyListeners();
  }

  void clearDice() {
    _selectionData.dice1 = 7;
    _selectionData.dice2 = 7;
    _selectionData.dice3 = 7;
    _selectionData.gameState = 0;
    clearBonusScores();
    notifyListeners();
  }

  int _rollSingleDice() {
    final random = Random();
    return random.nextInt(6) + 1;
  }

  void clearPlayerChoices() {
    _selectionData.playerImage0Choice = "";
    _selectionData.playerImage1Choice = "";
    _selectionData.playerImage2Choice = "";
    _selectionData.playerImage3Choice = "";
    notifyListeners();
  }

  void setPlayerChoice(int playNum, String boardImagePath ) {
    switch (playNum) {
      case 0:
        _selectionData.playerImage0Choice = boardImagePath ;
        break;
        case 1:
          _selectionData.playerImage1Choice = boardImagePath ;
        break;
      case 2:
        _selectionData.playerImage2Choice = boardImagePath ;
        break;
        case 3:
          _selectionData.playerImage3Choice = boardImagePath ;
        break;
    }
    notifyListeners();
  }

  String? getPlayerChoiceImage(int playNum) {
    String? playerChoiceImage = Constants.avatar00;

    switch (playNum) {
      case 0:
        playerChoiceImage = _selectionData.playerImage0Choice;
        break;
      case 1:
        playerChoiceImage = _selectionData.playerImage1Choice;
        break;
      case 2:
        playerChoiceImage = _selectionData.playerImage2Choice;
        break;
      case 3:
        playerChoiceImage = _selectionData.playerImage3Choice;
        break;
    }
    return playerChoiceImage;
  }

  int getNumberOfMatchesForPlayer(int playerNum) {
    int numberOfMatches = 0;

    if (Constants.cfFaces[_selectionData.dice1 - 1] == getPlayerChoiceImage(playerNum)) {
      numberOfMatches++;
    }
    if (Constants.cfFaces[_selectionData.dice2 - 1] == getPlayerChoiceImage(playerNum)) {
      numberOfMatches++;
    }
    if (Constants.cfFaces[_selectionData.dice3 - 1] == getPlayerChoiceImage(playerNum)) {
      numberOfMatches++;
    }
    if (kDebugMode) {
      print('Num Match $playerNum : $numberOfMatches');
    }

    return numberOfMatches;
  }


  Color getColorForPlayer(int playerNum) {
    Color playerColor = Colors.black;

    switch (getNumberOfMatchesForPlayer(playerNum))
     {
      case 0:
        playerColor = Colors.black;
        break;
        case 1:
        playerColor = Colors.green;
        break;
      case 2:
        playerColor = Colors.red;
        break;
      case 3:
        playerColor = Colors.amber;
        break;
    }
    return  playerColor;
  }

  void addToTotalForPlayer(int playerNum, int amountToAdd, PlayerProvider playerProvider) {
    if (playerNum < playerProvider.players.length) {
      final player = playerProvider.players[playerNum];
      final updatedPlayer = Player(
        id: player.id,
        name: player.name,
        imagePath: player.imagePath,
        score: player.score + amountToAdd,
      );
      playerProvider.updatePlayer(playerNum, updatedPlayer);
    }
  }


  int getStartingMoney() {
    return _selectionData.startingMoney;
  }

  void changeStartingMoney(int newBet) {
    _selectionData.startingMoney = newBet;
    notifyListeners();
  }

  int getStandardBet() {
    return _selectionData.standardBet;
  }

  void changeStandardBet(int newBet) {
    _selectionData.standardBet = newBet;
    notifyListeners();
  }

  int getWinningsForPlayer(int playerNum) {

    int winnings = 0;
    int payout = 0;

    switch (getNumberOfMatchesForPlayer(playerNum)) {
      case 0:
        payout = 0;
        break;
      case 1:
        payout = _selectionData.payout1;
        if (kDebugMode) {
          print('payout1:  $payout');
        }
        break;
      case 2:
        payout = _selectionData.payout2;
        if (kDebugMode) {
          print('payout2:  $payout');
        }
        break;
      case 3:
        payout = _selectionData.payout3;
        if (kDebugMode) {
          print('payout3:  $payout');
        }
        break;
    }

    winnings = (payout * getStandardBet()) - getStandardBet();

    return winnings;
  }

  int getPayout1() {
    return _selectionData.payout1;
  }

  int getPayout2() {
    return _selectionData.payout2;
  }

  int getPayout3() {
    return _selectionData.payout3;

  }

  setPayout1(int payout1) {
    _selectionData.payout1 = payout1;
    notifyListeners();
  }
  setPayout2(int payout2) {
    _selectionData.payout2 = payout2;
    notifyListeners();
  }
  setPayout3(int payout3) {
    _selectionData.payout3 = payout3;
    notifyListeners();
  }

  int getGameState() {
    return _selectionData.gameState;
  }

  void setGameState(int gameState) {
    _selectionData.gameState = gameState;
    notifyListeners();
  }

  String getSelectedImage() {
    return _selectionData.selectedImage ?? '';
  }

  void setSelectedImage(String imagePath) {
    _selectionData.selectedImage = imagePath;
    notifyListeners();
  }

  bool hasChoiceImage(int playerNum) {
    bool hasChoice = false;
    switch (playerNum) {
      case 0:
        if (_selectionData.playerImage0Choice != "") {
          hasChoice = true;
        }
        break;
      case 1:
        if (_selectionData.playerImage1Choice != "") {
          hasChoice = true;
        }
        break;
      case 2:
        if (_selectionData.playerImage2Choice != "") {
          hasChoice = true;
        }
        break;
      case 3:
        if (_selectionData.playerImage3Choice != "") {
          hasChoice = true;
        }
        break;
    }
    return hasChoice;
  }
}
