class Question {
  String question;
  bool answer;

  Question(this.question, this.answer);

  String get getQuestion {
    return question;
  }

  set setQuestion(String text) {
    question = text;
  }

  bool get getAnswer {
    return answer;
  }

  set setAnswer(bool value) {
    answer = value;
  }

  factory Question.fromJson(Map<String, dynamic> parsedJson) {
    return Question(parsedJson['question'], parsedJson['answer']);
  }
}
