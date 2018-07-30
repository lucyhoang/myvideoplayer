import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class VideoPlay extends StatelessWidget {
  VideoPlay({Key key, this.title, this.url}) : super(key: key);

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          title: Text('Play video'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add, size: 30.0, color: Colors.white),
              onPressed: () {},
            )
          ],
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              new WebviewScaffold(url: url),
            ],
          ),
          // ignore: expected_token
        ));
  }
}
