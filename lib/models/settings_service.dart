import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p; // For path manipulation

class SettingsService with ChangeNotifier {
  // Define keys for SharedPreferences
  static const String _startingScoreKey = 'starting_score';
  static const String _setting2Key = 'setting_int_2';
  static const String _setting3Key = 'setting_int_3';
  static const String _setting4Key = 'setting_int_4';
  static const String _integrateMoneyWheelKey = 'integrate_money_wheel';

  // Default values
  int _startingScore = 20;    // starting money
  int _setting2 = 1;    // standard bet
  int _setting3 = 3;    // double dice payout multiplier
  int _setting4 = 10;   // triple dice payout multiplier
  bool _integrateMoneyWheel = false;

  bool _isLoading = true; // To track if settings are being loaded

  // Getters for the settings
  int get startingScore => _startingScore;
  int get setting2 => _setting2;
  int get setting3 => _setting3;
  int get setting4 => _setting4;
  bool get integrateMoneyWheel => _integrateMoneyWheel;

  bool get isLoading => _isLoading;

  static const String _profileImagePathKey = 'profile_image_path';
  File? _profileImageFile;

  File? get profileImageFile => _profileImageFile;

  SettingsService() {
    loadSettings();
    loadProfilePicture();
  }

  // Load settings from SharedPreferences
  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners(); // Notify UI that loading has started

    final prefs = await SharedPreferences.getInstance();
    _startingScore = prefs.getInt(_startingScoreKey) ?? _startingScore; // Use default if not found
    _setting2 = prefs.getInt(_setting2Key) ?? _setting2;
    _setting3 = prefs.getInt(_setting3Key) ?? _setting3;
    _setting4 = prefs.getInt(_setting4Key) ?? _setting4;
    _integrateMoneyWheel = prefs.getBool(_integrateMoneyWheelKey) ?? _integrateMoneyWheel;

    _isLoading = false;
    notifyListeners(); // Notify UI that loading is complete and values are updated
    if (kDebugMode) {
      print("Settings Loaded: $_startingScore, $_setting2, $_setting3, $_setting4, $_integrateMoneyWheel");
    }
  }

  // Update a specific setting and save it
  Future<void> updateStartingScore(int newValue) async {
    _startingScore = newValue;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_startingScoreKey, newValue);
    if (kDebugMode) {
      print("Starting Score Updated: $newValue");
    }
  }

  Future<void> updateSetting2(int newValue) async {
    _setting2 = newValue;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_setting2Key, newValue);
    if (kDebugMode) {
      print("Setting 2 Updated: $newValue");
    }
  }

  Future<void> updateSetting3(int newValue) async {
    _setting3 = newValue;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_setting3Key, newValue);
    if (kDebugMode) {
      print("Setting 3 Updated: $newValue");
    }
  }


  Future<void> updateSetting4(int newValue) async {
    _setting4 = newValue;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_setting4Key, newValue);
    if (kDebugMode) {
      print("Setting 4 Updated: $newValue");
    }
  }

  Future<void> updateIntegrateMoneyWheel(bool newValue) async {
    _integrateMoneyWheel = newValue;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_integrateMoneyWheelKey, newValue);
    if (kDebugMode) {
      print("Integrate Money Wheel Updated: $newValue");
    }
  }

  // Optional: Reset all settings to default and save
  Future<void> resetSettings() async {
    _startingScore = 20; // Default value
    _setting2 = 1; // Default value
    _setting3 = 3; // Default value
    _setting4 = 10; // Default value
    _integrateMoneyWheel = false;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_startingScoreKey, _startingScore);
    await prefs.setInt(_setting2Key, _setting2);
    await prefs.setInt(_setting3Key, _setting3);
    await prefs.setInt(_setting4Key, _setting4);
    await prefs.setBool(_integrateMoneyWheelKey, _integrateMoneyWheel);
    if (kDebugMode) {
      print("Settings Reset");
    }
  }


  Future<void> loadProfilePicture() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(_profileImagePathKey);
    if (imagePath != null && await File(imagePath).exists()) {
      _profileImageFile = File(imagePath);
    } else {
      _profileImageFile = null; // Ensure it's null if not found or invalid
    }

    _isLoading = false;
    notifyListeners();
    if (kDebugMode) {
      print("Profile picture loaded from: $imagePath");
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      return result == PermissionStatus.granted;
    }
  }


  Future<void> pickProfilePicture(ImageSource source) async {
    // Request permission
    if (source == ImageSource.camera) {
      if (!await _requestPermission(Permission.camera)) {
        if (kDebugMode) {
          print("Camera permission denied");
        }
        // Optionally: Show a message to the user that permission is required
        return;
      }
    } else {
      // For gallery, permission might be handled by image_picker on newer OS,
      // but explicit request can be good for older OS or for clarity.
      // On Android 13+, use Permission.photos or Permission.videos
      // For older, Permission.storage might be needed.
      // Let's assume image_picker handles gallery permissions for simplicity here,
      // but for production, test thoroughly.
    }


    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source, imageQuality: 70);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);

        // Get a permanent directory to save the image
        final directory = await getApplicationDocumentsDirectory();
        final fileName = p.basename(imageFile.path); // Use path package
        final savedImage = await imageFile.copy('${directory.path}/$fileName');

        _profileImageFile = savedImage;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_profileImagePathKey, savedImage.path);

        notifyListeners();
        if (kDebugMode) {
          print("Profile picture updated and saved to: ${savedImage.path}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error picking profile picture: $e");
      }
      // Handle error, e.g., show a snackbar
    }
  }

  Future<void> removeProfilePicture() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(_profileImagePathKey);

    if (imagePath != null) {
      final fileToDelete = File(imagePath);
      if (await fileToDelete.exists()) {
        try {
          await fileToDelete.delete();
          if (kDebugMode) {
            print("Deleted profile picture from: $imagePath");
          }
        } catch (e) {
          if (kDebugMode) {
            print("Error deleting profile picture file: $e");
          }
        }
      }
    }

    await prefs.remove(_profileImagePathKey);
    _profileImageFile = null;
    notifyListeners();
    if (kDebugMode) {
      print("Profile picture removed.");
    }
  }

}