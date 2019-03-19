import 'package:flutter/material.dart';
import 'package:flutube/flutube.dart';

void main() => runApp(MaterialApp(
  home: MyApp(),
));

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final List<String> playlist = <String>[
    'https://www.youtube.com/watch?v=fq4N0hgOWzU',
    'https://www.youtube.com/watch?v=D-o4BqJxmJE',
    'https://www.youtube.com/watch?v=jF0kD7lxTTw'
  ];
  int currentPos;
  String stateText;

  @override
  void initState() {
    currentPos = 0;
    stateText = "Video not started";
    super.initState();
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
            Text('Youtube video URL: ${playlist[currentPos]}', style: TextStyle(fontSize: 16.0),),
            FluTube(
              playlist[currentPos],
              autoInitialize: true,
              aspectRatio: 16 / 9,
              allowMuting: false,
              onVideoStart: () {
                setState(() {
                  stateText = 'Video started playing!';
                });
              },
              onVideoEnd: () {
                setState(() {
                  stateText = 'Video ended playing!';
                  if((currentPos + 1) < playlist.length)
                    currentPos++;
                });
              },
              onVideoError: () {
                setState(() {
                  stateText = 'Video has error :/';
                });
              },
            ),
            Text(stateText),
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: FlatButton(
                child: Text('CHANGE VIDEO URL'),
                onPressed: () {
                  setState(() {
                    if((currentPos + 1) < playlist.length)
                      currentPos++;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
