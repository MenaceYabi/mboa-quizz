
// ignore_for_file: use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParametresPage extends StatefulWidget {
  const ParametresPage({Key? key}) : super(key: key);

  @override
  State<ParametresPage> createState() => _ParametresPageState();
}

class _ParametresPageState extends State<ParametresPage> {
  String _language = 'fr';
  bool _darkTheme = false;
  bool _notifications = true;
  MaterialColor _primaryColor = Colors.blue;

  final Map<String, String> _languages = {
    'fr': 'Français',
    'en': 'English',
  };

  final List<MaterialColor> _colorOptions = [
    Colors.blue,
    Colors.green,
    Colors.teal,
    Colors.purple,
    Colors.orange,
    Colors.grey,
  ];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _language = prefs.getString('language') ?? 'fr';
      _darkTheme = prefs.getBool('darkTheme') ?? false;
      _notifications = prefs.getBool('notifications') ?? true;
      final colorIndex = prefs.getInt('primaryColor') ?? 0;
      if (colorIndex >= 0 && colorIndex < _colorOptions.length) {
        _primaryColor = _colorOptions[colorIndex];
      }
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', _language);
    await prefs.setBool('darkTheme', _darkTheme);
    await prefs.setBool('notifications', _notifications);
    final colorIndex = _colorOptions.indexOf(_primaryColor);
    await prefs.setInt('primaryColor', colorIndex);
  }

  void _onLanguageChanged(String? val) {
    if (val == null) return;
    setState(() => _language = val);
    _savePreferences();
  }

  void _onThemeChanged(bool val) {
    setState(() => _darkTheme = val);
    _savePreferences();
  }

  void _onNotificationsChanged(bool val) {
    setState(() => _notifications = val);
    _savePreferences();
  }

  void _onColorSelected(MaterialColor color) {
    setState(() => _primaryColor = color);
    _savePreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: _primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Langue'),
              subtitle: Text(_languages[_language] ?? ''),
              onTap: () async {
                final selected = await showDialog<String>(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: const Text('Choisir la langue'),
                    children: _languages.entries
                        .map((e) => RadioListTile<String>(
                              value: e.key,
                              groupValue: _language,
                              title: Text(e.value),
                              onChanged: (v) => Navigator.pop(context, v),
                            ))
                        .toList(),
                  ),
                );
                if (selected != null) {
                  _onLanguageChanged(selected);
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.palette),
              title: const Text('Thème sombre'),
              value: _darkTheme,
              onChanged: _onThemeChanged,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Couleur principale'),
              subtitle: const Text('Choisissez une couleur pour l\'application'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: _colorOptions
                    .map((c) => GestureDetector(
                          onTap: () => _onColorSelected(c),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: _primaryColor == c
                                  ? Border.all(color: Colors.black, width: 2)
                                  : null,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              subtitle: const Text('Activer / désactiver les notifications'),
              value: _notifications,
              onChanged: _onNotificationsChanged,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () async {
              await _savePreferences();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Paramètres enregistrés')),
              );
            },
            icon: const Icon(Icons.save),
            label: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
