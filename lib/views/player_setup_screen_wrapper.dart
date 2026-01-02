import 'package:crabfish/views/cf_game_page.dart';
import 'package:crabfish/views/settings_page.dart';

import '../providers/player_provider.dart';
import 'package:flutter/material.dart';
import 'package:player_model/player.dart';
import 'package:player_model/screens/player_setup_screen.dart' as pkg;
import 'package:provider/provider.dart';

/*
class PlayerSetupScreenWrapper extends StatelessWidget {
  const PlayerSetupScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CfGamePage(),
          ),
        );
      },
      onSettingsPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsPage(),
          ),
        );
      },
      /*
      playerCardActionsBuilder: (BuildContext context, int index) { // Add this builder
        return ElevatedButton(
          onPressed: () {
            final player = playerProvider.players[index];
            final updatedPlayer = Player(
              id: player.id,
              name: player.name,
              imagePath: player.imagePath,
              score: player.score + 20,
            );
            playerProvider.updatePlayer(index, updatedPlayer);
          },
          child: const Text('Add Score'),
        );
      },
      */
    );
  }
}

 */
