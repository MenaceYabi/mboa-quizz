import 'package:flutter/material.dart';

class GeographieDoc extends StatelessWidget {
  const GeographieDoc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Géographie')),
      body: ListView(
        children: const [
          Padding(padding: EdgeInsets.all(12.0), child: Text('Reliefs, climats et biodiversité du Cameroun, du littoral aux montagnes et forêts tropicales.')),
          Divider(),
          ListTile(title: Text('Régions naturelles'), subtitle: Text('Plaines côtières, hautes terres, forêts et savanes.')),
          ListTile(title: Text('Ressources'), subtitle: Text('Eau, minéraux, biodiversité.')),
          Divider(),
          Padding(padding: EdgeInsets.all(12.0), child: Text('Actualités', style: TextStyle(fontWeight: FontWeight.bold))),
          ListTile(leading: Icon(Icons.article), title: Text('Projet de conservation lancé'), subtitle: Text('20/08/2025')),
        ],
      ),
    );
  }
}
