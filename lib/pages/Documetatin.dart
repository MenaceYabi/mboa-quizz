
// ignore_for_file: file_names

import 'package:flutter/material.dart';




class DocumentationPage extends StatelessWidget {
  const DocumentationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documentation & Actualités'),
      ),  
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: documentationData.entries.map((e) {
            final title = e.key;
            final image = e.value['image'] as String?;
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ThemeDocPage(themeKey: title)),
              ),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: image != null
                            ? Image.asset(image, fit: BoxFit.cover)
                            : Container(color: Colors.grey[300]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ThemeDocPage extends StatelessWidget {
  final String themeKey;
  const ThemeDocPage({Key? key, required this.themeKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = documentationData[themeKey]!;
    final sections = data['sections'] as List<dynamic>;
    final news = data['news'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(themeKey),
      ),
      body: ListView(
        children: [
          if (data['image'] != null)
            Image.asset(data['image'], fit: BoxFit.cover, height: 180, width: double.infinity),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Introduction', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(data['intro']),
                const SizedBox(height: 16),
                ...sections.map((s) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(s['content']),
                        ],
                      ),
                    )),
                const SizedBox(height: 20),
                Text('Actualités', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                ...news.map((n) => ListTile(
                      leading: const Icon(Icons.article),
                      title: Text(n['title']),
                      subtitle: Text(n['date']),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(n['title']),
                            content: Text('Détails de l\'actualité : "${n['title']}" datée ${n['date']}.'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer'))
                            ],
                          ),
                        );
                      },
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final Map<String, dynamic> documentationData = {
  'Gastronomie': {
    'image': 'images/gastronomie.jpg',
    'intro':
        'Plongez dans les saveurs du Cameroun : recettes, ingrédients locaux et traditions culinaires des régions.',
    'sections': [
      {
        'title': 'Plats emblématiques',
        'content': 'Ndolé, Achu, Koki, eru et autres spécialités régionales.'
      },
      {
        'title': 'Ingrédients locaux',
        'content': 'Noix de palme, igname, manioc, piments et arachides.'
      },
      {
        'title': 'Fêtes et gastronomie',
        'content': 'Recettes associées aux grandes célébrations et rites traditionnels.'
      },
    ],
    'news': [
      {'title': 'Festival gastronomique annuel', 'date': '05/11/2025'},
    ],
  },

  'Géographie': {
    'image': 'images/geographie.jpg',
    'intro':
        'Reliefs, climats et biodiversité du Cameroun, du littoral aux montagnes et forêts tropicales.',
    'sections': [
      {
        'title': 'Régions naturelles',
        'content': 'Plaines côtières, hautes terres, forêts et savanes.'
      },
      {'title': 'Ressources', 'content': 'Eau, minéraux et biodiversité.'},
    ],
    'news': [
      {'title': 'Projet de conservation lancé', 'date': '20/08/2025'},
    ],
  },

  'Social': {
    'image': 'images/Social.jpg',
    'intro':
        'Aspects sociaux : langues, traditions, éducation et dynamiques urbaines.',
    'sections': [
      {
        'title': 'Sociétés et langues',
        'content': 'Pluralité linguistique et diversité culturelle du Cameroun.'
      },
      {
        'title': 'Éducation',
        'content': 'Systèmes scolaires, initiatives communautaires et réformes.'
      },
    ],
    'news': [
      {'title': 'Nouvelle politique éducative', 'date': '15/07/2025'},
    ],
  },

  'Traditions': {
    'image': 'images/Traditions.jpg',
    'intro':
        'Musique, danses, artisanat et cérémonies — plongez dans les traditions vivantes du pays.',
    'sections': [
      {
        'title': 'Musique et danse',
        'content': 'Instruments, rythmes et danses traditionnelles.'
      },
      {'title': 'Artisanat', 'content': 'Tissages, sculptures et bijoux locaux.'},
    ],
    'news': [
      {'title': 'Atelier d\'artisanat local', 'date': '01/09/2025'},
    ],
  },
};
