import 'package:flutter/material.dart';

class Constants {
  static const String gameName = 'Crab Fish';
  static const String startGame = 'Start Game';
  static const String rollDice = 'Roll';
  static const String clearDice = 'Clear';
  static const String finishGame = 'Finish';
  static const String instructions = 'Instructions';
  static const String reset = 'Reset';
  static const String wheel = 'Wheel';
  static const String firstItem = 'Load Player';
  static const String secondItem = 'Load Round';
  static const String unknownPlayer = 'No Name';

  static const String tutorialText00 = 'Instructions for playing Crab Fish\n';
  static const String tutorialText01 = 'Home Page Instructions\n';
  static const String tutorialText02 = '\nThe Home page shows the current players and their current scores. ';
  static const String tutorialText03 = 'If you wish, you can choose your player pictures and names. This is not necessary to play the game but it lets you customize your player icon and player name. ';
  static const String tutorialText04 = 'To customize your character, click on one of the boxes that says "Click to Add Player".\n';
  static const String tutorialText05 = 'Every player starts with 20 points. If you want to add 20 more points, Press the "Add Points" button.\n';
  static const String tutorialText06 = 'In the upper right corner is the 3 dot menu. Besides these instructions, you can modify some of the program "Settings" and launch the "Bonus Wheel" page\n';
  static const String tutorialText07 = 'When you are ready to play, choose the "Start Game" button at the top of the screen.\n';


  static const String tutorialText10 = 'Character Customize Instructions\n';
  static const String tutorialText11 = 'For your player icon, you can select one of our player avatar drawings. You can use a picture from your photo gallery on this device. Or you can use the device camera to take a picture. You can enter up to 4 player identities to play with.\n';
  static const String tutorialText12 = 'Clicking Avatar will show you the list of 20 avatar characters. Select one and choose "Submit"\n';
  static const String tutorialText13 = 'If you would like to take your picture using your devices Camera or choose a photo from your photo gallery for your player icon, Choose "Camera".';
  static const String tutorialText14 = 'Choose "Change Picture" and you will be able to select either the camera or your photo gallery.\n';

  static const String tutorialText20 = 'Play Crab Fish Instructions\n';
  static const String tutorialText21 = 'To choose which bet to make, press and hold the player icon and drag it onto the board.';
  static const String tutorialText22 = 'The board will highlight each square with a blue outline as you drag the player icon over it.\n';
  static const String tutorialText23 = 'To choose which selection to make, release the icon over the selected piece.';
  static const String tutorialText24 = 'The player icon will change to the selected piece to indicate that it was selected.\n';
  static const String tutorialText25 = 'When all players have selected, choose the Roll button. Three dice will roll. \n';
  static const String tutorialText26 = 'You can customize the standard bet that is used for every round in the settings page.\n ';
  static const String tutorialText27 = 'You can customize the multipliers used for matching 2 or 3 dice. Below, we are using the default multipliers.\n ';
  static const String tutorialText28 = 'You will get 1 standard bet if you match one die.\n ';
  static const String tutorialText29 = 'You will get 2 standard bets if you match two dice.\n ';
  static const String tutorialText30 = 'You will get 10 standard bets if you match all three dice.\n';
  static const String tutorialText31 = 'You will lose 1 points if you don\'t match any dice.\n';
  static const String tutorialText32 = 'To reset the dice and all selections, choose the Clear button.\n';
  static const String tutorialText33 = '\nTo go back to the main page, choose the back arrow at the top left of the screen.\n';

  static const String tutorialText40 = 'Settings Instructions\n';
  static const String tutorialText41 = 'You can change some of the parameters the program uses. You can change the standard Bet and the multipliers the program uses to calculate how many points you win if you match 2 or 3 dice.\n';
  static const String tutorialText42 = 'Click on the setting you wish to change and erase the current value. Then enter a numeric value and press the blue check box to the right of the numbers.\n';
  static const String tutorialText43 = 'When you are finished changing the settings you want to change, press the Back arrow button at the top left of the screen';
  static const String tutorialText44 = 'If you want to restore the settings to their defaults, press the reset icon on the top right of the screen.';

  static const String firstCFFace = 'assets/images/cfgame/crab.png';
  static const String secondCFFace = 'assets/images/cfgame/fish.png';
  static const String thirdCFFace = 'assets/images/cfgame/prawn.png';
  static const String fourthCFFace = 'assets/images/cfgame/tiger.png';
  static const String fifthCFFace = 'assets/images/cfgame/rooster.png';
  static const String sixthCFFace = 'assets/images/cfgame/gourd.png';
  static const String blankCFFace = 'assets/images/cfgame/blankdice.png';
  static const String rollButtonEnabled = 'assets/images/cfgame/rollButtonEnabled.png';
  static const String rollButtonDisabled = 'assets/images/cfgame/rollButtonDisabled.png';
  static const String clearButtonEnabled = 'assets/images/cfgame/clearButtonEnabled.png';
  static const String clearButtonDisabled = 'assets/images/cfgame/clearButtonDisabled.png';

  static const List<String> cfFaces = <String>[
    firstCFFace,
    secondCFFace,
    thirdCFFace,
    fourthCFFace,
    fifthCFFace,
    sixthCFFace,
    blankCFFace,
  ];


  static const String avatar00 = 'assets/images/avatars/blankPlayer.jpg';
  static const String avatar01 = 'assets/images/avatars/female01.png';
  static const String avatar02 = 'assets/images/avatars/female02.png';
  static const String avatar03 = 'assets/images/avatars/female03.png';
  static const String avatar04 = 'assets/images/avatars/female04.png';
  static const String avatar05 = 'assets/images/avatars/female05.png';
  static const String avatar06 = 'assets/images/avatars/female06.png';
  static const String avatar07 = 'assets/images/avatars/female07.png';
  static const String avatar08 = 'assets/images/avatars/female08.png';
  static const String avatar09 = 'assets/images/avatars/female09.png';
  static const String avatar10 = 'assets/images/avatars/female10.png';
  static const String avatar11 = 'assets/images/avatars/female11.png';
  static const String avatar12 = 'assets/images/avatars/female12.png';
  static const String avatar13 = 'assets/images/avatars/male01.png';
  static const String avatar14 = 'assets/images/avatars/male02.png';
  static const String avatar15 = 'assets/images/avatars/male03.png';
  static const String avatar16 = 'assets/images/avatars/male04.png';
  static const String avatar17 = 'assets/images/avatars/male05.png';
  static const String avatar18 = 'assets/images/avatars/male06.png';
  static const String avatar19 = 'assets/images/avatars/male07.png';
  static const String avatar20 = 'assets/images/avatars/male08.png';
  static const String avatar21 = 'assets/images/avatars/male09.png';
  static const String avatar22 = 'assets/images/avatars/male10.png';
  static const String avatar23 = 'assets/images/avatars/male11.png';
  static const String avatar24 = 'assets/images/avatars/male12.png';



  static const List<String> avatarImages = <String>[
    avatar00,
    avatar01,
    avatar02,
    avatar03,
    avatar04,
    avatar05,
    avatar06,
    avatar07,
    avatar08,
    avatar09,
    avatar10,
    avatar11,
    avatar12,
    avatar13,
    avatar14,
    avatar15,
    avatar16,
    avatar17,
    avatar18,
    avatar19,
    avatar20,
    avatar21,
    avatar22,
    avatar23,
    avatar24,
  ];

}