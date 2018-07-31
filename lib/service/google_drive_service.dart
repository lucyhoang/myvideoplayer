import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:my_video_player/model/video.dart';
import "package:http/http.dart" as http;
import 'package:my_video_player/model/globals.dart' as globals;

class GoogleDriveService {

  static const String ALL_VIDEO_API = 'https://www.googleapis.com/drive/v2/files?maxResults=20&alt=json';

  Future<List<Video>> getAllVideo() async {

    var header = await globals.currentUser.authHeaders;
    globals.token = header["Authorization"];

    final response = await http.get(
        ALL_VIDEO_API,
        headers: header);

    var list = json.decode(response.body)["items"];
    List<Video> result = new List<Video>();

    (list as List).forEach((value) {
      if (value["mimeType"] == "video/mp4")
      {
        result.add(new Video(id: value["id"], title: value["title"], thumbnailLink: value["thumbnailLink"], viewLink: value["webContentLink"], embedLink: value["embedLink"]));
      }
    });

    //var b = await getVideo();
    //print(b);

    return result;
  }

  static var httpClient = new HttpClient();

  Future<Object> getVideo() async {

//    String url = "https://drive.google.com/uc?id=17nfjMHB8Y8RrG1zlbut-00vXCKbRNAkz&export=download";
//    String filename = "lucyhoang";
//    var request = await httpClient.getUrl(Uri.parse(url));
//    var response = await request.close();
//    var bytes = await consolidateHttpClientResponseBytes(response);
//    String dir = "/Users/lucy/Projects/my_video_player/lib";
//    File file = new File('$dir/$filename');
//    await file.writeAsBytes(bytes);

    //return file;

    var header = await globals.currentUser.authHeaders;

    final response = await http.get(
        "https://drive.google.com/uc?id=17nfjMHB8Y8RrG1zlbut-00vXCKbRNAkz&export=download",
        headers: header);

    return response;

  }

}

