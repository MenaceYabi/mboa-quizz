import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../services/community_service.dart';
//import '../main.dart';

class GastronomieQuestionsPage extends StatefulWidget {
  const GastronomieQuestionsPage({Key? key}) : super(key: key);

  @override
  State<GastronomieQuestionsPage> createState() => _GastronomieQuestionsPageState();
}

class _GastronomieQuestionsPageState extends State<GastronomieQuestionsPage> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': "Quel plat est considéré comme le plat national du Cameroun ?",
      'options': ["Ndolé", "Eru", "Koki", "Mbongo Tchobi"],
      'answer': 0,
      'explanation': "Le Ndolé est souvent considéré comme le plat national.",
    },
    {
      'question': "Quel ingrédient est essentiel dans la préparation du Koki ?",
      'options': ["Banane plantain", "Haricot rouge", "Macabo", "Pois d'angole"],
      'answer': 2,
      'explanation': "Le macabo est l'ingrédient principal du Koki.",
    },
    {
      'question': "Quel est le nom du pain sucré traditionnel camerounais ?",
      'options': ["Baton de manioc", "Gateau de maïs", "Pain de singe", "Mbamba"],
      'answer': 1,
      'explanation': "Le gâteau de maïs est un pain sucré traditionnel.",
    },
  ];

  int currentIndex = 0;
  int score = 0;
  List<bool> results = [];
  bool showExplanation = false;

  final _audio = AudioService();

  void answerQuestion(int selected) {
    setState(() {
      bool isCorrect = selected == questions[currentIndex]['answer'];
      results.add(isCorrect);
      if (isCorrect) score++;
      showExplanation = true;
    });
  }

  void nextQuestion() {
    setState(() {
      currentIndex++;
      showExplanation = false;
    });
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
      theme: 'Gastronomie',
      score: score,
      total: questions.length,
      missed: missed,
    );
    await CommunityService.savePost(post);

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Résultats partagés dans l'onglet Communauté !")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image d'arri8re-plan (locale)
        Positioned.fill(
          child: Image.asset(
            'images/gastronomie.jpg',
            fit: BoxFit.cover,
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.3),
            colorBlendMode: BlendMode.darken,
          ),
  ),
  Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Quiz Gastronomie'),
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
