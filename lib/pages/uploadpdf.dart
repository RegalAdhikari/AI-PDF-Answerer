import 'package:flutter/material.dart';

class UploadPDF extends StatefulWidget {
  const UploadPDF({super.key});

  @override
  State<UploadPDF> createState() => _UploadPDFState();
}

class _UploadPDFState extends State<UploadPDF> {
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
            print(
                "Tapped on container"); //Change here: avoid print in production code
          },
        ),
        const Spacer(), //Takes space to but the start conversation button to the bottom
        FilledButton(
          onPressed: () {},
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.black),
              fixedSize: MaterialStatePropertyAll(Size(100, 100))),
          child: const Text("Submit and start Conversation"),
        )
      ]),
    );
  }
}
