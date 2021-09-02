import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
                onPressed: caller.registerToken(),
                child: const Text('Register Token')),
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your direct message'),
            ),
            ElevatedButton(
                onPressed: caller.registerToken(),
                child: const Text('Send push')),
            Text(caller.returnedMessage),
            Divider(color: Colors.blueGrey),
            Text(caller.notificationPayload)
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
