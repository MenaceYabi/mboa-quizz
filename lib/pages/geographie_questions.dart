import 'package:flutter/material.dart';
//import '../main.dart';

class GeographieQuestionsPage extends StatefulWidget {
  const GeographieQuestionsPage({Key? key}) : super(key: key);

  @override
  State<GeographieQuestionsPage> createState() => _GeographieQuestionsPageState();
}

class _GeographieQuestionsPageState extends State<GeographieQuestionsPage> {
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
            // ignore: deprecated_member_use
            backgroundColor: Colors.green.withOpacity(0.8),
          ),
          body: Padding(
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
                            color = Colors.grey;
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
                      Text(
                        questions[currentIndex]['question'],
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 24),
                      ...List.generate(questions[currentIndex]['options'].length, (i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: showExplanation
                                  ? (i == questions[currentIndex]['answer']
                                      ? Colors.green
                                      : (i == questions[currentIndex]['selected'] ? Colors.red : Colors.white))
                                  : Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: showExplanation
                                ? null
                                : () {
                                    questions[currentIndex]['selected'] = i;
                                    answerQuestion(i);
                                  },
                            child: Text(questions[currentIndex]['options'][i]),
                          ),
                        );
                      }),
                      if (showExplanation) ...[
                        const SizedBox(height: 16),
                        Text(
                          questions[currentIndex]['explanation'],
                          style: const TextStyle(color: Colors.yellow, fontSize: 16),
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
                        Text(
                          'Quiz terminé !',
                          style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Score : $score / ${questions.length}',
                          style: const TextStyle(fontSize: 22, color: Colors.white),
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
