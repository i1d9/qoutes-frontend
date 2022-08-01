import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key, required this.box}) : super(key: key);
  final Box box;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool newAccount = false;
  String get hostname {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8888';
    } else {
      return 'http://localhost:1337';
    }
  }

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(10),
            child: newAccount ? registerView() : loginView()));
  }

  Widget loginView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
        TextButton(
            onPressed: () async {
              widget.box.put("token", "token");

              final response = await http.post(
                Uri.parse('$hostname/api/auth/local/'),
                headers: headers,
                body: jsonEncode(<String, String>{
                  'password': passwordController.text,
                  'email': emailController.text,
                }),
              );

              var responseData = json.decode(response.body);
            },
            child: const Text("Login")),
        TextButton(
            onPressed: () {
              setState(() {
                newAccount = true;
              });
            },
            child: const Text("Register")),
      ],
    );
  }

  Widget registerView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
        TextButton(
            onPressed: () async {
              widget.box.put("token", "token");

              final response = await http.post(
                Uri.parse('$hostname/api/auth/local/register'),
                headers: headers,
                body: jsonEncode(<String, String>{
                  'username': usernameController.text,
                  'password': passwordController.text,
                  'email': emailController.text,
                }),
              );

              var responseData = json.decode(response.body);
            },
            child: const Text("Create account")),
        TextButton(
            onPressed: () {
              setState(() {
                newAccount = false;
              });
            },
            child: const Text("Login")),
      ],
    );
  }
}
