import 'package:flutter/material.dart';

class HistoireDoc extends StatelessWidget {
  const HistoireDoc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histoire')),
      body: ListView(
        children: const [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('Découvrez l\'histoire riche et variée du Cameroun, des royaumes pré-coloniaux aux mouvements d\'indépendance.'),
          ),
          Divider(),
          ListTile(title: Text('Périodes précoloniales'), subtitle: Text('Description des royaumes, chefferies et sociétés traditionnelles.')),
          ListTile(title: Text('Colonisation'), subtitle: Text('Impact des puissances coloniales et transformations sociales.')),
          ListTile(title: Text('Indépendance'), subtitle: Text('Le chemin vers l\'indépendance et les figures marquantes.')),
          Divider(),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('Actualités', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(leading: Icon(Icons.article), title: Text('Nouvelle exposition sur l\'histoire locale'), subtitle: Text('10/10/2025')),
          ListTile(leading: Icon(Icons.article), title: Text('Restauration d\'un site historique'), subtitle: Text('02/09/2025')),
        ],
      ),
    );
  }
}
