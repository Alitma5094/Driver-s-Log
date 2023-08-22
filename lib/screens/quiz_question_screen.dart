import 'dart:convert';
import 'dart:typed_data';
import 'package:drivers_log/models/question.dart';
import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen(
      {super.key,
      required this.onSelectAnswer,
      required this.questions,
      this.secondsLeft});

  final void Function(String answer) onSelectAnswer;
  final List<Question> questions;
  final int? secondsLeft;

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  var _currentQuestionIndex = 0;
  late Uint8List _currentDecodedImage;

  void _answerQuestion(String selectedAnswer) {
    widget.onSelectAnswer(selectedAnswer);
    setState(() {
      _currentQuestionIndex++;
      _currentDecodedImage = base64Decode(
        widget.questions[_currentQuestionIndex].imageString.split(',').last,
      );
    });
  }

  @override
  void initState() {
    _currentDecodedImage = base64Decode(
      widget.questions[_currentQuestionIndex].imageString.split(',').last,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[_currentQuestionIndex];
    return Center(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.secondsLeft != null
                ? Text(
                    '${(widget.secondsLeft! / 60).truncate()} : ${widget.secondsLeft!.remainder(60)}',
                  )
                : const Text(''),
            Text(
              currentQuestion.question,
            ),
            Image.memory(_currentDecodedImage),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _answerQuestion('A');
                    },
                    child: Text(currentQuestion.choiceA),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _answerQuestion('B');
                    },
                    child: Text(currentQuestion.choiceB),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _answerQuestion('C');
                    },
                    child: Text(currentQuestion.choiceC),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
