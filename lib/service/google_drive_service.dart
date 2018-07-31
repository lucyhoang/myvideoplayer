import 'dart:async';
import 'dart:convert';
import 'package:my_video_player/model/video.dart';
import "package:http/http.dart" as http;
import 'package:my_video_player/model/globals.dart' as globals;


class GoogleDriveService {

  static const query = "mimeType = 'video/mp4'";
  static const String ALL_VIDEO_API = 'https://www.googleapis.com/drive/v2/files?q=${query}';

  Future<List<Video>> getAllVideo() async {

    var header = await globals.currentUser.authHeaders;
    final response = await http.get(
        ALL_VIDEO_API,
        headers: header);

    var list = json.decode(response.body)["items"];
    List<Video> result = new List<Video>();
    (list as List).forEach((value) {
        result.add(new Video(id: value["id"], title: value["title"], thumbnailLink: value["thumbnailLink"], viewLink: value["webContentLink"], embedLink: value["embedLink"], downloadUrl : value["downloadUrl"]));
    });

    return result;
  }

}

