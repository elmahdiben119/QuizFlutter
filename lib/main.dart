import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './models/question.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'La Grèce Quiz',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class CurrentQuestion extends StatefulWidget {
  const CurrentQuestion({Key? key}) : super(key: key);
  @override
  State<CurrentQuestion> createState() => _CurrentQuestionState();
}

class _CurrentQuestionState extends State<CurrentQuestion> {
  final List<Question> _questions = [];
  int _index = 1;
  int _score = 0;
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final data = await json.decode(response);
    setState(() {
      for (var question in data) {
        _questions.add(Question(question['question'], question['answer']));
      }
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quize Score'),
          content: SingleChildScrollView(
            child: Text('Score $_score'),
          ),
          actions: <Widget>[
            TextButton(
              child: IconButton(
                icon: const Icon(Icons.replay_rounded),
                onPressed: () async {
                  setState(() {
                    _index = 0;
                    _score = 0;
                  });
                  Navigator.pop(context);
                },
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void calculateScore(bool value) {
    setState(() {
      if (_index <= 9) {
        _index++;
        if (_questions.elementAt(_index - 1).getAnswer == value) {
          _score++;
        }
      } else {
        _showMyDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    readJson();
    return Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              '$_index/10',
              style: const TextStyle(color: Colors.grey, fontSize: 20),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                _questions.elementAt(_index).getQuestion,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      calculateScore(true);
                    },
                    child: const Text(
                      'Frai',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(backgroundColor: Colors.green),
                  )
                ],
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      calculateScore(false);
                    },
                    child: const Text(
                      'Faux',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(backgroundColor: Colors.red),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text('La Grèce antique',
                style: TextStyle(color: Colors.tealAccent, fontSize: 25)),
            CurrentQuestion()
          ],
        ),
      ),
    );
  }
}
