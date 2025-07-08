import 'package:cloud_firestore/cloud_firestore.dart';

class InterviewQuestion {
  final String id;
  final String skill;
  final String question;
  final String answer;
  final String difficulty; // optional
  final Timestamp? createdAt;

  InterviewQuestion({
    required this.id,
    required this.skill,
    required this.question,
    required this.answer,
    required this.difficulty,
    this.createdAt,
  });

  factory InterviewQuestion.fromMap(Map<String, dynamic> map) {
    final creatAt1 = map['createdAt'];
    return InterviewQuestion(
      id: map['id'] ?? '',
      skill: map['skill'] ?? '',
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
      difficulty: map['difficulty'] ?? 'Medium',
      createdAt: creatAt1 is Timestamp ? map['createdAt'] : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'skill': skill,
      'question': question,
      'answer': answer,
      'difficulty': difficulty,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  @override
  String toString() {
    return 'InterviewQuestion('
        'id: $id, '
        'skill: $skill, '
        'question: $question, '
        'answer: $answer, '
        'difficulty: $difficulty, '
        'createdAt: ${createdAt?.toDate().toString() ?? "null"}'
        ')';
  }
}
