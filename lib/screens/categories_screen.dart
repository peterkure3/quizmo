import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  static final List<_CategoryData> categories = [
    _CategoryData('Geography', Icons.public, quizzes: 3, highScore: 8),
    _CategoryData('Science', Icons.science, quizzes: 4, highScore: 10),
    _CategoryData('History', Icons.history_edu, quizzes: 2, highScore: 7),
    _CategoryData('Games', Icons.sports_esports, quizzes: 1, highScore: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _CategoryCard(
              icon: category.icon,
              label: category.label,
              quizzes: category.quizzes,
              highScore: category.highScore,
              onTap: () {
                Navigator.pushNamed(context, '/quiz', arguments: category.label);
              },
            );
          },
        ),
      ),
    );
  }
}

class _CategoryData {
  final String label;
  final IconData icon;
  final int quizzes;
  final int highScore;
  const _CategoryData(this.label, this.icon, {this.quizzes = 0, this.highScore = 0});
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int quizzes;
  final int highScore;
  final VoidCallback? onTap;
  const _CategoryCard({required this.icon, required this.label, required this.quizzes, required this.highScore, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        color: Colors.deepPurple[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.deepPurple),
              const SizedBox(height: 10),
              Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Quizzes: $quizzes', style: const TextStyle(fontSize: 13)),
              Text('High Score: $highScore', style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
