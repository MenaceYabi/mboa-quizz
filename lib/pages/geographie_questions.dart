// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../services/community_service.dart';

class GeographieQuestionsPage extends StatefulWidget {
  const GeographieQuestionsPage({Key? key}) : super(key: key);

  @override
  State<GeographieQuestionsPage> createState() => _GeographieQuestionsPageState();
}

class _GeographieQuestionsPageState extends State<GeographieQuestionsPage> {
  final AudioService _audio = AudioService();
  final List<Map<String, dynamic>> questions = [
    {
      'question': "Quelle est la plus grande ville du Cameroun ?",
      'options': ["Yaoundé", "Douala", "Garoua", "Bafoussam"],
      'answer': 1,
      'explanation': "Douala est la plus grande ville du Cameroun.",
    },
    {
      'question': "Combien de régions compte le Cameroun ?",
      'options': ["8", "10", "12", "6"],
      'answer': 1,
      'explanation': "Le Cameroun compte 10 régions.",
    },
    {
      'question': "Quel fleuve traverse la ville de Garoua ?",
      'options': ["Sanaga", "Wouri", "Bénoué", "Logone"],
      'answer': 2,
      'explanation': "Le fleuve Bénoué traverse Garoua.",
    },
  ];

  int currentIndex = 0;
  int score = 0;
  List<bool> results = [];
  bool showExplanation = false;

  @override
  void initState() {
    super.initState();
    // jouer la musique de fond pour la géographie
    _audio.playBackground('assets/sounds/geographie_bg.mp3');
  }

  @override
  void dispose() {
    // arrêter la musique de fond
    _audio.stopBackground();
    super.dispose();
  }

  void answerQuestion(int selected) {
    setState(() {
      bool isCorrect = selected == questions[currentIndex]['answer'];
      results.add(isCorrect);
      if (isCorrect) score++;
      questions[currentIndex]['selected'] = selected;
      // si dernière question -> afficher résultats, sinon avancer
      if (currentIndex < questions.length - 1) {
        showExplanation = true;
      } else {
        // Fin du quiz
        showResultsDialog();
      }
    });
  }

  void nextQuestion() {
    setState(() {
      currentIndex++;
      showExplanation = false;
    });
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

  void shareResults() async {
    final missed = <Map<String, String>>[];
    for (int i = 0; i < questions.length; i++) {
      if (i < results.length && !results[i]) {
        missed.add({
          'question': questions[i]['question'] as String,
          'given': (questions[i]['selected'] != null) ? questions[i]['options'][questions[i]['selected']] as String : 'Aucune',
          'correct': questions[i]['options'][questions[i]['answer']] as String,
        });
      }
    }

    final post = CommunityPost(
      id: DateTime.now().toIso8601String(),
      theme: 'Geographie',
      score: score,
      total: questions.length,
      missed: missed,
    );
    await CommunityService.savePost(post);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Résultats partagés dans l'onglet Communauté !")),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image d'arrière-plan
            Positioned.fill(
              child: Image.asset(
                'images/geographie.jpg',
                fit: BoxFit.cover,
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.3),
                colorBlendMode: BlendMode.darken,
              ),
            ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Quiz Géographie'),
            backgroundColor: Colors.grey[900],
          ),
          body: Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(16.0),
            child: currentIndex < questions.length
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Barre de progression
                      Row(
                        children: List.generate(questions.length, (i) {
                          Color color;
                          if (i < results.length) {
                            color = results[i] ? Colors.green : Colors.red;
                          } else {
                            color = Colors.grey[300]!;
                          }
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 8,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      Card(
                        color: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            questions[currentIndex]['question'],
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ...List.generate(questions[currentIndex]['options'].length, (i) {
                        final isAnswer = i == questions[currentIndex]['answer'];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: showExplanation
                                  ? (isAnswer ? Colors.green : (i == questions[currentIndex]['selected'] ? Colors.red : Colors.white))
                                  : Colors.grey[800],
                              foregroundColor: showExplanation ? Colors.white : Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: showExplanation
                                ? null
                                : () {
                                    // jouer le son de click
                                    _audio.playClick();
                                    questions[currentIndex]['selected'] = i;
                                    answerQuestion(i);
                                  },
                            child: Text(questions[currentIndex]['options'][i], style: const TextStyle(fontSize: 16)),
                          ),
                        );
                      }),
                      if (showExplanation) ...[
                        const SizedBox(height: 16),
                        Text(
                          questions[currentIndex]['explanation'],
                          style: const TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: nextQuestion,
                          child: const Text('Suivant'),
                        ),
                      ],
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Quiz terminé !',
                          style: TextStyle(fontSize: 28, color: Colors.black87, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Score : $score / ${questions.length}',
                          style: const TextStyle(fontSize: 22, color: Colors.black87),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Retour à l\'accueil'),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
