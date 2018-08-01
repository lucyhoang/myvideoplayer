import 'dart:async';

import 'package:my_video_player/model/playlist.dart';
import 'package:my_video_player/model/video.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';

class PlayListDAO {
  Database _db;
  String _dbPath;

  static const String PLAYLISTS_STORE = "playlists"; //Store all the playlist
  static const String PLAYLIST_VIDEO_STORE = "playlist_video"; //Store relation between one playlist and videos
  static const String VIDEO_STORE = "videos"; //Store all the videos

  PlayListDAO({String databasePath}) {
    _dbPath = databasePath;
  }

  Future<Database> get _database async {
    if (_db == null) {
      if (_dbPath == null) {
        var dataDir = await getApplicationDocumentsDirectory();
        _dbPath = dataDir.path + "/videoplayer.db";
      }
      _db = await databaseFactoryIo.openDatabase(_dbPath);
    }
    return _db;
  }

  Future close() async {
    await _db?.close();
    _db = null;
  }

  Future<bool> addPlayList(PlayList playList) async {
    var db = await _database;

    //Add one new playlist to db
    var availablePL = await getPlayList(playList.id, true);

    if (availablePL == null) {
      var key =
          db.getStore(PLAYLISTS_STORE).put(playList.toJson(), playList.id);

      //Add videos and relation between playlist and videos
      if (key != null && playList.videos?.length > 0) {
        playList.videos.forEach((v) {
          key = db.getStore(VIDEO_STORE).put(v.toJson(), v.id);
          key = db
              .getStore(PLAYLIST_VIDEO_STORE)
              .put({"playlistId": playList.id, "videoId": v.id});
        });
      }

      return key != null;
    }

    return true;
  }

  Future<bool> addNewPlayList(String name) async {
    var db = await _database;

    Map<String, dynamic> data = new Map();
    data["id"] = DateTime.now().millisecondsSinceEpoch.toString();
    data["name"] = name;

    var key = db.getStore(PLAYLISTS_STORE).put(data, data["id"]);

    return key != null;
  }

  Future<bool> updatePlayListVideo(PlayList playList) async {
    var db = await _database;

    //Add one new playlist to db
    var availablePL = await getPlayList(playList.id, true);

    if (availablePL != null) {
      //Add videos and relation between playlist and videos
      if (playList.videos?.length > 0) {
        Finder finder = new Finder();
        finder.filter = new Filter.equal("playlistId", playList.id);
        Store playlistStore = db.getStore(PLAYLIST_VIDEO_STORE);
        await playlistStore.findKeys(finder).then((l) {
          for (int j = 0; j < l.length; j++) {
            playlistStore.delete(l[j]);
          }
        });

        var c = playList.videos.length;
        for (int i = 0; i < c; i++) {
          await addVideo(playList.videos[i]);
          await addPlayListVideo(playList.id, playList.videos[i].id);
        }
      }

      return true;
    }

    return true;
  }

  Future<bool> addVideo(Video video) async {
    var db = await _database;

    var availableVideo = await getVideo(video.id);
    if (availableVideo == null) {
      var key = db.getStore(VIDEO_STORE).put(video.toJson(), video.id);
      return key != null;
    }

    return true;
  }

  Future<bool> addPlayListVideo(String playlistId, String videoId) async {
    var db = await _database;

    Finder finder = new Finder();
    List<Filter> filters = new List<Filter>();
    filters.add(new Filter.equal("playlistId", playlistId));
    filters.add(new Filter.equal("videoId", videoId));
    finder.filter = new Filter.and(filters);

    Store store = db.getStore(PLAYLIST_VIDEO_STORE);
    var key = await store.findKey(finder);
    if (key != null)
      return true;
    else {
      key = db
          .getStore(PLAYLIST_VIDEO_STORE)
          .put({"playlistId": playlistId, "videoId": videoId});
      return key != null;
    }
  }

  Future<bool> removePlayListVideo(String playlistId, String videoId) async {
    var db = await _database;

    Finder finder = new Finder();
    List<Filter> filters = new List<Filter>();
    filters.add(new Filter.equal("playlistId", playlistId));
    filters.add(new Filter.equal("videoId", videoId));

    Store store = db.getStore(PLAYLIST_VIDEO_STORE);
    store.findKey(finder).then((key) => store.delete(key));

    return true;
  }

