import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
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
        body: Container(
          height: 300,
          margin: const EdgeInsets.all(25),
          color: Colors.blueGrey,
          child: const Column(
            children: [
              ListBody(
                children: [
                  Text(
                    "User ID",
                    textAlign: TextAlign.left,
                  ),
                  Text("regalafh895689d6f48"),
                  Divider(
                    height: 20,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                    color: Colors.grey,
                  ),
                  Text("data")
                ],
              ),
            ],
          ),
        ));
  }
}
