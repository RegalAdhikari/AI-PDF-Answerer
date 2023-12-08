import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScanFile extends StatefulWidget {
  const ScanFile({super.key});

  @override
  State<ScanFile> createState() => _ScanFileState();
}

class _ScanFileState extends State<ScanFile> {
  File? imageFile;
  String? message = "";
  var resJson;
  Map<String, dynamic> data = {};
  String ama = "hi mom";
  onUploadImage() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          "http://192.168.1.64:4000/upload"), // here will go the API's Uri
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        'image',
        selectedImage!.readAsBytes().asStream(),
        selectedImage!.lengthSync(),
        filename: selectedImage!.path.split('/').last,
      ),
    );
    request.headers.addAll(headers);
    print("request: " + request.toString());
    var res = await request.send();
    http.Response response = await http.Response.fromStream(res);
    setState(() {
      final resJson = json.decode(response.body);

      data = json.decode(response.body);
      print(data);
      ama = resJson.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Scan File"),
          centerTitle: true,
          leading: Center(
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_rounded, size: 40)),
          ),
          leadingWidth: 75,
          toolbarHeight: 100,
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (imageFile != null)
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      height: 350,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(image: FileImage(imageFile!))),
                    ))
              else
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    color: Colors.grey,
                    height: 350,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.black),
                        ),
                        onPressed: () => getImage(source: ImageSource.gallery),
                        icon: Icon(Icons.collections),
                        label: Text("Upload a file")),
                    ElevatedButton.icon(
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.black),
                        ),
                        onPressed: () => getImage(source: ImageSource.camera),
                        icon: Icon(Icons.camera_alt),
                        label: Text("Take a picture"))
                  ],
                ),
              ),
              ElevatedButton.icon(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.black),
                      padding: MaterialStatePropertyAll(EdgeInsets.all(10))),
                  onPressed: onUploadImage,
                  icon: Icon(Icons.text_rotation_none),
                  label: Text("Convert to Text")),
              Text(ama)
            ],
          ),
        ));
  }

  late File? selectedImage = imageFile;

  Future getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(source: source);
    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
        selectedImage = imageFile;
      });
    }
  }
}
// class ScanFile extends StatelessWidget {
//   const ScanFile({super.key});

 
