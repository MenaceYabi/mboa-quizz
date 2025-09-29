import 'package:flutter/material.dart';
import 'registration_form.dart';

class CarouselScreen extends StatefulWidget {
  const CarouselScreen({Key? key}) : super(key: key);

  @override
  State<CarouselScreen> createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  final List<Map<String, String>> themes = [
    {
      'title': 'Histoire',
      'image': 'images/Histoire.jpg',
    },
    {
      'title': 'Gastronomie',
      'image': 'images/gastronomie.jpg',
    },
    {
      'title': 'Géographie',
      'image': 'images/geographie.jpg',
    },
    {
      'title': 'Social',
      'image': 'images/Social.jpg',
    },
    {
      'title': 'Traditions',
      'image': 'images/Traditions.jpg',
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.lightGreenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: themes.length,
                controller: PageController(),
                itemBuilder: (context, index) {
                  final theme = themes[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            theme['image']!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 32,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              theme['title']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  elevation: 8,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegistrationForm()),
                  );
                },
                child: const Text(
                  'Commencer',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
