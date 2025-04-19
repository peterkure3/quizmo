class Flashcard {
  String question;
  String answer;
  String topic;
  String source;

  Flashcard({
    required this.question,
    required this.answer,
    required this.topic,
    required this.source,
  });

  factory Flashcard.fromMap(Map<String, dynamic> map) => Flashcard(
        question: map['question'] ?? '',
        answer: map['answer'] ?? '',
        topic: map['topic'] ?? '',
        source: map['source'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'question': question,
        'answer': answer,
        'topic': topic,
        'source': source,
      };
}
