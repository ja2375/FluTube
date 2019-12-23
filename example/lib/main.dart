import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutube/flutube.dart';

void main() => runApp(MaterialApp(
  home: MyApp(),
));

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final videoUrl = 'https://youtu.be/fq4N0hgOWzU';
  String stateText;

  @override
  void initState() {
    super.initState();
    stateText = "Video not started";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FluTube Test'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text('Youtube video URL: $videoUrl', style: TextStyle(fontSize: 16.0)),
            FluTube(
              videoUrl,
              autoInitialize: true,
              aspectRatio: 16 / 9,
              looping: true,
              onVideoStart: () {
                setState(() {
                  stateText = 'Video started playing!';
                });
              },
              onVideoEnd: () {
                setState(() {
                  stateText = 'Video ended playing!';
                });
              },
            ),
            Text(stateText),
          ],
        ),
      ),
    );
  }
}
