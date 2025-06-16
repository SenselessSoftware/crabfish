import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/settings_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use context.watch to rebuild when settings change
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
                // Use context.read for one-time actions like this
                context.read<SettingsService>().resetSettings();
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
          /*
          _buildIntegerSettingTile(
            context: context,
            title: 'Starting Bet: ',
            currentValue: settingsService.setting1,
            onChanged: (newValue) {
              context.read<SettingsService>().updateSetting1(newValue);
            },
          ),

           */

          _buildIntegerSettingTile(
            context: context,
            title: 'Standard Bet Amount: ',
            currentValue: settingsService.setting2,
            onChanged: (newValue) {
              context.read<SettingsService>().updateSetting2(newValue);
            },
          ),
          const Divider(),
          _buildIntegerSettingTile(
            context: context,
            title: 'Double Dice Winnings Multiplier: ',
            currentValue: settingsService.setting3,
            onChanged: (newValue) {
              context.read<SettingsService>().updateSetting3(newValue);
            },
          ),
          const Divider(),
          _buildIntegerSettingTile(
            context: context,
            title: 'Triple Dice Winnings Multiplier: ',
            currentValue: settingsService.setting4,
            onChanged: (newValue) {
              context.read<SettingsService>().updateSetting4(newValue);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIntegerSettingTile({
    required BuildContext context,
    required String title,
    required int currentValue,
    required ValueChanged<int> onChanged,
  }) {
    final TextEditingController controller = TextEditingController(text: currentValue.toString());
    // Ensure cursor is at the end if you tap to edit
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));


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
          onSubmitted: (value) {
            final int? newValue = int.tryParse(value);
            if (newValue != null) {
              onChanged(newValue);
            } else {
              // Reset to current value if input is invalid
              controller.text = currentValue.toString();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invalid input. Please enter a number.')),
              );
            }
          },
          // Optional: Update on focus lost as well
          onTapOutside: (event){
            final int? newValue = int.tryParse(controller.text);
            if (newValue != null && newValue != currentValue) {
              onChanged(newValue);
            } else if (newValue == null) {
              controller.text = currentValue.toString();
            }
            FocusScope.of(context).unfocus(); // Dismiss keyboard
          },
        ),
      ),
    );
  }
}