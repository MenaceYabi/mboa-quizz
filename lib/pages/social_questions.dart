import 'package:flutter/material.dart';
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
