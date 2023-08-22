import 'package:drivers_log/models/question.dart';
import 'package:flutter/material.dart';

class FinishScreen extends StatelessWidget {
  const FinishScreen(
      {Key? key, required this.chosenAnswers, required this.questions})
      : super(key: key);

  final List<String> chosenAnswers;
  final List<Question> questions;

  int _getSummery() {
    int numCorrect = 0;
    for (var i = 0; i < chosenAnswers.length; i++) {
      if (chosenAnswers[i] == questions[i].answer) {
        numCorrect++;
      }
    }

    return numCorrect;
  }

  @override
  Widget build(BuildContext context) {
    final numCorrect = _getSummery();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('You got $numCorrect / 25 questions correct!'),
          numCorrect >= 23
              ? const Text(
                  'If you\'ve fully studied the "Maryland Driver\'s Handbook" and "All You Need to Know About Your Driver\'s License", you\'ll be well-prepared for the learner\'s permit knowledge test. However, remember that this sample Driver Test only covers some of the test topics, so relying solely on it reduces your chances of passing.')
              : const Text(
                  'You have answered less than 23 questions correctly. It\'s recommended that you review the "Maryland Driver\'s Handbook" and "All You Need to Know About Your Driver\'s License" thoroughly. With dedication and effort, you can improve your chances of success on the knowledge test.'),
        ],
      ),
    );
  }
}
