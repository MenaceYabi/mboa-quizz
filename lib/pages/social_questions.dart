// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';  
import '../services/community_service.dart';
//import '../main.dart';

class SocialQuestionsPage extends StatefulWidget {
  const SocialQuestionsPage({super.key});

  @override
  State<SocialQuestionsPage> createState() => _SocialQuestionsPageState();
}

class _SocialQuestionsPageState extends State<SocialQuestionsPage> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': "Quel est le sport le plus populaire au Cameroun ?",
      'options': ["Basketball", "Football", "Handball", "Athlétisme"],
    },
    {
      'question': "Quel événement social rassemble le plus de personnes au Cameroun ?",
      'options': ["Mariage", "Funérailles", "Fête nationale", "Fête de la musique"],
      'answer': 1,
      'explanation': "Les funérailles sont des événements majeurs et très suivis socialement.",
    },
    {
      'question': "Quel est le nom du célèbre stade de Yaoundé ?",
      'options': ["Stade Omnisports", "Stade Ahmadou Ahidjo", "Stade de la Réunification", "Stade de Japoma"],
      'answer': 1,
      'explanation': "Le stade Ahmadou Ahidjo est le plus célèbre de Yaoundé.",
    },
  ];


  int currentIndex = 0;
  int score = 0;
  List<bool> results = [];
  bool showExplanation = false;

  void answerQuestion(int selected) {
    setState(() {
      bool isCorrect = selected == questions[currentIndex]['answer'];
      results.add(isCorrect);
      if (isCorrect) score++;
      questions[currentIndex]['selected'] = selected;
      if (currentIndex < questions.length - 1) {
        showExplanation = true;
      } else {
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
      theme: 'Social',
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
            'images/Social.jpg',
            fit: BoxFit.cover,
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.3),
            colorBlendMode: BlendMode.darken,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Quiz Social'),
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
