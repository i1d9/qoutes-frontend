import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:quotes/screens/form.dart';
import 'package:flutter/foundation.dart';

import 'package:quotes/screens/profile.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.box}) : super(key: key);
  final Box box;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<dynamic> quotes;
  late Stream<String> _tokenStream;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String get hostname {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8888';
    } else {
      return 'http://localhost:1337';
    }
  }

  Future<void> fetchQuotes() async {
    String url = "$hostname/api/quotes";
    var authToken = widget.box.get("authToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $authToken'
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    var responseData = json.decode(response.body);
    setState(() {
      quotes = responseData;
    });
  }

  @override
  void initState() {
    super.initState();

    if (!widget.box.containsKey("fcm")) {
      if (kIsWeb) {
        //TODO: Get APN Key from Firebase
        FirebaseMessaging.instance
            .getToken(
                vapidKey:
                    'BGBnjtByQobgwijnKjCAP8kzqjH-4MdA1HH4ZgEdVXQVeZhud6kr4soKzuVjYT1xxRo5cEqdDBALY6oQKnQSdSs')
            .then(setToken);
      } else {
        //If Running android
        FirebaseMessaging.instance.getToken().then(setToken);
      }
    }

    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
    fetchQuotes();
  }

  void setToken(String? token) {
    if (token != null) {
      var authToken = widget.box.get("authToken");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken'
      };
      http.post(
        Uri.parse('$hostname/api/auth/local/'),
        headers: headers,
        body: jsonEncode(<String, String>{
          'fcm': token,
        }),
      );
      widget.box.put("fcm", token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(box: widget.box),
                      ));
                },
                icon: const Icon(Icons.person))
          ],
          title: const Text('Strapi Quotes'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddForm(box: widget.box),
                ));
          }),
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: 50,
            itemBuilder: ((context, index) {
              return ListTile(
                title: const Text("lorem ipsum"),
                subtitle: const Text("Author"),
                trailing: Column(
                  children: [
                    GestureDetector(
                        onTap: (() async {
                          var authToken = widget.box.get("token");
                          Map<String, String> headers = {
                            'Content-Type': 'application/json',
                            'Accept': 'application/json',
                            'Authorization': 'Bearer $authToken'
                          };
                          await http.post(
                            Uri.parse('$hostname/api/auth/local/'),
                            headers: headers,
                            body: jsonEncode(<String, String>{
                              'quote_id': '1',
                              'user_id': '1'
                            }),
                          );

                          fetchQuotes();
                        }),
                        child: const Icon(Icons.favorite,
                            color: false ? Colors.red : Colors.blue)),
                    const Text("54")
                  ],
                ),
              );
            })));
  }
}
