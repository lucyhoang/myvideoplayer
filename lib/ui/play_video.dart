import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:video_player/video_player.dart';

class VideoPlay_Webview extends StatelessWidget {
  VideoPlay_Webview({Key key, this.title, this.url}) : super(key: key);

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
            url: url,
            appBar: new AppBar(
              title: new Text(title),
            )
    );
  }
}

class VideoApp extends StatefulWidget {
  File file;
  String title;

  VideoApp({this.file, this.title});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(widget.title),
      ),
      body: Center(
        child: _controller.value.initialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _controller.value.isPlaying
            ? _controller.pause
            : _controller.play,
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}


