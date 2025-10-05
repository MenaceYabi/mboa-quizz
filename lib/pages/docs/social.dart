import 'package:flutter/material.dart';

class SocialDoc extends StatelessWidget {
  const SocialDoc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social')),
      body: ListView(
        children: const [
          Padding(padding: EdgeInsets.all(12.0), child: Text('Aspects sociaux : langues, traditions, éducation et dynamiques urbaines.')),
          Divider(),
          ListTile(title: Text('Sociétés et langues'), subtitle: Text('Pluralité linguistique et culturelle.')),
          ListTile(title: Text('Éducation'), subtitle: Text('Systèmes scolaires et initiatives.')),
          Divider(),
          Padding(padding: EdgeInsets.all(12.0), child: Text('Actualités', style: TextStyle(fontWeight: FontWeight.bold))),
          ListTile(leading: Icon(Icons.article), title: Text('Nouvelle politique éducative'), subtitle: Text('15/07/2025')),
        ],
      ),
    );
  }
}
