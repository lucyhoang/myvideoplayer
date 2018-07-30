import 'package:flutter/material.dart';
import 'package:my_video_player/repository/local_playlist_dao.dart';
import 'package:my_video_player/ui/video_list.dart';

class PlayListVideoPage extends StatefulWidget {
  PlayListVideoPage({Key key, @required this.title, this.id}) : super(key: key);

  final String title;
  final String id;

  @override
  _PlayListVideoState createState() => new _PlayListVideoState();
}

class _PlayListVideoState extends State<PlayListVideoPage> {
  PlayListDAO playListDAO = new PlayListDAO();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: playListDAO.getVideoList(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return new Scaffold(
          appBar: AppBar(
            elevation: 2.0,
            title: Text(widget.title),
          ),
          body: snapshot.hasData
              ? new ListVideo(
                  list: snapshot.data, inPlayList: true, playlistId: widget.id)
              : new CircularProgressIndicator(),
        );
      },
    );
  }
}
