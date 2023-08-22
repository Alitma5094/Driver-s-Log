import 'dart:convert';
import 'package:drivers_log/models/database_handler.dart';
import 'package:drivers_log/models/question.dart';
import 'package:drivers_log/screens/quiz_finish_screen.dart';
import 'package:drivers_log/screens/quiz_question_screen.dart';
import 'package:drivers_log/screens/quiz_start_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  late Future<List<Question>> _futureQuestions;
  final List<String> _selectedAnswers = [];
  var _activeScreen = 'start';

  Timer? _timer;
  int _secondsLeft = 25 * 60;

  Future<List<Question>> _getQuestions() async {
    final savedQuestions = await DatabaseHandler().fetchQuestions();
    if (savedQuestions.isEmpty) {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            title: Text('Updating Questions'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text('Please Wait....'),
              ],
            ),
          ),
        );
        List<Question> tempQuestions = [];
        //The images for questions 206 and 215 seem to be causing trouble (they seem to be valid and yet are not rendered)
        // I have blacklisted them and decreased the total number of questions by 2
        // TODO: Add a way to move all hard coded vars to a separate file or location (Does flutter have a .env equivalent?)
        Set<int> addedIds = {206, 215}; // Maintain a set of added IDs

        while (tempQuestions.length < 106) {
          final response = await http.get(Uri.parse(
              'https://mvarookie.mva.maryland.gov:444/Questionnaire/GetQuestionnaireByLanguage/en'));
          if (response.statusCode == 200) {
            List<dynamic> body = jsonDecode(response.body);

            for (dynamic item in body) {
              final id = item['questionnaireId'];

              if (!addedIds.contains(id)) {
                // Check if ID is not already added
                final replacementResponse = await http.get(
                  Uri.parse(
                      'https://mvarookie.mva.maryland.gov:444/Questionnaire/GetAnswerById/$id'),
                );

                if (replacementResponse.statusCode == 200) {
                  String replacementValue = replacementResponse.body;
                  item['answer'] = replacementValue;
                  tempQuestions.add(Question.fromJson(item));
                  addedIds.add(id); // Add the ID to the set
                } else {
                  throw Exception(
                      'Failed to load replacement value for id: $id');
                }
              }
            }
          } else {
            throw Exception('Failed to load questions');
          }
        }
        DatabaseHandler().replaceDrivingEvents(tempQuestions);
        savedQuestions.addAll(tempQuestions);
        Navigator.pop(context);
      }
    }
    savedQuestions.shuffle();
    return savedQuestions.take(25).toList();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_secondsLeft == 0) {
          setState(() {
            timer.cancel();
            _activeScreen = 'results';
          });
        } else {
          setState(() {
            _secondsLeft--;
          });
        }
      },
    );
  }

  void _handelStartPressed(timed) {
    setState(() {
      _activeScreen = 'questions';
      if (timed) {
        _startTimer();
      }
    });
  }

  @override
  void initState() {
    _futureQuestions = _getQuestions();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget screenWidget = StartScreen(
      onStartPressed: _handelStartPressed,
    );

    if (_activeScreen == 'questions') {
      screenWidget = FutureBuilder<List<Question>>(
        future: _futureQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return QuestionScreen(
              secondsLeft: _timer != null ? _secondsLeft : null,
              onSelectAnswer: (String answer) {
                _selectedAnswers.add(answer);
                if (snapshot.data!.length == _selectedAnswers.length) {
                  setState(() {
                    _activeScreen = 'results';
                  });
                }
              },
              questions: snapshot.data!,
            );
          } else {
            throw Exception('Failed to display questions');
          }
        },
      );
    }

    if (_activeScreen == 'results') {
      screenWidget = FutureBuilder<List<Question>>(
        future: _futureQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return FinishScreen(
              chosenAnswers: _selectedAnswers,
              questions: snapshot.data!,
            );
          } else {
            throw Exception('Failed to display questions');
          }
        },
      );
    }

    return screenWidget;
  }
}
