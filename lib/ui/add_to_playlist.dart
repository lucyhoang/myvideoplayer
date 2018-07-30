import 'package:flutter/material.dart';
import 'package:my_video_player/model/playlist.dart';
import 'package:my_video_player/repository/local_playlist_dao.dart';

class PlayListSelect extends StatefulWidget {
  PlayListSelect({Key key, this.playlistVideo}) : super(key: key);

  List<PlayListVideo> playlistVideo;

  @override
  _PlayListSelectState createState() {
    return new _PlayListSelectState();
  }
}

class _PlayListSelectState extends State<PlayListSelect> {
  PlayListDAO playListDAO = new PlayListDAO();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Product List"),
        ),
        body: new Container(
          padding: new EdgeInsets.all(8.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Expanded(
                  child: new ListView(
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                children: widget.playlistVideo.map((PlayListVideo product) {
                  return new _PlayListSelectItem(product);
                }).toList(),
              )),
              Row(
                children: <Widget>[
                  new Expanded(
                    child: new RaisedButton(
                      onPressed: () {
                        Map<String, bool> changedPL = new Map<String, bool>();
                        for (PlayListVideo p in widget.playlistVideo) {
                          if (p.isChanged) changedPL[p.playList.id] = p.isRelated;
                          print(changedPL.length);
                          print("-------------");
                        }
                        playListDAO.updatePlayList(changedPL, widget.playlistVideo.first.video);
                      },
                      child: new Text('Save'),
                    ),
                  ),
                  new Expanded(
                    child: new RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: new Text('Cancel'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

class _PlayListSelectItem extends StatefulWidget {
  final PlayListVideo product;

  _PlayListSelectItem(PlayListVideo product)
      : product = product,
        super(key: new ObjectKey(product));

  @override
  _PlayListSelectItemState createState() {
    return new _PlayListSelectItemState(product);
  }
}

class _PlayListSelectItemState extends State<_PlayListSelectItem> {
  final PlayListVideo playlistVideo;

  _PlayListSelectItemState(this.playlistVideo);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        onTap: null,
        leading: new Icon(Icons.playlist_play),
        title: new Row(
          children: <Widget>[
            new Expanded(child: new Text(playlistVideo.playList.name)),
            new Checkbox(
                value: playlistVideo.isRelated,
                onChanged: (bool value) {
                  setState(() {
                    playlistVideo.isRelated = value;
                    playlistVideo.isChanged = true;
                  });
                })
          ],
        ));
  }
}
