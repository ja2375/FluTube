import 'package:flutter/material.dart';
import 'package:flutube/flutube.dart';
import 'test_video_route.dart';

void main() => runApp(MaterialApp(
  home: MyApp(),
  debugShowCheckedModeBanner: false,
));

class MyApp extends StatelessWidget {
  final _ytURL = 'https://www.youtube.com/watch?v=fq4N0hgOWzU';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FluTube Test'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text('Youtube video URL: $_ytURL', style: TextStyle(fontSize: 16.0),),
            FluTube(
              _ytURL,
              autoInitialize: true,
              aspectRatio: 16 / 9,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Center(
                child: RaisedButton(
                  child: Text('Test video in other route'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TestRoute())
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
