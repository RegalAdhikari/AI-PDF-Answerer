import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meropdfmitra/pages/profile.dart';
import 'package:meropdfmitra/pages/scanfile.dart';
import 'package:meropdfmitra/pages/uploadpdf.dart';

void main() {
  File? imageFile;
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'MeroPDFMitra',
    home: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/scanfile': (context) => ScanFile(),
        '/profile': (context) => Profile(),
      },
      home: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text("MeroPDFMitra")),
            centerTitle: true,
            leading: Center(
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings_outlined, size: 40)),
            ),
            leadingWidth: 75,
            actions: [
              Builder(
                  builder: (context) => Center(
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/profile');
                            },
                            icon: const Icon(Icons.account_circle_outlined,
                                size: 40)),
                      )),
              const Text("       ") //lol fix
            ],
            toolbarHeight: 100,
            backgroundColor: Colors.black,
          ),
          body: Container(
            color: Colors.grey[100],
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.document_scanner_sharp,
                          size: 100,
                        ),
                      ),
                      const Text(
                        "Scan your document",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // const Text(
                      //   "Please check your internet connection and try again",
                      //   style: TextStyle(fontSize: 18),
                      //   textAlign: TextAlign.center,
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => new ScanFile(),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.black,
                            fixedSize: Size.fromWidth(500),
                            padding: EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Text("Scan Now"),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.picture_as_pdf,
                          size: 100,
                        ),
                      ),
                      const Text(
                        "Upload a PDF",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => new UploadPDF(),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.black,
                            fixedSize: Size.fromWidth(500),
                            padding: EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Text("Upload Now"),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
