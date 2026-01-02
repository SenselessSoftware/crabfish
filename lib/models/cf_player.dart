
import 'package:flutter/material.dart';

import '../cf_constants.dart';
/*
class PlayerInGame with ChangeNotifier {
  String _playerName = Constants.unknownPlayer;

  String get playerName => _playerName;

  set playerName(String value) {
    _playerName = value;
    notifyListeners();
  }

  String defaultAvatar = Constants.avatarImages[0];
  int playerAvatarChosen = 0;
  Image _playerAvatar = Image.asset(
      Constants.avatarImages[0],
      fit: BoxFit.contain);
  int _playerTotScore = 0;
  int _playerRndScore = 0;
  int _uid = 0;
  int _answerChosen = -1;
  int _diceMatches = 0;
  Color _itemColor = Colors.redAccent;
  final Color colorUnselected = Colors.redAccent;
  final Color colorSelected = Colors.blueAccent;
  final Color colorCorrect = Colors.amber;
  final Color colorIncorrect = Colors.deepPurpleAccent;

  PlayerInGame();


  placeBet(int theAnswer) {

    if (getAnswer() == -1) {
      _playerTotScore--;
    }
    setAnswer(theAnswer);

    notifyListeners();
  }

  setAnswer(int theAnswer) {
    _answerChosen = theAnswer;
    _itemColor = colorSelected;
    notifyListeners();
  }

  setDiceMatches(int theAnswer) {
    _diceMatches = theAnswer;
    notifyListeners();
  }

  int getAnswer() {
    return _answerChosen;
  }

  Image getImage() {
    return _playerAvatar;
  }

  correctAnswer(int dice1, int dice2, int dice3) {
    int tempAnswer1 = 0;
    int tempAnswer2 = 0;
    int tempAnswerVal = _answerChosen;

    if (dice1 == tempAnswerVal) {
      tempAnswer1 = 1;
    }

    if (dice2 == tempAnswerVal) {
      tempAnswer1 = tempAnswer1 + 1;
    }

    if (dice3 == tempAnswerVal) {
      tempAnswer1 = tempAnswer1 + 1;
    }

    switch (tempAnswer1) {
      case 0 :
        {
          tempAnswer2 = 0;
        }
        break;
      case 1 :
        {
          tempAnswer2 = 2;
        }
        break;
      case 2 :
        {
          tempAnswer2 = 4;
        }
        break;
      case 3 :
        {
          tempAnswer2 = 10;
        }
        break;
      default:
        tempAnswer2 = 0;

    }
    _diceMatches = tempAnswer1;
    _playerTotScore = _playerTotScore + tempAnswer2;
  }

  Image get playerAvatar => _playerAvatar;

  set playerAvatar(Image value) {
    _playerAvatar = value;
    notifyListeners();
  }

  int get playerTotScore => _playerTotScore;

  set playerTotScore(int value) {
    _playerTotScore = value;
    notifyListeners();
  }

  int get playerRndScore => _playerRndScore;

  int get playerDM => _diceMatches;


  set playerRndScore(int value) {
    _playerRndScore = value;
    notifyListeners();
  }

  int get uid => _uid;

  set uid(int value) {
    _uid = value;
  }

  int get answerChosen => _answerChosen;

  set answerChosen(int value) {
    _answerChosen = value;
    notifyListeners();
  }

  Color get itemColor => _itemColor;

  set itemColor(Color value) {
    _itemColor = value;
    notifyListeners();
  }
}

 */