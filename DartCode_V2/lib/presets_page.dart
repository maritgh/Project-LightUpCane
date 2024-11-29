import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'bottom_nav_bar.dart';

class PresetsPage extends StatefulWidget {
  const PresetsPage({Key? key}) : super(key: key);

  @override
  _PresetsPageState createState() => _PresetsPageState();
}

class _PresetsPageState extends State<PresetsPage> {
  // List of preset names
  List<String> presets = ["Preset_1", "Preset_2"];
  String? selectedPreset;

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
                      'PRESETS',
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
            // Adding space between the title and presets
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
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: _buildPresetTile(preset, maxWidth, screenWidth, themeProvider),
                                    ))
                                .toList(),
                          )
                        : _buildPresetOptions(screenWidth, maxWidth, themeProvider);
                  },
                ),
              ),
            ),
            if (selectedPreset == null) _buildSaveButton(screenWidth, screenHeight, themeProvider),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentPage: "Presets"),
    );
  }

  // Widget to build each preset tile in the list
  Widget _buildPresetTile(String preset, double maxWidth, double screenWidth, ThemeProvider themeProvider) {
    return GestureDetector(
      onTap: () => setState(() => selectedPreset = preset),
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

  // Widget to build the preset options when a preset is selected
  Widget _buildPresetOptions(double screenWidth, double maxWidth, ThemeProvider themeProvider) {
    return Column(
      children: [
        _buildOptionButton("SELECT", screenWidth, themeProvider),
        _buildOptionButton("RENAME", screenWidth, themeProvider, onPressed: _showRenameDialog),
        _buildOptionButton("DELETE", screenWidth, themeProvider, onPressed: () {
          setState(() {
            presets.remove(selectedPreset);
            selectedPreset = null;
          });
        }),
        _buildOptionButton("BACK", screenWidth, themeProvider, onPressed: () => setState(() => selectedPreset = null)),
      ],
    );
  }

  // Helper to build each option button in the preset options menu
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

  // Widget for the Save button at the bottom of the page
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
          "SAVE",
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Method to show a dialog to save a new preset with a custom name
  void _showSaveDialog() {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Save New Preset"),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "Enter preset name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  if (nameController.text.isNotEmpty) {
                    presets.add(nameController.text);
                  }
                });
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Method to show a dialog for renaming the selected preset
  void _showRenameDialog() {
    TextEditingController renameController = TextEditingController(text: selectedPreset);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Rename Preset"),
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
                    selectedPreset = renameController.text;
                  }
                });
                Navigator.pop(context);
              },
              child: Text("Rename"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
