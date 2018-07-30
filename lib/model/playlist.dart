import 'package:my_video_player/model/video.dart';
import 'package:my_video_player/model/globals.dart';

class PlayList{
  PlayList({
    this.id,
    this.name,
    this.videos
    });
  final String id;
  final String name;
  List<Video> videos;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map();
    data["id"] = this.id;
    data["name"] = this.name;
    return data;
  }
}

class PlayListEvent {
  EventType eventType;
  PlayList data;
  PlayListEvent(this.eventType, this.data);
}

class PlayListVideo {
  final Video video;
  final PlayList playList;
  bool isRelated;
  bool isChanged = false;

  PlayListVideo({
    this.video,
    this.playList,
    this.isRelated
  });

}

//test data
var kPlaylist = <PlayList> [
    PlayList(
      name: 'Music',
    ),
    PlayList(
      name: 'Favourite',
    ),
    PlayList(
      name: 'Fafa music',
    ),
    PlayList(
      name: 'LC music',
    ),
];