
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../services/community_service.dart';


class TraditionsQuestionsPage extends StatefulWidget {
  const TraditionsQuestionsPage({super.key});

  @override
  State<TraditionsQuestionsPage> createState() => _TraditionsQuestionsPageState();
}

class _TraditionsQuestionsPageState extends State<TraditionsQuestionsPage> {
  final AudioService _audio = AudioService();
  final List<Map<String, dynamic>> questions = [
    {
      'question': "Quel est le nom de la danse traditionnelle des Bamiléké ?",
      'options': ["Assiko", "Bikutsi", "Njang", "Tso"],
      'answer': 3,
      'explanation': "La danse Tso est typique des Bamiléké.",
    },
    {
      'question': "Quel plat est souvent servi lors des cérémonies traditionnelles au Cameroun ?",
      'options': ["Ndolé", "Eru", "Koki", "Soja"],
      'answer': 0,
      'explanation': "Le Ndolé est un plat emblématique des cérémonies.",
    },
    {
      'question': "Quel instrument accompagne fréquemment les chants traditionnels ?",
      'options': ["Balafon", "Guitare", "Piano", "Saxophone"],
      'answer': 0,
      'explanation': "Le balafon est un instrument traditionnel africain.",
    },
  ];

  int currentIndex = 0;
  int score = 0;
  List<bool> results = [];



  void answerQuestion(int selected) {
    setState(() {
      bool isCorrect = selected == questions[currentIndex]['answer'];
      results.add(isCorrect);
      if (isCorrect) score++;
      if (currentIndex < questions.length - 1) {
        currentIndex++;
      } else {
        // Fin du quiz
        showResultsDialog();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _audio.playBackground('assets/sounds/traditions_bg.mp3');
  }

  @override
  void dispose() {
    _audio.stopBackground();
    super.dispose();
  }

  void showResultsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Résultats du Quiz"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Score : $score/${questions.length}"),
            ElevatedButton(
              onPressed: shareResults,
              child: const Text("Partager mes résultats"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Fermer"),
          ),
        ],
      ),
    );
  }

  void shareResults() {
    _shareAndSave();
  }

  void _shareAndSave() async {
    final missed = <Map<String, String>>[];
    for (int i = 0; i < questions.length; i++) {
      if (!results[i]) {
        missed.add({
          'question': questions[i]['question'] as String,
          'given': (questions[i]['selected'] != null) ? questions[i]['options'][questions[i]['selected']] as String : 'Aucune',
          'correct': questions[i]['options'][questions[i]['answer']] as String,
        });
      }
    }

    final post = CommunityPost(
      id: DateTime.now().toIso8601String(),
      theme: 'Traditions',
      score: score,
      total: questions.length,
      missed: missed,
    );
    await CommunityService.savePost(post);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Résultats partagés dans l'onglet Communauté !")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'images/Traditions.jpg',
            fit: BoxFit.cover,
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.3),
            colorBlendMode: BlendMode.darken,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Quiz des Traditions"),
            backgroundColor: Colors.grey[900],
          ),
          body: Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      questions[currentIndex]['question'],
                      style: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ...List.generate(
                  questions[currentIndex]['options'].length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _audio.playClick();
                        answerQuestion(index);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        questions[currentIndex]['options'][index],
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(questions.length, (i) {
                    final seen = i < results.length;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: seen ? 18 : 12,
                      height: 8,
                      decoration: BoxDecoration(
                        color: seen ? (results[i] ? Colors.green : Colors.red) : Colors.grey[300],
                        borderRadius: BorderRadius.circular(6),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}