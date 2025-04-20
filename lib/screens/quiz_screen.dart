import 'package:flutter/material.dart';
import '../models/quiz_question.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<QuizQuestion> questions = [
      QuizQuestion(
        question: 'What is the capital of France?',
        options: ['Berlin', 'London', 'Paris', 'Rome'],
        correctIndex: 2,
      ),
      QuizQuestion(
        question: 'Which planet is known as the Red Planet?',
        options: ['Earth', 'Mars', 'Jupiter', 'Venus'],
        correctIndex: 1,
      ),
      QuizQuestion(
        question: 'Who wrote "Hamlet"?',
        options: ['Charles Dickens', 'Mark Twain', 'William Shakespeare', 'Jane Austen'],
        correctIndex: 2,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: QuizFlowWidget(questions: questions),
    );
  }
}

class QuizFlowWidget extends StatefulWidget {
  final List<QuizQuestion> questions;
  const QuizFlowWidget({Key? key, required this.questions}) : super(key: key);

  @override
  State<QuizFlowWidget> createState() => _QuizFlowWidgetState();
}

class _QuizFlowWidgetState extends State<QuizFlowWidget> {
  int currentQuestion = 0;
  int score = 0;
  int? selectedIndex;
  bool answered = false;
  bool finished = false;

  void selectAnswer(int idx) {
    if (!answered && !finished) {
      setState(() {
        selectedIndex = idx;
        answered = true;
        if (idx == widget.questions[currentQuestion].correctIndex) {
          score++;
        }
      });
    }
  }

  void nextQuestion() {
    if (currentQuestion < widget.questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedIndex = null;
        answered = false;
      });
    } else {
      setState(() {
        finished = true;
      });
    }
  }

  void restartQuiz() {
    setState(() {
      currentQuestion = 0;
      score = 0;
      selectedIndex = null;
      answered = false;
      finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (finished) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz Finished!',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Your score: $score / ${widget.questions.length}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: restartQuiz,
              child: const Text('Restart Quiz'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      );
    }
    final question = widget.questions[currentQuestion];
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Question ${currentQuestion + 1} of ${widget.questions.length}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            question.question,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ...List.generate(question.options.length, (idx) {
            final isSelected = selectedIndex == idx;
            final isCorrect = question.correctIndex == idx;
            Color? color;
            if (answered) {
              if (isCorrect) {
                color = Colors.green;
              } else if (isSelected) {
                color = Colors.red;
              }
            }
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                ),
                onPressed: answered ? null : () => selectAnswer(idx),
                child: Text(question.options[idx]),
              ),
            );
          }),
          const SizedBox(height: 24),
          if (answered)
            Text(
              selectedIndex == question.correctIndex
                  ? 'Correct!'
                  : 'Incorrect. The answer is: ${question.options[question.correctIndex]}',
              style: TextStyle(
                fontSize: 18,
                color: selectedIndex == question.correctIndex
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          if (answered)
            const SizedBox(height: 16),
          if (answered)
            ElevatedButton(
              onPressed: nextQuestion,
              child: Text(currentQuestion < widget.questions.length - 1 ? 'Next Question' : 'Finish'),
            ),
        ],
      ),
    );
  }
}

