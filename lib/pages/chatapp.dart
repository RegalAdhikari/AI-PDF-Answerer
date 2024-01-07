import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(QnaChat());
}

class QnaChat extends StatefulWidget {
  const QnaChat({super.key});

  @override
  State<QnaChat> createState() => _QnaChatState();
}

String answer = 'Your answer will show here.';
final TextEditingController _textController = TextEditingController();

class _QnaChatState extends State<QnaChat> {
  // TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Ask MeroPDFmitra'),
        backgroundColor: Colors.black,
      ),
      body: ChatWidget(),
    );
  }
}

class ChatWidget extends StatefulWidget {
  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final List<Message> _messages = <Message>[
    Message(false, 'Hello! Ask me a question about your pdf', 0xFF081509),
  ];

  //final TextEditingController _textController = TextEditingController();

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.insert(0, Message(true, text, 0xFF1B97F3));
    });
    Future.delayed(Duration(seconds: 8), () {
      setState(() {
        _messages.insert(
            0, Message(false, answer, 0xFF081509)); // esma answer lyaunuparyo
      });
    });
  }

  Future<void> askQuestion() async {
    String question = _textController.text;
    print('this is running');
    final response = await http.post(
      Uri.parse(
          'http://192.168.192.120:9000/ask_question'), // Gotta replace this when I deploy this to heroki
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
    return Column(
      children: <Widget>[
        Flexible(
          child: ListView.builder(
            reverse: true,
            itemCount: _messages.length,
            itemBuilder: (_, int index) => _buildMessage(_messages[index]),
          ),
        ),
        Divider(height: 1.0),
        Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ],
    );
  }

  Widget _buildMessage(Message message) {
    return BubbleSpecialThree(
      text: message.text,
      color: Color(message.color),
      tail: true,
      textStyle: TextStyle(color: Colors.white, fontSize: 16),
      isSender: message.sender,
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Colors.black),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  askQuestion();

                  _handleSubmitted(_textController.text);
                }),
          ],
        ),
      ),
    );
  }
}

class Message {
  final bool sender;
  final String text;
  final int color;
  Message(this.sender, this.text, this.color);
}
