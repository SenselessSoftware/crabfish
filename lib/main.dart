
import 'package:crabfish/views/intro_page.dart';

import 'views/money_wheel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cf_constants.dart';
import 'views/cf_game_page.dart';
import 'views/cf_select_image_screen.dart';
import 'models/cf_game.dart';
import 'models/settings_service.dart';
import 'views/settings_page.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        // Provide the SettingsService to the entire widget tree

        ChangeNotifierProvider(
          create: (context) => SettingsService(), // Provide the SettingsService
          child: const MyApp(),
        ),

        // Provide the AppState to the entire widget tree
        ChangeNotifierProvider(
          create: (context) => AppState(),
          child: const MyApp(),
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

      home: const MyHomePage(title: Constants.gameName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final textController = TextEditingController(text: appState.selectionData.playerName1);
    // Ensure cursor is at the end of the text
    textController.selection = TextSelection.fromPosition(TextPosition(offset: textController.text.length));

    final settingsService = context.watch<SettingsService>();
    appState.initPlayerImages();

    if (settingsService.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Main Program')),
        body: const Center(child: CircularProgressIndicator(key: Key("homePageLoader"))), // Added key for testing
      );
    }


    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Game'),
            onPressed: () {
              appState.clearPlayerChoices();
              appState.changeStartingMoney(settingsService.setting1);
              appState.changeStandardBet(settingsService.setting2);
              appState.setPayout2(settingsService.setting3);
              appState.setPayout3(settingsService.setting4);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CfGamePage()),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'Bonus Wheel':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MoneyPage()),
                  );
                  break;
                case 'Intro Page':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IntroPage()),
                  );
                  break;
                case 'Settings':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Bonus Wheel',
                child: ListTile(
                  leading: Icon(Icons.play_arrow),
                  title: Text('Bonus Wheel'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Intro Page',
                child: ListTile(
                  leading: Icon(Icons.play_arrow),
                  title: Text('Instructions'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(4, (index) {
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildImagePlaceholder(index),
                              const SizedBox(height: 10),
                              _buildTextField(index, textController, context),
                              _buildAddMoneyButton(index, context),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(2, (index) {
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildImagePlaceholder(index),
                              const SizedBox(height: 10),
                              _buildTextField(index, textController, context),
                              _buildAddMoneyButton(index, context),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 20), // Spacer between the two rows of items
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(2, (index) {
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildImagePlaceholder(index + 2),
                              const SizedBox(height: 10),
                              _buildTextField(index + 2, textController, context),
                              _buildAddMoneyButton(index+2, context),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildImagePlaceholder(int index) {
    final appState = Provider.of<AppState>(context, listen: false); // listen: false if not rebuilding on change

    return GestureDetector(
      onTap: () {
        if (kDebugMode) {
          print('Image $index clicked');
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CfSelectImageScreen(userId: index)),
        );
      },
      child: Container(
        width: 100, // Adjusted size for better fit in portrait
        height: 100, // Adjusted size for better fit in portrait
        decoration: BoxDecoration(
          color: Colors.grey[300],
          border: Border.all(color: Colors.black54, width: 1), // Optional: add a border
        ),

        child: appState.getPlayerImage(index),
      ),
    );
  }

  Widget _buildTextField(int index, TextEditingController controller, BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false); // listen: false

    String playerName = '${appState.getPlayerName(index)} :  ${appState.getTotalForPlayer(index)}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        playerName,
        style: const TextStyle(fontSize: 14), // Adjusted font size
        textAlign: TextAlign.center, // Center text
        overflow: TextOverflow.ellipsis, // Handle long names
      ),
    );
  }

  Widget _buildAddMoneyButton(int index, BuildContext context)
  {
    final appState = Provider.of<AppState>(context, listen: true); // listen: false if not rebuilding on change

    return ElevatedButton(
      onPressed: () {
        appState.addToTotalForPlayer(index, appState.getStartingMoney());
      },
      child: const Text('Add Points'),
    );
  }

  gotoDropTestActivity(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MoneyPage()),
    );
    if (mounted) { // Check if the widget is still in the tree
      setState(() {
        //do something
      });
    }

  }

}
