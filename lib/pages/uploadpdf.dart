import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadPDF extends StatefulWidget {
  const UploadPDF({super.key});

  @override
  State<UploadPDF> createState() => _UploadPDFState();
}

File? selectedFile;

class _UploadPDFState extends State<UploadPDF> {
  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload PDF"),
        centerTitle: true,
        leading: Center(
          child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close, size: 40),
              color: Colors.white),
        ),
        leadingWidth: 75,
        //toolbarHeight: 100,
        backgroundColor: Colors.black,
      ),
      body: Column(children: [
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
        InkWell(
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
            child: const Column(
              children: [
                Icon(
                  Icons.upload_file,
                  size: 40,
                ),
                Text("Click to upload a PDF"),
                Text("file")
              ],
            ),
          ),
          onTap: () {
            selectFile(); //Change here: avoid print in production code
          },
        ),
        SizedBox(height: 20),
        if (selectedFile != null)
          Text(
            'Selected File: ${selectedFile!.path}',
            textAlign: TextAlign.center,
          ),
        const Spacer(), //Takes space to but the start conversation button to the bottom
        FilledButton(
          onPressed: () {
            uploadPDF();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.black),
              fixedSize: MaterialStatePropertyAll(Size(100, 100))),
          child: const Text("Submit and start Conversation"),
        )
      ]),
    );
  }
}

void uploadPDF() async {
  Dio dio = Dio();

  // Replace with your Flask server URL
  String serverUrl = 'https://c707-27-34-101-154.ngrok-free.app/upload';

  File? pdfFile =
      File(selectedFile.toString()); // Replace with your PDF file path

  String fileName = pdfFile.path.split('/').last; // Extracting file name

  FormData formData = FormData.fromMap({
    'pdf': await MultipartFile.fromFile(pdfFile.path, filename: fileName),
  });

  try {
    Response response = await dio.post(
      serverUrl,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    print('File uploaded, server response: ${response.data}');
  } catch (e) {
    print('Error uploading file: $e');
  }
}
