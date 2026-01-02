import 'package:crabfish/models/settings_service.dart';
import 'package:crabfish/screens/profile_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cf_game.dart';
import 'cf_select_avatar_screen.dart';

/*
class CfSelectImageScreen extends StatefulWidget { // ignore: must_be_immutable
  CfSelectImageScreen({super.key, this.userId});
  int? userId;

  @override
  State<CfSelectImageScreen> createState() => _CfSelectImageScreenState(userId: userId);
}

class _CfSelectImageScreenState extends State<CfSelectImageScreen> {
  _CfSelectImageScreenState({this.userId});
  final int? userId;

  int? _selectedImageIndex;
  final TextEditingController _textEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final profileService = context.watch<SettingsService>();
    int index = 0;

    Widget selectedSmartImage = appState.getPlayerImage(userId!);
    _textEditingController.text = appState.getPlayerName(userId!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Player Image and Name'),
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Press Camera to take or select a picture of yourself or press Avatar to choose an Avatar Image:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Container(
                  width: 120, // Adjust width as needed
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedImageIndex == index
                          ? Colors.blue
                          : Colors.grey,
                      width: _selectedImageIndex == index ? 3.0 : 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7.0),
                    child:
                      selectedSmartImage,
                  ),
                ),

                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileSettingsPage()),
                    );
                    if (mounted) { // Check if the widget is still in the tree
                      setState(() {
                        appState.setPlayerImageFile(userId!, profileService.profileImageFile!);
                        selectedSmartImage = appState.getPlayerImage(userId!);
                      });
                    }
                  },
                  child: const Text('Camera'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CfSelectAvatarScreen()),
                    );
                    if (mounted) { // Check if the widget is still in the tree
                      setState(() {
                        appState.setPlayerImageAsset(userId!, appState.getSelectedImage());
                        selectedSmartImage = appState.getPlayerImage(userId!);
                      });
                    }
                  },
                  child: const Text('Avatar'),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Text(
              'Enter your name below:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: 'Name:',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (
                    _textEditingController.text.isNotEmpty) {
                  // Handle the selected image and text
                  appState.updatePlayerName(userId!, _textEditingController.text);
                  Navigator.pop(context);

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select an image and enter text.'),
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}

 */