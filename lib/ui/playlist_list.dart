import 'package:flutter/material.dart';
import 'package:my_video_player/model/globals.dart' as globals;
import 'package:my_video_player/repository/local_playlist_dao.dart';
import 'package:my_video_player/model/playlist.dart';
import 'package:my_video_player/ui/playlist_detail.dart';

class PlaylistPage extends StatefulWidget {
  PlaylistPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PlaylistPageState createState() => new _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  PlayListDAO playListDAO = new PlayListDAO();

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List>(
        future: playListDAO.getAllPlayLists(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new _AllPlayList(snapshot.data)
              : new CircularProgressIndicator();
        });
  }
}

class _AllPlayList extends StatefulWidget {
  final List<PlayList> playlist;

  _AllPlayList(this.playlist);

  @override
  _AllPlayListState createState() => new _AllPlayListState(playlist);
}

class _AllPlayListState extends State<_AllPlayList> {
  final List<PlayList> playlist;

  _AllPlayListState(this.playlist);

  @override
  void initState() {
    super.initState();
    globals.eventBus.on<PlayListEvent>().listen((event) {
      setState(() {
        if (event.eventType == globals.EventType.Add){
          playlist.add(event.data);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    PlayListDAO playListDAO = new PlayListDAO();

    return ListView(
      children: playlist
          .map(
            (c) => Container(
                margin: EdgeInsets.only(bottom: 15.0),
                child: ListTile(
                  contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                  leading: Icon(Icons.playlist_play),
                  title: Text(c.name),
                  trailing: Icon(
                    Icons.chevron_right,
                    size: 30.0,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlayListVideoPage(
                                id: c.id,
                                title: c.name,
                              )),
                    );
                  },
                  onLongPress: () {
                    showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                              child: Column(children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          width: 1.0,
                                          color: Colors.grey[300]))),
                              child: ListTile(
                                title: Material(
                                  borderRadius: BorderRadius.circular(4.0),
                                  shadowColor: Color(0xFF3580ED),
                                  elevation: 0.0,
                                  child: MaterialButton(
                                    minWidth: 200.0,
                                    height: 44.0,
                                    child: Text('DELETE',
                                        style: TextStyle(
                                            color: Colors.redAccent[700],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0)),
                                    onPressed: () {
                                      playListDAO.removePlayList(c.id);
                                      playlist
                                          .removeWhere((pl) => pl.id == c.id);
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            )
                          ]));
                        });
                  },
                )),
          )
          .toList(),
    );
  }
}
