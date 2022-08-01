import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class AddForm extends StatefulWidget {
  const AddForm({Key? key, required this.box}) : super(key: key);
  final Box box;
  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  TextEditingController quoteController = TextEditingController();
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
        appBar: AppBar(
          title: Text("New Quote"),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            TextField(
              controller: quoteController,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: "What's on your mind?",
                  hintText: 'Enter Your Name'),
            ),
            TextButton(
                onPressed: () async {
                  var authToken = widget.box.get("authToken");
                  Map<String, String> headers = {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': 'Bearer $authToken'
                  };
                  //:TODO Change URL 
                  final response = await http.post(
                    Uri.parse('$hostname/api/auth/local/'),
                    headers: headers,
                    body: jsonEncode(<String, String>{'password': ""}),
                  );

                  var responseData = json.decode(response.body);
                },
                child: Text("Add Quote"))
          ]),
        ));
  }
}
