import 'package:flutter/material.dart';
import 'package:my_video_player/service/google_drive_service.dart';
import 'package:my_video_player/ui/logout.dart';
import 'package:my_video_player/ui/video_list.dart';

import 'create_playlist_dialog.dart';
import 'playlist_list.dart';

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  GoogleDriveService service = new GoogleDriveService();

  Widget changeTitleTab() {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: index != 0,
          child: TickerMode(enabled: index == 0, child: Text('All videos')),
        ),
        Offstage(
          offstage: index != 1,
          child: TickerMode(enabled: index == 1, child: Text('Playlist')),
        ),
        Offstage(
          offstage: index != 2,
          child: TickerMode(enabled: index == 2, child: Text('Profile')),
        ),
      ],
    );
  }

  Widget changeTAction() {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: index != 0,
          child: TickerMode(
            enabled: index == 0,
            child: new Text(""),
          ),
        ),
        Offstage(
          offstage: index != 1,
          child: TickerMode(
              enabled: index == 1,
              child: IconButton(
                  icon: Icon(Icons.add, size: 30.0, color: Colors.white),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => CreateNewPlaylist());
                  })),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: changeTitleTab(),
        actions: <Widget>[
          changeTAction(),
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Offstage(
            offstage: index != 0,
            child: new TickerMode(enabled: index == 0, child: AllVideosPage()),
          ),
          new Offstage(
            offstage: index != 1,
            child: new TickerMode(enabled: index == 1, child: PlaylistPage()),
          ),
          new Offstage(
            offstage: index != 2,
            child: new TickerMode(
                enabled: index == 2,
                //child:LogoutPage("log out", currentUser)
                child: LogoutPage()),
          ),
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: index,
        onTap: (int index) {
          setState(() {
            this.index = index;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.video_library,
              size: 20.0,
            ),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text(""),
          ),
        ],
      ),
    );
  }
}

class AllVideosPage extends StatelessWidget {
  GoogleDriveService service = new GoogleDriveService();

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List>(
        future: service.getAllVideo(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new ListVideo(list: snapshot.data, inPlayList: false)
              : Center(child: new CircularProgressIndicator());
        });
  }
}
