import 'package:my_video_player/model/globals.dart';

class Video {
  Video({
    this.id,
    this.title,
    this.thumbnailLink,
    this.viewLink,
    this.embedLink,
    this.downloadUrl
    });

  final String id;
  final String title;
  final String thumbnailLink;
  final String viewLink;
  final String embedLink;
  final String downloadUrl;

  Map<String, dynamic> toJson() {

    Map<String, dynamic> data = new Map();
    data["id"] = this.id;
    data["title"] = this.title;
    data["thumbnailLink"] = this.thumbnailLink;
    data["viewLink"] = this.viewLink;
    data["embedLink"] = this.embedLink;
    data["downloadUrl"] = this.downloadUrl;

    return data;

  }

}

class VideoEvent {
  EventType eventType;
  Video video;
  String playlistId;

  VideoEvent({this.eventType, this.video, this.playlistId});
}

//Test data
var kVideos = <Video>[
    Video(
      title: 'Teenage',
    ),
    Video(
      title: 'Teenage',
    ),
    Video(
      title: 'Teenage',
    ),
    Video(
      title: 'Teenage',
    ),
    Video(
      title: 'Teenage',
    ),
    Video(
      title: 'Teenage',
    ),
    Video(
      title: 'Teenage',
    ),
];