
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../cf_constants.dart';
import '../models/cf_game.dart';

class CfSelectAvatarScreen extends StatefulWidget { // ignore: must_be_immutable
  CfSelectAvatarScreen({super.key, this.userId});
  int? userId;

  @override
  State<CfSelectAvatarScreen> createState() => CfSelectAvatarScreenState(userId: userId);
}

class CfSelectAvatarScreenState extends State<CfSelectAvatarScreen> {
  CfSelectAvatarScreenState({this.userId});
  final int? userId;

  int? _selectedImageIndex;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Avatar and Enter Text'),
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select an Avatar (scroll left to see more choices):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Row(
              children: [

                Expanded(
                  child: SizedBox(
                    height: 150, // Adjust height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: Constants.avatarImages.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedImageIndex = index;
                            });
                          },
                          child: Container(
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
                              child: Image.asset(
                                Constants.avatarImages[index],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedImageIndex != null) {
                  // Handle the selected image
                  appState.setSelectedImage(Constants.avatarImages[_selectedImageIndex!]);

                  Navigator.pop(context);

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select an image.'),
                    ),
                  );
                  if (kDebugMode) {
                    print("no image selected");
                  }
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

}