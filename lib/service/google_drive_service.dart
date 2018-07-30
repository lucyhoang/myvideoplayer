import 'dart:async';
import 'dart:convert';
import 'package:my_video_player/model/video.dart';
import "package:http/http.dart" as http;
import 'package:my_video_player/model/globals.dart' as globals;

class GoogleDriveService {

  static const String ALL_VIDEO_API = 'https://www.googleapis.com/drive/v2/files?maxResults=20&alt=json';

  Future<List<Video>> getAllVideo() async {

    final response = await http.get(
        ALL_VIDEO_API,
        headers: await globals.currentUser.authHeaders);

    var list = json.decode(response.body)["items"];
    List<Video> result = new List<Video>();

    (list as List).forEach((value) {
      if (value["mimeType"] == "video/mp4"){
        print("get from server:" + value.toString());
        result.add(new Video(id: value["id"], title: value["title"], thumbnailLink: value["thumbnailLink"], viewLink: value["webContentLink"], embedLink: value["embedLink"]));
      }
    });

    return result;
  }

}

