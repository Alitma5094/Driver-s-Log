class Question {
  final int id;
  final String question;
  final String imageString;
  final String answer;

  final String choiceA;
  final String choiceB;
  final String choiceC;

  const Question({
    required this.id,
    required this.question,
    required this.imageString,
    required this.answer,
    required this.choiceA,
    required this.choiceB,
    required this.choiceC,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['questionnaireId'],
      question: json['question'],
      imageString: json['imageFile'],
      answer: json['answer'],
      choiceA: json['choiceA'],
      choiceB: json['choiceB'],
      choiceC: json['choiceC'],
    );
  }

  Question.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        question = res['question'],
        imageString = res['imageString'],
        answer = res['answer'],
        choiceA = res['choiceA'],
        choiceB = res['choiceB'],
        choiceC = res['choiceC'];

  Map<String, Object> toMap() {
    return {
      'id': id,
      'question': question,
      'imageString': imageString,
      'answer': answer,
      'choiceA': choiceA,
      'choiceB': choiceB,
      'choiceC': choiceC,
    };
  }
}
