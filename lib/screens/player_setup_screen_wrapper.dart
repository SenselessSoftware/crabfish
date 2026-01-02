import 'package:crabfish/models/cf_game.dart';
import 'package:crabfish/models/settings_service.dart';
import 'package:crabfish/screens/cf_game_page.dart';
import 'package:crabfish/screens/settings_page.dart';

import '../providers/player_provider.dart';
import 'package:flutter/material.dart';
import 'package:player_model/player.dart';
import 'package:player_model/screens/player_setup_screen.dart' as pkg;
import 'package:provider/provider.dart';

class PlayerSetupScreenWrapper extends StatelessWidget {
  const PlayerSetupScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    final appState = Provider.of<AppState>(context, listen: false);
    final settingsService = Provider.of<SettingsService>(context, listen: false);

    return pkg.PlayerSetupScreen(
      players: playerProvider.players,
      onPlayersUpdated: (updatedPlayers) {
        for (int i = 0; i < updatedPlayers.length; i++) {
          if (i < playerProvider.players.length) {
            playerProvider.updatePlayer(i, updatedPlayers[i]);
          } else {
            playerProvider.addPlayer(updatedPlayers[i]);
          }
        }
      },
      onContinue: () {
        appState.changeStandardBet(settingsService.setting2);
        appState.setPayout1(settingsService.setting3);
        appState.setPayout2(settingsService.setting4);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CfGamePage(),
          ),
        );
      },
      startingScore: settingsService.startingScore,
      onSettingsPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsPage(),
          ),
        );
      },
    );
  }
}
