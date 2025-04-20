import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static Future<void> updateStats({int? quizzes, int? highScore, int? streak}) async {
    final prefs = await SharedPreferences.getInstance();
    if (quizzes != null) prefs.setInt('quizzes', quizzes);
    if (highScore != null) prefs.setInt('high_score', highScore);
    if (streak != null) prefs.setInt('streak', streak);
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _quizzes = 0;
  int _highScore = 0;
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _quizzes = prefs.getInt('quizzes') ?? 0;
      _highScore = prefs.getInt('high_score') ?? 0;
      _streak = prefs.getInt('streak') ?? 0;
    });
  }

  void _onCategoryTap(String category) {
    Navigator.pushNamed(
      context,
      '/quiz',
      arguments: category,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizmo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Mascot/Illustration
              Center(
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: Colors.deepPurple[100],
                  child: Icon(Icons.emoji_emotions, size: 64, color: Colors.deepPurple),
                ),
              ),
              const SizedBox(height: 24),
              // Welcome
              const Center(
                child: Text(
                  'Welcome back! Ready to play?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              // User Progress (mock data)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatCard(label: 'Quizzes', value: _quizzes.toString()),
                  _StatCard(label: 'High Score', value: _highScore.toString()),
                  _StatCard(label: 'Streak', value: _streak.toString()),
                ],
              ),
              const SizedBox(height: 32),
              // Quiz Categories (mock)
              const Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CategoryCard(icon: Icons.science, label: 'Science', onTap: () => _onCategoryTap('Science')),
                  _CategoryCard(icon: Icons.history_edu, label: 'History', onTap: () => _onCategoryTap('History')),
                  _CategoryCard(icon: Icons.sports_esports, label: 'Games', onTap: () => _onCategoryTap('Games')),
                ],
              ),
              const SizedBox(height: 36),
              // Start Quiz Button
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Quiz', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/quiz', arguments: null);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepPurple[50],
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _CategoryCard({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Card(
        color: Colors.deepPurple[50],
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: 80,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: Colors.deepPurple),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


