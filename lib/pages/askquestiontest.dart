import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Ask Question')),
        body: AskQuestion(),
      ),
    );
  }
}

class AskQuestion extends StatefulWidget {
  @override
  _AskQuestionState createState() => _AskQuestionState();
}

class _AskQuestionState extends State<AskQuestion> {
  TextEditingController _controller = TextEditingController();
  String answer = '';

  Future<void> askQuestion() async {
    String question = _controller.text;

    final response = await http.post(
      Uri.parse(
          'http://YOUR_SERVER_IP:5000/ask_question'), // Replace with your server IP
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'question': question}),
    );

    if (response.statusCode == 200) {
      setState(() {
        answer = json.decode(response.body)['answer'];
      });
    } else {
      setState(() {
        answer = 'Error: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(controller: _controller),
        ElevatedButton(
          onPressed: () {
            askQuestion();
          },
          child: Text('Ask'),
        ),
        Text('Answer: $answer'),
      ],
    );
  }
}
