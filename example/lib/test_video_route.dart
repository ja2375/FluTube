import 'package:flutter/material.dart';
import 'package:flutube/flutube.dart';

class TestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test video route'),
      ),
      body: Center(
        child: FluTube(
          'https://www.youtube.com/watch?v=fq4N0hgOWzU',
          autoInitialize: true,
          aspectRatio: 16 / 9,
        ),
      ),
    );
  }
}