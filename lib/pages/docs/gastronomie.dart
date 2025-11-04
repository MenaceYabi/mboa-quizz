import 'package:flutter/material.dart'; 
class GastronomieDoc extends StatelessWidget { 
  const GastronomieDoc({super.key});


 @override 
 Widget build(BuildContext context)
  { 
    return Scaffold
    ( appBar: AppBar(title: const Text('Gastronomie')), 
    body: ListView( children: const [ Padding(padding: EdgeInsets.all(12.0), child: Text('Plongez dans les saveurs du Cameroun : recettes, ingrédients locaux et traditions culinaires des régions.')), Divider(), ListTile(title: Text('Plats emblématiques'), subtitle: Text('Ndolé, Achu, Koki, etc.')), ListTile(title: Text('Ingrédients locaux'), subtitle: Text('Noix de palme, igname, manioc, piments.')), 
    ListTile(title: 
    Text('Fêtes et gastronomie'),
     subtitle: Text('Recettes associées aux célébrations.'))
     , Divider(), 
     Padding(padding: EdgeInsets.all(12.0), 
     child: 
     Text('Actualités', style: 
     TextStyle(fontWeight: FontWeight.bold))), ListTile(leading: Icon(Icons.article), title: Text('Festival gastronomique annuel'), subtitle: Text('05/11/2025')), ], ), ); } }

