import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grant/pages/quiz_page.dart';

class ResultPage extends StatefulWidget {
  final int rightAnswers;
  final int numberOfQuestion;
  final Duration time;
  final Duration timeTaken;

  const ResultPage(
      {super.key,
        required this.rightAnswers,
        required this.numberOfQuestion,
        required this.time,
        required this.timeTaken});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with TickerProviderStateMixin {
  var rightAnswers = 0;
  var numberOfQuestion = 0;
  Duration time = const Duration(minutes: 0);
  Duration timeTaken = const Duration(minutes: 0, seconds: 0);

  double result = 0;

  @override
  void initState() {
    rightAnswers = widget.rightAnswers;
    numberOfQuestion = widget.numberOfQuestion;
    timeTaken = widget.timeTaken;
    time = widget.time;

    result = rightAnswers * 100 / numberOfQuestion;

    super.initState();
  }

  callHomePage() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
          return QuizPage();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 135,
                height: 135,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        "$result%", //percentage of right answers
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 135,
                      height: 135,
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        value: 1,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    ),
                    SizedBox(
                      width: 135,
                      height: 135,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: result / 100),
                        duration: const Duration(milliseconds: 2000),
                        builder: (context, value, _) =>
                            CircularProgressIndicator(
                              strokeWidth: 10,
                              value: value,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Yakunlandi',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Afsuski sizga ball taqdim etilmadi\nJa\'mi to\'plangan ballaringiz soni: $rightAnswers ta',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                "Umumiy testlar soni:$numberOfQuestion",
                style: const TextStyle(fontSize: 13),
              ), // number of tests
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Column(
                        children: [
                          const Text(
                            'To\'g\'ri javob',
                            style: TextStyle(fontSize: 16, color: Colors.green),
                          ),
                          Text(
                            '${rightAnswers}',
                            style: const TextStyle(
                                fontSize: 24, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 230, 230, 100),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Column(
                        children: [
                          const Text(
                            'Noto\'g\'ri javob',
                            style: TextStyle(fontSize: 16, color: Colors.red),
                          ),
                          Text(
                            '${numberOfQuestion - rightAnswers}',
                            style: const TextStyle(
                                fontSize: 24, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    '${time.inMinutes}:${time.inSeconds - time.inMinutes * 60} / ${timeTaken.inMinutes}:${timeTaken.inSeconds - timeTaken.inMinutes * 60}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 56,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.blue),
                child: MaterialButton(
                    onPressed: () {
                      callHomePage();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.restart,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Qayta urinish",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )
                      ],
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 56,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.grey),
                child: MaterialButton(
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Chiqish",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}