  Future<bool> removePlayList(String playlistId) async {
    var db = await _database;

    //Delete playlist on
    var key = db.getStore(PLAYLISTS_STORE).delete(playlistId);

    //Delete connection between playlist and video
    Finder finder = new Finder();
    finder.filter = new Filter.equal("playlistId", playlistId);
    Store store = db.getStore(PLAYLIST_VIDEO_STORE);
    store.findKeys(finder).then((keys) => store.deleteAll(keys));

    return key != null;
  }

  Future<Video> getVideo(String videoId) async {
    var db = await _database;

    Finder finder = new Finder();
    finder.filter = new Filter.equal("id", videoId);
    List<Record> records = await db.getStore(VIDEO_STORE).findRecords(finder);

    return records.length > 0 ? _toVideo(records.first.value) : null;
  }

  Future<List<Video>> getVideos(List<String> videoIds) async {
    var db = await _database;

    Finder finder = new Finder();
    finder.filter = new Filter.inList("id", videoIds);
    List<Record> records = await db.getStore(VIDEO_STORE).findRecords(finder);

    List<Video> videos = new List<Video>();

    records.forEach((r) {
      videos.add(_toVideo(r.value));
    });

    return videos;
  }

  Future<PlayList> getPlayList(String playlistId, bool ignoreVideo) async {
    var db = await _database;

    Finder finder = new Finder();
    finder.filter = new Filter.equal("id", playlistId);
    List<Record> records =
        await db.getStore(PLAYLISTS_STORE).findRecords(finder);
    PlayList playList =
        records.length > 0 ? _toPlayList(records.first.value) : null;
    if (playList != null && !ignoreVideo)
      playList.videos = await getVideoList(playlistId);

    return playList;
  }

  Future<List<PlayList>> getAllPlayLists() async {
    var db = await _database;

    Finder finder = new Finder();
    finder.filter = new Filter.notNull("id");
    List<Record> records =
        await db.getStore(PLAYLISTS_STORE).findRecords(finder);

    List<PlayList> playlists = new List<PlayList>();
    records.forEach((r) {
      playlists.add(_toPlayList(r.value));
    });

    var c = playlists.length;
    for (int i = 0; i < c; i++) {
      playlists[i].videos = await getVideoList(playlists[i].id);
    }

    return playlists;
  }

  Future<List<PlayListVideo>> getAllPlayListVideos(Video video) async {
    List<PlayList> list = await getAllPlayLists();
    List<PlayListVideo> playlistVideos = new List<PlayListVideo>();

    list.forEach((p) {
      playlistVideos.add(new PlayListVideo(
          video: video,
          playList: p,
          isRelated: p.videos.any((v) => v.id == video.id)));
    });

    return playlistVideos;
  }

  Future<List<Video>> getVideoList(String playlistId) async {
    List<Video> videos = new List<Video>();

    var db = await _database;

    Finder finder = new Finder();
    finder.filter = new Filter.equal("playlistId", playlistId);
    List<Record> records =
        await db.getStore(PLAYLIST_VIDEO_STORE).findRecords(finder);
    List<String> videoIds = new List<String>();
    records.forEach((r) => videoIds.add(r.value["videoId"]));

    return await getVideos(videoIds);
  }

  Future updatePlayList(Map<String, bool> playlists, Video video) async {
    var db = await _database;

    await addVideo(video);

    playlists.forEach((playlistId, isAdd) {
      if (isAdd){
        addPlayListVideo(playlistId, video.id);
      }
      else {
        removePlayListVideo(playlistId, video.id);
      }
    });

  }

  Video _toVideo(Map<String, dynamic> jsonMap) {
    if (jsonMap == null || jsonMap.length == 0) return null;
    return new Video(
        id: jsonMap["id"],
        title: jsonMap["title"],
        thumbnailLink: jsonMap["thumbnailLink"],
        viewLink: jsonMap["viewLink"],
        embedLink: jsonMap["embedLink"]);
  }

  PlayList _toPlayList(Map<String, dynamic> jsonMap) {
    if (jsonMap == null || jsonMap.length == 0) return null;
    return new PlayList(
        id: jsonMap["id"], name: jsonMap["name"], videos: new List<Video>());
  }
}
