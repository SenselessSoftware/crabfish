import 'package:crabfish/providers/player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/settings_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _startingScoreController;
  late TextEditingController _setting2Controller;
  late TextEditingController _setting3Controller;
  late TextEditingController _setting4Controller;

  @override
  void initState() {
    super.initState();
    final settingsService = context.read<SettingsService>();
    _startingScoreController = TextEditingController(text: settingsService.startingScore.toString());
    _setting2Controller = TextEditingController(text: settingsService.setting2.toString());
    _setting3Controller = TextEditingController(text: settingsService.setting3.toString());
    _setting4Controller = TextEditingController(text: settingsService.setting4.toString());
  }

  @override
  void dispose() {
    _startingScoreController.dispose();
    _setting2Controller.dispose();
    _setting3Controller.dispose();
    _setting4Controller.dispose();
    super.dispose();
  }

  void _saveSettings() {
    final settingsService = context.read<SettingsService>();
    String? invalidField;

    final int? startingScore = int.tryParse(_startingScoreController.text);
    if (startingScore != null) {
      if (settingsService.startingScore != startingScore) settingsService.updateStartingScore(startingScore);
    } else {
      invalidField ??= 'Starting Score';
    }

    final int? setting2 = int.tryParse(_setting2Controller.text);
    if (setting2 != null) {
      if (settingsService.setting2 != setting2) settingsService.updateSetting2(setting2);
    } else {
      invalidField ??= 'Standard Bet Amount';
    }

    final int? setting3 = int.tryParse(_setting3Controller.text);
    if (setting3 != null) {
      if (settingsService.setting3 != setting3) settingsService.updateSetting3(setting3);
    } else {
      invalidField ??= 'Double Dice Winnings Multiplier';
    }

    final int? setting4 = int.tryParse(_setting4Controller.text);
    if (setting4 != null) {
      if (settingsService.setting4 != setting4) settingsService.updateSetting4(setting4);
    } else {
      invalidField ??= 'Triple Dice Winnings Multiplier';
    }

    if (invalidField == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid input for "$invalidField". Please enter a number.')),
      );
    }
    FocusScope.of(context).unfocus();
  }

  Future<void> _resetAllScores() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Reset'),
          content: const Text('Are you sure you want to reset all player scores? This cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Reset Scores'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      final settingsService = context.read<SettingsService>();
      context.read<PlayerProvider>().clearAllScores(settingsService.startingScore);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All player scores have been reset.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsService = context.watch<SettingsService>();

    if (settingsService.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: _saveSettings,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset to Defaults',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Reset'),
                    content: const Text('Are you sure you want to reset all settings to their default values?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: const Text('Reset'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  );
                },
              );
              if (confirm == true) {
                context.read<SettingsService>().resetSettings();
                
                final newSettings = context.read<SettingsService>();
                setState(() {
                  _startingScoreController.text = newSettings.startingScore.toString();
                  _setting2Controller.text = newSettings.setting2.toString();
                  _setting3Controller.text = newSettings.setting3.toString();
                  _setting4Controller.text = newSettings.setting4.toString();
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings reset to defaults.')),
                );
              }
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
           _buildIntegerSettingTile(
            title: 'Starting Score: ',
            controller: _startingScoreController,
          ),
          const Divider(),
          _buildIntegerSettingTile(
            title: 'Standard Bet Amount: ',
            controller: _setting2Controller,
          ),
          const Divider(),
          _buildIntegerSettingTile(
            title: 'Double Dice Winnings Multiplier: ',
            controller: _setting3Controller,
          ),
          const Divider(),
          _buildIntegerSettingTile(
            title: 'Triple Dice Winnings Multiplier: ',
            controller: _setting4Controller,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Integrate Money Wheel'),
            value: settingsService.integrateMoneyWheel,
            onChanged: (bool value) {
              settingsService.updateIntegrateMoneyWheel(value);
            },
          ),
          const Divider(height: 32),
          ElevatedButton.icon(
            icon: const Icon(Icons.reorder),
            label: const Text('Reset All Player Scores'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: _resetAllScores,
          ),
        ],
      ),
    );
  }

  Widget _buildIntegerSettingTile({
    required String title,
    required TextEditingController controller,
  }) {
    return ListTile(
      title: Text(title),
      trailing: SizedBox(
        width: 80, // Adjust width as needed
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.right,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
          ),
        ),
      ),
    );
  }
}
