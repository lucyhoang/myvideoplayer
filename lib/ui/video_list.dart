import 'dart:async';
import 'dart:io';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:my_video_player/model/globals.dart' as globals;
import 'package:my_video_player/repository/local_playlist_dao.dart';
import 'package:my_video_player/model/video.dart';
import 'add_to_playlist.dart';
import 'play_video.dart';
import 'package:path_provider/path_provider.dart';

class ListVideo extends StatefulWidget {
  final List<Video> list;
  final bool inPlayList;
  final String playlistId;

  ListVideo({this.list, this.inPlayList, this.playlistId});

  @override
  ListVideoState createState() => new ListVideoState(list);
}

class ListVideoState extends State<ListVideo> {
  static const int NEW_PLAYLIST = 1;
  static const int ADD_TO_PLAYLIST = 2;
  static const int REMOVE_FROM_PLAYLIST = 3;

  List<Video> list;

  ListVideoState(this.list);

  PlayListDAO playListDAO = new PlayListDAO();

  @override
  void initState() {
    super.initState();
    globals.eventBus.on<VideoEvent>().listen((event) {
      setState(() {
        if (widget.inPlayList) {
          switch (event.eventType) {
            case globals.EventType.Remove:
              list.removeWhere((v) => v.id == event.video.id);
              break;
            case globals.EventType.Add:
              if (event.playlistId == widget.playlistId) {
                list.add(event.video);
              }
              break;
            default:
              break;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
            margin: EdgeInsets.only(top: 15.0),
            child: ListTile(
              contentPadding:
                  EdgeInsets.only(top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
              leading: Container(
                  width: 120.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      //border: Border.all(width: 1.0, color: Colors.grey[300]),
                      borderRadius: BorderRadius.circular(1.0)),
                  child: MaterialButton(
                    child: list[i].thumbnailLink != null
                        ? new Container(
                            height: 50.0,
                            decoration: new BoxDecoration(
                                image: new DecorationImage(
                                    image:
                                        new NetworkImage(list[i].thumbnailLink),
                                    fit: BoxFit.cover)),
                          )
                        : Icon(Icons.play_arrow),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return new FutureBuilder<File>(
                            future: _downloadFile(list[i].downloadUrl, list[i].title),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) print(snapshot.error);
                              return snapshot.hasData
                                  ? new VideoApp(file: snapshot.data, title: list[i].title)
                                  : Center(child: new CircularProgressIndicator());
                            });
                      }),
                    ),
                  )),
              title: Text(list[i].title.split(".")[0]),
              trailing: PopupMenuButton<int>(
                icon:
                    Icon(Icons.more_vert, size: 30.0, color: Colors.grey[700]),
                itemBuilder: (BuildContext context) {
                  if (widget.inPlayList == true)
                    return <PopupMenuItem<int>>[
                      const PopupMenuItem<int>(
                        value: ADD_TO_PLAYLIST,
                        child: Text('Add to playlist'),
                      ),
                      PopupMenuItem<int>(
                        value: REMOVE_FROM_PLAYLIST,
                        child: Text('Delete from Library'),
                      ),
                    ];
                  else
                    return <PopupMenuItem<int>>[
                      const PopupMenuItem<int>(
                        value: ADD_TO_PLAYLIST,
                        child: Text('Add to playlist'),
                      ),
                    ];
                },
                onSelected: (menuId) => _onPopupMenuButtonItemSelected(
                    context, menuId, widget.playlistId, list[i]),
              ),
            ));
      },
    );
  }

  void _onPopupMenuButtonItemSelected(
      BuildContext context, int menuId, String playlistId, Video video) {
    PlayListDAO playListDAO = new PlayListDAO();

    switch (menuId) {
      case ADD_TO_PLAYLIST:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return new FutureBuilder<List>(
                future: playListDAO.getAllPlayListVideos(video),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? new PlayListSelect(playlistVideo: snapshot.data)
                      : new CircularProgressIndicator();
                });
          }),
        );
        break;
      case REMOVE_FROM_PLAYLIST:
        playListDAO.removePlayListVideo(playlistId, video.id).then((removedOk) {
          VideoEvent videoEvent = new VideoEvent(
              eventType: globals.EventType.Remove,
              video: video,
              playlistId: playlistId);
          globals.eventBus.fire(videoEvent);
        });
        break;
      default:
        break;
    }
  }

  Future<File> _downloadFile(String url, String fileName) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$fileName');
    bool fileExist = await file.exists();

    if (!fileExist) {
      var header = await globals.currentUser.authHeaders;
      final response = await http.get(url, headers: header);
      await file.writeAsBytes(response.bodyBytes);
    }

    return file;
  }
}
