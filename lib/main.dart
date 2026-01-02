import 'package:crabfish/providers/player_provider.dart';
import 'package:crabfish/screens/player_setup_screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cf_constants.dart';
import 'models/settings_service.dart';
import 'models/cf_game.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SettingsService(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppState(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlayerProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.gameName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      home: const PlayerSetupScreenWrapper(),
    );
  }
}
