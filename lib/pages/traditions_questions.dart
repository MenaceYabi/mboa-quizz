import 'package:flutter/material.dart';
//import '../main.dart';

class TraditionsQuestionsPage extends StatefulWidget {
  const TraditionsQuestionsPage({super.key});

  @override
  State<TraditionsQuestionsPage> createState() => _TraditionsQuestionsPageState();
}

class _TraditionsQuestionsPageState extends State<TraditionsQuestionsPage> {
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
            title: const Text('Quiz Traditions'),
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
