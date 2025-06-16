//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/settings_service.dart';
//import '../controllers/profile_service.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  Future<void> _showImageSourceDialog(BuildContext context, SettingsService profileService) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Camera'),
                  ),
                  onTap: () {
                    profileService.pickProfilePicture(ImageSource.camera);

                    Navigator.of(dialogContext).pop();
                  },
                ),
                const Divider(),
                GestureDetector(
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Gallery'),
                  ),
                  onTap: () {
                    profileService.pickProfilePicture(ImageSource.gallery);
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileService = context.watch<SettingsService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () => _showImageSourceDialog(context, context.read<SettingsService>()),
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: profileService.profileImageFile != null
                      ? FileImage(profileService.profileImageFile!)
                      : null,
                  child: profileService.profileImageFile == null
                      ? Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: Colors.grey.shade700,
                  )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_camera),
                label: const Text('Change Picture'),
                onPressed: () => _showImageSourceDialog(context, context.read<SettingsService>()),
              ),
              const SizedBox(height: 10),
              if (profileService.profileImageFile != null)
                TextButton.icon(
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
                  label: Text(
                    'Remove Picture',
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Confirm Remove'),
                          content: const Text('Are you sure you want to remove your profile picture?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () => Navigator.of(dialogContext).pop(false),
                            ),
                            TextButton(
                              child: const Text('Remove'),
                              onPressed: () => Navigator.of(dialogContext).pop(true),
                            ),
                          ],
                        );
                      },
                    );
                    if (confirm == true) {
                      context.read<SettingsService>().removeProfilePicture();
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}