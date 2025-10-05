import 'package:flutter/material.dart';
import 'package:mboaquizz/pages/histoire_questions.dart';
import 'package:mboaquizz/pages/gastronomie_questions.dart';
import 'package:mboaquizz/pages/geographie_questions.dart';
import 'package:mboaquizz/pages/social_questions.dart';
import 'package:mboaquizz/pages/traditions_questions.dart';
import 'package:mboaquizz/pages/Parametres.dart';
import 'package:mboaquizz/pages/Documetatin.dart';
import 'package:mboaquizz/pages/communaute_page.dart';
import 'package:mboaquizz/pages/profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> quizThemes = [
    {
      'title': 'Histoire',
      'image': 'images/Histoire.jpg',
      'page': const HistoireQuestionsPage(),
    },
    {
      'title': 'Gastronomie',
      'image': 'images/gastronomie.jpg',
      'page': const GastronomieQuestionsPage(),
    },
    {
      'title': 'Géographie',
      'image': 'images/geographie.jpg',
      'page': const GeographieQuestionsPage(),
    },
    {
      'title': 'Social',
      'image': 'images/Social.jpg',
      'page': const SocialQuestionsPage(),
    },
    {
      'title': 'Traditions',
      'image': 'images/Traditions.jpg',
      'page': const TraditionsQuestionsPage(),
    },
  ];

    final List<Widget> _tabs = [
    // Accueil
    Container(),
    // Documentation
    const DocumentationPage(),
    // Communauté
    const CommunautePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mboa Quizz'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Nom du joueur'),
              accountEmail: Text(''),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
              ),
              decoration: BoxDecoration(color: Colors.green),
            ),
          
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Paramètres'),
              onTap: () {
                Navigator.pop(context); // close drawer
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ParametresPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('À propos'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: _selectedIndex == 0
          ? GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: quizThemes.length,
              itemBuilder: (context, index) {
                final theme = quizThemes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => theme['page']),
                    );
                  },
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            theme['image'],
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          theme['title'],
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Documentation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Communauté',
          ),
        ],
      ),
    );
  }
}
          