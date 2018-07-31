import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class VideoPlay extends StatelessWidget {
  VideoPlay({Key key, this.title, this.url}) : super(key: key);

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



