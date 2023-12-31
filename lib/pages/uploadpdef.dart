import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:meropdfmitra/pages/chatapp.dart';
import 'dart:io';

class FilePickerExample extends StatefulWidget {
  @override
  _FilePickerExampleState createState() => _FilePickerExampleState();
}

class _FilePickerExampleState extends State<FilePickerExample> {
  File? selectedFile;

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });

      // Upload the selected file
      if (selectedFile != null) {
        await uploadPDF(selectedFile!);
      }
    } else {
      // User canceled the picker
    }
  }

  Future<void> uploadPDF(File file) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.28.120:9000/upload'), //Url for uploading PDF
    );

    String fileName = file.path.split('/').last;

    request.files.add(
      http.MultipartFile(
        'pdf',
        file.openRead(),
        await file.length(),
        filename: fileName,
      ),
    );

    try {
      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        print('File uploaded, server response: ${response.body}');
      } else {
        print('Error uploading file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload PDF'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(30, 90, 20, 20),
            child: const Text(
              "Upload a new document",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30, 0, 30, 50),
            child: const Text(
              "You'll be able to start a conversation based on the document uploaded.",
              style: TextStyle(fontSize: 15),
            ),
          ),
          ElevatedButton(
            onPressed: selectFile,
            child: Text('Upload PDF file'),
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.black)),
          ),
          SizedBox(height: 20),
          if (selectedFile != null)
            Text(
              'Selected File: ${selectedFile!.path}',
              textAlign: TextAlign.center,
            ),
          const Spacer(),
          FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new ChatScreen(),
                ),
              );
            },
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.black),
                fixedSize: MaterialStatePropertyAll(Size(100, 100))),
            child: const Text("Submit and start Conversation"),
          )
        ],
      ),
    );
  }
}
