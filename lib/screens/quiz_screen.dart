import 'package:flutter/material.dart';
import '../models/quiz_question.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample question
    final QuizQuestion sample = QuizQuestion(
      question: 'What is the capital of France?',
      options: ['Berlin', 'London', 'Paris', 'Rome'],
      correctIndex: 2,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: QuizQuestionWidget(question: sample),
    );
  }
}

class QuizQuestionWidget extends StatefulWidget {
  final QuizQuestion question;
  const QuizQuestionWidget({Key? key, required this.question}) : super(key: key);

  @override
  State<QuizQuestionWidget> createState() => _QuizQuestionWidgetState();
}

class _QuizQuestionWidgetState extends State<QuizQuestionWidget> {
  int? selectedIndex;
  bool answered = false;

  void selectAnswer(int idx) {
    if (!answered) {
      setState(() {
        selectedIndex = idx;
        answered = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.question.question,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ...List.generate(widget.question.options.length, (idx) {
            final isSelected = selectedIndex == idx;
            final isCorrect = widget.question.correctIndex == idx;
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
                onPressed: () => selectAnswer(idx),
                child: Text(widget.question.options[idx]),
              ),
            );
          }),
          const SizedBox(height: 24),
          if (answered)
            Text(
              selectedIndex == widget.question.correctIndex
                  ? 'Correct!'
                  : 'Incorrect. The answer is: ${widget.question.options[widget.question.correctIndex]}',
              style: TextStyle(
                fontSize: 18,
                color: selectedIndex == widget.question.correctIndex
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
