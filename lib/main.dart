import 'package:flutter/material.dart';
import 'package:my_video_player/ui/login.dart';

void main() {
  print('Start my app');
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Video player',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(title: 'Video Player')
    );
  }
}
