import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.box}) : super(key: key);
  final Box box;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
String get hostname {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8888';
    } else {
      return 'http://localhost:1337';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Username',
                  hintText: 'Enter Your Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Email Address',
                  hintText: 'Enter Your Name'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Password',
                  hintText: 'Enter Your Name'),
            ),
            TextButton(onPressed: () {

              
            }, child: const Text("Update")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.box.delete("authToken");
                  widget.box.clear();
                },
                child: const Text("Log out"))
          ]),
        ));
  }
}
