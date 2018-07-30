import 'package:flutter/material.dart';
import 'package:my_video_player/model/globals.dart' as globals;
import 'package:my_video_player/model/playlist.dart';

import '../repository/local_playlist_dao.dart';

class CreateNewPlaylist extends StatelessWidget {
  PlayListDAO playlistDAO = new PlayListDAO();

  @override
  Widget build(BuildContext context) {
    // Create a text controller. We will use it to retrieve the current value
    // of the TextField!
    final nameController = TextEditingController();

    @override
    void dispose() {
      // Clean up the controller when the Widget is disposed
      nameController.dispose();
    }

    return AlertDialog(
      title: Text("New playlist"),
      content: Container(
          height: 120.0,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(width: 1.0, color: Colors.grey),
                ),
                height: 40.0,
                child: new TextFormField(
                  controller: nameController,
                  autofocus: false,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding:
                        new EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 8.0),
                    hintText: 'Enter playlist name',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 14.0),
                  ),
                ),
              ),
              Container(
                child: Material(
                  borderRadius: BorderRadius.circular(4.0),
                  shadowColor: Color(0xFF3580ED),
                  elevation: 5.0,
                  child: MaterialButton(
                    minWidth: 200.0,
                    height: 44.0,
                    color: Color(0xFF3580ED),
                    child: Text('CREATE',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0)),
                    onPressed: () {
                      PlayList pl = new PlayList(
                          name: nameController.text,
                          id: DateTime.now().millisecondsSinceEpoch.toString());
                      playlistDAO.addPlayList(pl);
                      globals.eventBus.fire(pl);
                      print("fire event");
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
