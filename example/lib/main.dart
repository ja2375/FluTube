import 'package:flutter/material.dart';
import 'package:flutube/flutube.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  String _ytURL = 'https://www.youtube.com/watch?v=fq4N0hgOWzU';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

}
