import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'generated/l10n.dart';
import 'theme_provider.dart';
import 'notification_provider.dart';
import 'bottom_nav_bar.dart';

class PresetsPage extends StatefulWidget {
  const PresetsPage({Key? key}) : super(key: key);

  @override
  _PresetsPageState createState() => _PresetsPageState();
}

class _PresetsPageState extends State<PresetsPage> {
  late Box _settingsBox; // Hive storage box
  List<String> presets = []; // List of saved presets
  String? selectedPreset; // Currently selected preset
  bool notificationsEnabled = false; // Notification toggle

  @override
  void initState() {
    super.initState();
    _initializeMemory();
  }

  // Initializes the Hive storage box and loads saved presets
  Future<void> _initializeMemory() async {
    _settingsBox = await Hive.openBox('presetsBox');
    setState(() {
      presets = List<String>.from(_settingsBox.get('presets', defaultValue: []));
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? Colors.grey[800]
          : Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            // Presets title container
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Center(
                child: Container(
                  width: screenWidth * 0.8,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                  decoration: BoxDecoration(
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.grey[850]
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      S.of(context).presets,
                      style: TextStyle(
                        color: themeProvider.accentColor,
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double maxWidth = constraints.maxWidth - 40;
                    return selectedPreset == null
                        ? ListView(
                            children: presets
                                .map((preset) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: _buildPresetTile(preset, maxWidth,
                                          screenWidth, themeProvider),
                                    ))
                                .toList(),
                          )
                        : _buildPresetOptions(screenWidth, maxWidth, themeProvider);
                  },
                ),
              ),
            ),
            if (selectedPreset == null)
              _buildSaveButton(screenWidth, screenHeight, themeProvider),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentPage: "Presets"),
    );
  }

  // Builds a tile for each preset in the list
  Widget _buildPresetTile(String preset, double maxWidth, double screenWidth, ThemeProvider themeProvider) {
    return GestureDetector(
      onTap: () => setState(() {
        selectedPreset = preset;
        _loadPresetIntoTempStorage(preset);
      }),
      child: Container(
        width: maxWidth,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: themeProvider.themeMode == ThemeMode.dark
              ? Colors.grey[850]
              : Colors.grey[400],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            preset,
            style: TextStyle(
              color: themeProvider.accentColor,
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPresetOptions(double screenWidth, double maxWidth, ThemeProvider themeProvider) {
    return Column(
      children: [
        _buildOptionButton(S.of(context).select, screenWidth, themeProvider, onPressed: () {
          _applyPresetSettings();
          setState(() => selectedPreset = null);
        }),
        _buildOptionButton(S.of(context).rename, screenWidth, themeProvider, onPressed: _showRenameDialog),
        _buildOptionButton(S.of(context).delete, screenWidth, themeProvider, onPressed: () {
          setState(() {
            _settingsBox.delete(selectedPreset);
            presets.remove(selectedPreset);
            _savePresets();
            selectedPreset = null;
          });
        }),
        _buildOptionButton(S.of(context).back, screenWidth, themeProvider, onPressed: () => setState(() => selectedPreset = null)),
      ],
    );
  }

  Widget _buildOptionButton(String label, double screenWidth, ThemeProvider themeProvider, {VoidCallback? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: themeProvider.themeMode == ThemeMode.dark
              ? Colors.grey[850]
              : Colors.grey[400],
          minimumSize: Size(double.infinity, 50),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(double screenWidth, double screenHeight, ThemeProvider themeProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
      child: ElevatedButton(
        onPressed: _showSaveDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: themeProvider.themeMode == ThemeMode.dark
              ? Colors.grey[850]
              : Colors.grey[400],
          padding: EdgeInsets.symmetric(vertical: 15),
          minimumSize: Size(screenWidth * 0.8, 50),
        ),
        child: Text(
          S.of(context).save,
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Saves the preset settings into Hive storage
  void _savePreset(String presetName) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    _settingsBox.put(presetName, {
      'themeMode': themeProvider.themeMode.toString(),
      'accentColor': themeProvider.accentColor.value,
      'notificationsEnabled': notificationProvider.notifications,
      'hapticEnabled': notificationProvider.haptic,
      'hapticIntensity': notificationProvider.hapticIntensity,
      'buzzerEnabled': notificationProvider.buzzer,
      'buzzerIntensity': notificationProvider.buzzerIntensity,
      'lightIntensity': notificationProvider.lightIntensity,
    });
  }

  // Loads selected preset settings into temporary storage
  void _loadPresetIntoTempStorage(String presetName) {
    final presetData = _settingsBox.get(presetName, defaultValue: {});
    if (presetData.isNotEmpty) {
      notificationsEnabled = presetData['notificationsEnabled'] ?? false;
    }
  }

  void _applyPresetSettings() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    final presetData = _settingsBox.get(selectedPreset, defaultValue: {});

    if (presetData.isNotEmpty) {
      themeProvider.setThemeMode(
        presetData['themeMode'] == 'ThemeMode.dark'
            ? ThemeMode.dark
            : ThemeMode.light,
      );
      themeProvider.setAccentColor(Color(presetData['accentColor']));

      // Notifications
      notificationProvider.setNotifications(presetData['notificationsEnabled'] ?? false);

      // Haptic
      notificationProvider.setHaptic(presetData['hapticEnabled'] ?? false);
      notificationProvider.setHapticIntensity(presetData['hapticIntensity'] ?? 0.0);

      // Buzzer
      notificationProvider.setBuzzer(presetData['buzzerEnabled'] ?? false);
      notificationProvider.setBuzzerIntensity(presetData['buzzerIntensity'] ?? 0.0);

      // Light
      notificationProvider.setLightIntensity(presetData['lightIntensity'] ?? S.of(context).low);
    }
  }

  void _savePresets() {
    _settingsBox.put('presets', presets);
  }

  void _showSaveDialog() {
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).save_new_preset),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(hintText: S.of(context).enter_preset_name),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                if (nameController.text.isNotEmpty) {
                  presets.add(nameController.text);
                  _savePreset(nameController.text);
                  _savePresets();
                }
              });
              Navigator.pop(context);
            },
            child: Text(S.of(context).confirm_save),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).cancel),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog() {
    TextEditingController renameController = TextEditingController(text: selectedPreset);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).rename_preset),
        content: TextField(
          controller: renameController,
          decoration: InputDecoration(hintText: "Enter new name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                if (renameController.text.isNotEmpty) {
                  int index = presets.indexOf(selectedPreset!);
                  presets[index] = renameController.text;
                  _settingsBox.delete(selectedPreset);
                  _savePreset(renameController.text);
                  selectedPreset = renameController.text;
                  _savePresets();
                }
              });
              Navigator.pop(context);
            },
            child: Text(S.of(context).confirm_rename),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).cancel),
          ),
        ],
      ),
    );
  }
}
