import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//This is depreciated use chatapp.art instead
class qnasession extends StatefulWidget {
  const qnasession({super.key});

  @override
  State<qnasession> createState() => _qnasessionState();
}

class _qnasessionState extends State<qnasession> {
  TextEditingController _controller = TextEditingController();
  String answer = 'Your answer will show here.';

  Future<void> askQuestion() async {
    String question = _controller.text;

    final response = await http.post(
      Uri.parse(
          'http://192.168.1.75:9000/ask_question'), // Gotta replace this when I deploy this to heroki
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'question': question}),
    );

    if (response.statusCode == 200) {
      setState(() {
        answer = jsonDecode(response.body)['result'];
        print(answer);
      });
    } else {
      setState(() {
        answer = 'Error: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask meroPDFmitra'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 20, 20),
            child: const Text(
              "Ask questions to your document:",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          TextField(controller: _controller),
          ElevatedButton(
            onPressed: () {
              askQuestion();
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.black)),
            child: const Text('Ask'),
          ),
          Text(
            'Answer: $answer',
            style: TextStyle(fontSize: 22),
          ),
        ],
      ),
    );
  }
}
