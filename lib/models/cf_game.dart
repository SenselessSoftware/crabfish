
import 'dart:io';
import 'dart:math';
import 'package:crabfish/models/smart_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  SelectionData get selectionData => _selectionData;

  void updatePlayerName0(String newText) {
    _selectionData.playerName0 = newText;
    notifyListeners(); // Notify widgets listening to this state
  }

  void updatePlayerName1(String newText) {
    _selectionData.playerName1 = newText;
    notifyListeners(); // Notify widgets listening to this state
  }

  void updatePlayerName2(String newText) {
    _selectionData.playerName2 = newText;
    notifyListeners(); // Notify widgets listening to this state
  }

  void updatePlayerName3(String newText) {
    _selectionData.playerName3 = newText;
    notifyListeners(); // Notify widgets listening to this state
  }

  void rollDice() {
    // For simplicity, let's assume a standard 6-sided die
    _selectionData.dice1 = _rollSingleDice();
    _selectionData.dice2 = _rollSingleDice();
    _selectionData.dice3 = _rollSingleDice();

    // update player totals
    addToTotalForPlayer(0, getWinningsForPlayer(0));
    addToTotalForPlayer(1, getWinningsForPlayer(1));
    addToTotalForPlayer(2, getWinningsForPlayer(2));
    addToTotalForPlayer(3, getWinningsForPlayer(3));
    _selectionData.gameState = 1;

    notifyListeners();
  }

  void clearDice() {
    // For simplicity, let's assume a standard 6-sided die
    _selectionData.dice1 = 7;
    _selectionData.dice2 = 7;
    _selectionData.dice3 = 7;
    _selectionData.gameState = 0;
    notifyListeners();
  }

  int _rollSingleDice() {
    final random = Random();
    return random.nextInt(6) + 1;
  }

  // init player images to blank
  void initPlayerImages() {
    _selectionData.playerImage0 ??= SmartImage(userID: 0, assetPath: Constants.avatar00);
    _selectionData.playerImage1 ??= SmartImage(userID: 1, assetPath: Constants.avatar00);
    _selectionData.playerImage2 ??= SmartImage(userID: 2, assetPath: Constants.avatar00);
    _selectionData.playerImage3 ??= SmartImage(userID: 3, assetPath: Constants.avatar00);
  }

  // Optional: Method to clear selection
  void clearSelection() {
    _selectionData.playerName0 = "none";
    _selectionData.playerName1 = "none";
    _selectionData.playerName2 = "none";
    _selectionData.playerName3 = "none";
    _selectionData.dice1 = 1; // Reset dice to default or a specific value
    _selectionData.dice2 = 1;
    _selectionData.dice3 = 1;
    _selectionData.playerTotal0 = _selectionData.startingMoney;
    _selectionData.playerTotal1 = _selectionData.startingMoney;
    _selectionData.playerTotal2 = _selectionData.startingMoney;
    _selectionData.playerTotal3 = _selectionData.startingMoney;
    _selectionData.playerImage0Choice = "";
    _selectionData.playerImage1Choice = "";
    _selectionData.playerImage2Choice = "";
    _selectionData.playerImage3Choice = "";
    notifyListeners();
  }



  Widget getPlayerImage(int playerNumber) {
    Widget playerImage;

    if (kDebugMode) {
      print('getplayerImage:');
    }

    switch (playerNumber) {
      case 0:
        playerImage = _selectionData.playerImage0 as Widget;
        if (kDebugMode) {
          print('playerNum: $playerNumber');
        }
        break;
      case 1:
        playerImage = _selectionData.playerImage1 as Widget;
        if (kDebugMode) {
          print('playerNum: $playerNumber');
        }
        break;
        case 2:
        playerImage = _selectionData.playerImage2 as Widget;
        if (kDebugMode) {
          print('playerNum: $playerNumber');
        }
        break;
      case 3:
        playerImage = _selectionData.playerImage3 as Widget;
        if (kDebugMode) {
          print('playerNum: $playerNumber');
        }
        break;
      default:
        playerImage = SmartImage(userID: playerNumber, assetPath: Constants.avatar00);
    }

    return playerImage;
  }


  String getPlayerName(int playerNumber) {
    String playerName = "none";

    switch (playerNumber) {
      case 0:
        playerName = _selectionData.playerName0;
        break;
      case 1:
        playerName = _selectionData.playerName1;
        break;
      case 2:
        playerName = _selectionData.playerName2;
        break;
      case 3:
        playerName = _selectionData.playerName3;
        break;
    }

    return playerName;
  }


  void updatePlayerName(int playerNumber, String newName) {

    switch (playerNumber) {
      case 0:
        updatePlayerName0(newName);
        break;
      case 1:
        updatePlayerName1(newName);
        break;
      case 2:
        updatePlayerName2(newName);
        break;
      case 3:
        updatePlayerName3(newName);
        break;
    }
  }


  void clearPlayerChoices() {

    _selectionData.playerImage0Choice = "";
    _selectionData.playerImage1Choice = "";
    _selectionData.playerImage2Choice = "";
    _selectionData.playerImage3Choice = "";

    notifyListeners();
    if (kDebugMode) {
      print('clearPlayerChoices');
    }
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

  int getTotalForPlayer(int playerNum) {
    int playerTotal = 0;

    switch (playerNum) {
      case 0:
        playerTotal = _selectionData.playerTotal0;
        break;
      case 1:
        playerTotal = _selectionData.playerTotal1;
        break;
      case 2:
        playerTotal = _selectionData.playerTotal2;
        break;
      case 3:
        playerTotal = _selectionData.playerTotal3;
        break;
      default:
        playerTotal = 0;
    }
    return playerTotal;
  }

  void addToTotalForPlayer(int playerNum, int amountToAdd) {

    switch (playerNum) {
      case 0:
        _selectionData.playerTotal0 = _selectionData.playerTotal0 + amountToAdd;
        break;
      case 1:
        _selectionData.playerTotal1 = _selectionData.playerTotal1 + amountToAdd;
        break;
      case 2:
        _selectionData.playerTotal2 = _selectionData.playerTotal2 + amountToAdd;
        break;
      case 3:
        _selectionData.playerTotal3 = _selectionData.playerTotal3 + amountToAdd;
        break;
    }
    notifyListeners();
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

  void setPlayerImageFile(int playerNum, File playerImage) {
    switch (playerNum) {
      case 0:
        _selectionData.playerImage0 = SmartImage(userID: playerNum, imageFile: playerImage);
        break;
      case 1:
        _selectionData.playerImage1 = SmartImage(userID: playerNum, imageFile: playerImage);
        break;
      case 2:
        _selectionData.playerImage2 = SmartImage(userID: playerNum, imageFile: playerImage);
        break;
      case 3:
        _selectionData.playerImage3 = SmartImage(userID: playerNum, imageFile: playerImage);
        break;
    }
  }


  void setPlayerImageAsset(int playerNum, String assetPath) {
    switch (playerNum) {
      case 0:
        _selectionData.playerImage0 = SmartImage(userID: playerNum, assetPath: assetPath);
        break;
      case 1:
        _selectionData.playerImage1 = SmartImage(userID: playerNum, assetPath: assetPath);
        break;
      case 2:
        _selectionData.playerImage2 = SmartImage(userID: playerNum, assetPath: assetPath);
        break;
      case 3:
        _selectionData.playerImage3 = SmartImage(userID: playerNum, assetPath: assetPath);
        break;
    }
  }

  bool hasChoiceImage(int playerNum) {
    bool hasChoice = false;
    switch (playerNum) {
      case 0:
        if (_selectionData.playerImage0Choice != "") {
          hasChoice = true;
        };
        break;
      case 1:
        if (_selectionData.playerImage1Choice != "") {
          hasChoice = true;
        };
        break;
      case 2:
        if (_selectionData.playerImage2Choice != "") {
          hasChoice = true;
        };
        break;
      case 3:
        if (_selectionData.playerImage3Choice != "") {
          hasChoice = true;
        };
        break;
    }
    return hasChoice;
  }


}