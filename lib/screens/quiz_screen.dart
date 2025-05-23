import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import '../models/quiz_question.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? category = ModalRoute.of(context)?.settings.arguments as String?;
    final List<QuizQuestion> allQuestions = [
      QuizQuestion(
        question: 'What is the capital of France?',
        options: ['Berlin', 'London', 'Paris', 'Rome'],
        correctIndex: 2,
        category: 'Geography',
      ),
      QuizQuestion(
        question: 'Which planet is known as the Red Planet?',
        options: ['Earth', 'Mars', 'Jupiter', 'Venus'],
        correctIndex: 1,
        category: 'Science',
      ),
      QuizQuestion(
        question: 'Who wrote "Hamlet"?',
        options: ['Charles Dickens', 'Mark Twain', 'William Shakespeare', 'Jane Austen'],
        correctIndex: 2,
        category: 'History',
      ),
      QuizQuestion(
        question: 'What is H2O commonly known as?',
        options: ['Salt', 'Water', 'Oxygen', 'Hydrogen'],
        correctIndex: 1,
        category: 'Science',
      ),
      QuizQuestion(
        question: 'Which year did World War II end?',
        options: ['1945', '1939', '1918', '1965'],
        correctIndex: 0,
        category: 'History',
      ),
      QuizQuestion(
        question: 'Which company developed the PlayStation?',
        options: ['Microsoft', 'Sony', 'Nintendo', 'Sega'],
        correctIndex: 1,
        category: 'Games',
      ),
    ];
    final List<QuizQuestion> questions = category == null
        ? allQuestions
        : allQuestions.where((q) => q.category?.toLowerCase() == category.toLowerCase()).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(category == null ? 'Quiz' : '$category Quiz'),
      ),
      body: Column(
        children: [
          if (category != null)
            Container(
              width: double.infinity,
              color: Colors.deepPurple[50],
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  '$category Quiz',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
              ),
            ),
          Expanded(child: QuizFlowWidget(questions: questions, category: category)),
        ],
      ),
    );
  }
}


class QuizFlowWidget extends StatefulWidget {
  final List<QuizQuestion> questions;
  final String? category;
  const QuizFlowWidget({Key? key, required this.questions, this.category}) : super(key: key);

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
      // Update stats after quiz completion
      Future.microtask(() async {
        final prefs = await SharedPreferences.getInstance();
        int quizzes = (prefs.getInt('quizzes') ?? 0) + 1;
        int highScore = prefs.getInt('high_score') ?? 0;
        int streak = (prefs.getInt('streak') ?? 0) + 1;
        if (score > highScore) highScore = score;
        await HomeScreen.updateStats(quizzes: quizzes, highScore: highScore, streak: streak);
      });
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: LinearProgressIndicator(
              value: (currentQuestion + 1) / widget.questions.length,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${currentQuestion + 1} of ${widget.questions.length}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                'Score: $score',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                question.question,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 28),
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
            return AnimatedOpacity(
              opacity: answered ? (isSelected || isCorrect ? 1.0 : 0.5) : 1.0,
              duration: const Duration(milliseconds: 350),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 7),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: answered ? null : () => selectAnswer(idx),
                  child: Text(question.options[idx]),
                ),
              ),
            );
          }),
          const SizedBox(height: 28),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: answered
                ? Column(
                    key: ValueKey(selectedIndex),
                    children: [
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
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: nextQuestion,
                        child: Text(currentQuestion < widget.questions.length - 1 ? 'Next Question' : 'Finish'),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

