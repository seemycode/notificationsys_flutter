import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notificationsys/bloc_chat.dart';
import 'package:notificationsys/bloc_firebase.dart';
import 'package:notificationsys/src/generated/sm.pbgrpc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BlocFirebase.initFirebase();
  runApp(NotificationSysApp());
}

class NotificationSysApp extends StatelessWidget {
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
  var _blocFirebase = BlocFirebase();
  var _blocChat = BlocChat();

  String? _fcmToken;
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _blocFirebase.getInitialMessage();
    _blocFirebase.getToken();
    _blocFirebase.listenToMessageInForeground();
    _blocFirebase.listenToMessageInBackground();
  }

  @override
  void dispose() {
    _blocChat.closeStream();
    _blocFirebase.closeStream();
  }

  @override
  Widget build(BuildContext context) {
    var _text = TextEditingController();
    var _scroll = ScrollController();

    // Animation to jump to last message
    Timer(Duration(seconds: 1),
        () => _scroll.jumpTo(_scroll.position.maxScrollExtent));

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
              child: Row(
                children: [
                  Text(
                    'Mensagens',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.lightBlue,
                child: ListView.builder(
                  controller: _scroll,
                  padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white,
                      elevation: 1.0,
                      child: ListTile(
                        title: Container(
                          padding: EdgeInsets.all(3.0),
                          child: StreamBuilder<StandardResponse>(
                              stream: _blocChat.sendRequest,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Failed to retrieve messages');
                                } else {
                                  _messages.add(snapshot.data!.status);
                                  return Text(
                                    _messages[index],
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  );
                                }
                              }),
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
                onSubmitted: _submitMessage,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type your message',
                  hintStyle: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.grey.shade600),
                  suffixIcon: IconButton(
                    onPressed: () => _clearNewMessageText(_text),
                    icon: Icon(Icons.clear),
                  ),
                ),
              ),
            ),
            Container(
              height: 100,
              padding: EdgeInsets.all(12.0),
              color: Colors.black45,
              child: StreamBuilder<String>(
                  stream: _blocFirebase.firebaseEcho,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        snapshot.error.toString(),
                        style: TextStyle(color: Colors.white),
                      );
                    } else {
                      _fcmToken = '${snapshot.data}';
                      return Text(
                        '${_fcmToken}',
                        style: TextStyle(color: Colors.white),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  /// Submit the message to firebase
  void _submitMessage(msg) {
    _blocChat.sendMessage(_fcmToken!, msg);
  }

  /// Clear new message text field canvas
  void _clearNewMessageText(field) {
    field.clear();
  }
}
