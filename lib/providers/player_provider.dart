import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:player_model/player.dart';

class PlayerProvider with ChangeNotifier {
  static const String _playersKey = 'players';
  List<Player> _players = [];
  final Uuid _uuid = const Uuid();

  List<Player> get players => _players;

  PlayerProvider() {
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final playersJson = prefs.getString(_playersKey);
    if (playersJson != null) {
      final List<dynamic> decodedPlayers = json.decode(playersJson);
      _players = decodedPlayers.map((playerMap) => Player.fromMap(playerMap)).toList();
      notifyListeners();
    }
  }

  Future<void> _savePlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final playersJson = json.encode(_players.map((player) => player.toMap()).toList());
    await prefs.setString(_playersKey, playersJson);
  }

  void addPlayer(Player player) {
    final newPlayer = Player(
      id: _uuid.v4(),
      name: player.name,
      imagePath: player.imagePath,
      score: player.score,
    );
    _players.add(newPlayer);
    _savePlayers();
    notifyListeners();
  }

  void updatePlayer(int index, Player player) {
    if (player.id == null) {
      _players[index] = Player(
        id: _players[index].id ?? _uuid.v4(),
        name: player.name,
        imagePath: player.imagePath,
        score: player.score,
      );
    } else {
      _players[index] = player;
    }
    _savePlayers();
    notifyListeners();
  }

  void deletePlayer(int index) {
    _players.removeAt(index);
    _savePlayers();
    notifyListeners();
  }

  void clearAllScores(int startingScore) {
    for (var player in _players) {
      player.score = startingScore;
    }
    _savePlayers();
    notifyListeners();
  }
}
