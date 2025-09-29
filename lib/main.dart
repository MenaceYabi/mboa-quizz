import 'package:flutter/material.dart';
import 'package:mboaquizz/pages/splash_screen.dart';

// Modèle de question de quiz
class QuizQuestion {
  final String category;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  QuizQuestion({
    required this.category,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });

  // Pour charger depuis JSON
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      category: json['category'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctOptionIndex: json['correctOptionIndex'] as int,
      explanation: json['explanation'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'category': category,
    'question': question,
    'options': options,
    'correctOptionIndex': correctOptionIndex,
    'explanation': explanation,
  };
}

void main() {
  runApp(const BoisQuiseApp());
}

class BoisQuiseApp extends StatelessWidget {
  const BoisQuiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MBOA QUIZZ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SplashScreen(),
    );
  }
}
