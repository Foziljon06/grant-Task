import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

import 'package:grant/pages/result_page.dart';

class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  Question({required this.questionText, required this.options, required this.correctAnswerIndex});
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  final List<Question> questions = [
    Question(questionText: 'Savol 1', options: ['A', 'B', 'C'], correctAnswerIndex: 0),
    Question(questionText: 'Savol 2', options: ['A', 'B', 'C'], correctAnswerIndex: 1),
    Question(questionText: 'Savol 3', options: ['A', 'B', 'C'], correctAnswerIndex: 2),
  ];

  int _currentQuestionIndex = 0;
  int _selectedOptionIndex = -1;
  List<int> _questionStatus = [];
  Timer? _timer;
  int _seconds = 60;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;

  @override
  void initState() {
    super.initState();
    _questionStatus = List<int>.filled(questions.length, 0);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        _stopTimer();
        _showTimeUpDialog();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _selectOption(int index) {
    if (_questionStatus[_currentQuestionIndex] == 0) {
      setState(() {
        _selectedOptionIndex = index;
        if (index == questions[_currentQuestionIndex].correctAnswerIndex) {
          _questionStatus[_currentQuestionIndex] = 1; // To'g'ri javob
          _correctAnswers++;
        } else {
          _questionStatus[_currentQuestionIndex] = -1; // Noto'g'ri javob
          _wrongAnswers++;
        }
      });
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = _questionStatus[_currentQuestionIndex] == 0 ? -1 : _selectedOptionIndex;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedOptionIndex = _questionStatus[_currentQuestionIndex] == 0 ? -1 : _selectedOptionIndex;
      });
    }
  }

  void _selectQuestion(int index) {
    setState(() {
      _currentQuestionIndex = index;
      _selectedOptionIndex = _questionStatus[_currentQuestionIndex] == 0 ? -1 : _selectedOptionIndex;
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Time is up!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Qaytish
              },
              child: Text('Qaytish'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restartQuiz(); // Qayta ishlash
              },
              child: Text('Qayta ishlash'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('What do you want?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Qaytish
              },
              child: Text('Qaytish'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Yakunlash
              },
              child: Text('Yakunlash'),
            ),
          ],
        );
      },
    );
  }

  void _restartQuiz() {
    setState(() {
      _seconds = 60;
      _currentQuestionIndex = 0;
      _selectedOptionIndex = -1;
      _questionStatus = List<int>.filled(questions.length, 0);
      _correctAnswers = 0;
      _wrongAnswers = 0;
      _startTimer();
    });
  }

  void _showResults() {
    Fluttertoast.showToast(
      msg: 'To\'g\'ri javoblar: $_correctAnswers, Xato javoblar: $_wrongAnswers',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _showLogoutDialog,
              color: Colors.black,
            ),
            Row(
              children: [],
            ),
            Row(
              children: [
                Icon(Icons.timer, color: Colors.blueAccent),
                Text(
                  '${_seconds} s',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),

                                // part 1

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(questions.length, (index) {
                Color color;
                if (_currentQuestionIndex == index) {
                  color = Colors.red;
                } else if (_questionStatus[index] == 1) {
                  color = Colors.green;
                } else if (_questionStatus[index] == -1) {
                  color = Colors.white;
                } else {
                  color = Colors.white;
                }
                return GestureDetector(
                  onTap: () => _selectQuestion(index),
                  child: Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(child: Text((index + 1).toString())),
                  ),
                );
              }),
            ),),
          SizedBox(height: 20),

                                         // part 2

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
            height: 100,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            child: Text(
              questions[_currentQuestionIndex].questionText,
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 10),

                                         // part 3

          Container(
            height: 45,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Javoblar",
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 5),

                                        // part 4

          Column(
            children: List.generate(questions[_currentQuestionIndex].options.length, (index) {
              Color optionColor;
              if (_selectedOptionIndex == index) {
                optionColor = (index == questions[_currentQuestionIndex].correctAnswerIndex ? Colors.green : Colors.red);
              } else if (_questionStatus[_currentQuestionIndex] != 0) {
                if (index == questions[_currentQuestionIndex].correctAnswerIndex) {
                  optionColor = Colors.green;
                } else if (index == _selectedOptionIndex && _questionStatus[_currentQuestionIndex] == -1) {
                  optionColor = Colors.red;
                } else {
                  optionColor = Colors.white;
                }
              } else {
                optionColor = Colors.white;
              }

              return GestureDetector(
                onTap: () => _selectOption(index),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: optionColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    questions[_currentQuestionIndex].options[index],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 20),

                                       // part 5

          if (_questionStatus[_currentQuestionIndex] == -1)
            Text(
              'To\'g\'ri javob: ${questions[_currentQuestionIndex].options[questions[_currentQuestionIndex].correctAnswerIndex]}',
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),

                                      // part 6

          Spacer(),
          if (_correctAnswers + _wrongAnswers == questions.length)
            ElevatedButton(
              onPressed: () {
                _stopTimer();
                _showResults();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
                  return ResultPage(
                    numberOfQuestion: questions.length,
                    rightAnswers: _correctAnswers,
                    time: Duration(seconds: 60),
                    timeTaken: Duration(seconds: 60 - _seconds),
                  );
                }));
              },
              child: Text('Tugatish'),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _previousQuestion,
                color: Colors.blue,
                iconSize: 36,
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _nextQuestion,
                color: Colors.blue,
                iconSize: 36,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
