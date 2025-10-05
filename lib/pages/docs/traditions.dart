import 'package:flutter/material.dart';

class TraditionsDoc extends StatelessWidget {
  const TraditionsDoc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Traditions')),
      body: ListView(
        children: const [
          Padding(padding: EdgeInsets.all(12.0), child: Text('Musique, danses, artisanat et cérémonies — plongez dans les traditions vivantes du pays.')),
          Divider(),
          ListTile(title: Text('Musique et danse'), subtitle: Text('Instruments et danses traditionnelles.')),
          ListTile(title: Text('Artisanat'), subtitle: Text('Tissages, sculptures, bijoux.')),
          Divider(),
          Padding(padding: EdgeInsets.all(12.0), child: Text('Actualités', style: TextStyle(fontWeight: FontWeight.bold))),
          ListTile(leading: Icon(Icons.article), title: Text('Atelier d\'artisanat local'), subtitle: Text('01/09/2025')),
        ],
      ),
    );
  }
}
