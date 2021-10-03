import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotificationSys',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Notification Sys'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var caller = new APICaller();
  late FirebaseMessaging messaging;
  late String token = "";

  void registerNotification() async {
    // prints token for testing
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      token = value!;
      print(value);
    });
  }

  @override
  void initState() {
    super.initState();
    registerNotification();

    FirebaseMessaging.onMessage.listen((event) {
      print("message received!");
      print(event.notification!.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('Message clicked!');
    });
  }

  List<String> _messages = [];

  @override
  Widget build(BuildContext context) {
    var _text = TextEditingController();
    var _scroll = ScrollController();
    var _onSubmitted = (text) {
      //TODO call SendMessage
      print(_messages.length);
      setState(() {
        _messages.add(text);
      });
    };
    var _clearText = () {
      _text.clear();
    };

    Timer(
      Duration(seconds: 1),
      () => _scroll.jumpTo(_scroll.position.maxScrollExtent),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(15.0),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black54)),
              child: Text(
                'Mensagens',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.black87,
                child: ListView.builder(
                  controller: _scroll,
                  padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.blueGrey,
                      elevation: 1.0,
                      child: ListTile(
                        title: Container(
                          padding: EdgeInsets.all(3.0),
                          child: Text(
                            _messages[index],
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
              ),
              child: TextField(
                controller: _text,
                onSubmitted: _onSubmitted,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Message',
                  hintStyle: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.grey.shade600),
                  suffixIcon: IconButton(
                    onPressed: _clearText,
                    icon: Icon(Icons.clear),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(12.0),
              color: Colors.black54,
              child: SelectableText(
                token,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class APICaller {
  String returnedMessage = "No data";
  String notificationPayload = "";

  registerToken() {
    //TODO: call register token
  }

  sendPush() {
    //TODO: push notification
  }
}
