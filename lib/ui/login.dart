import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_video_player/model/globals.dart' as globals;
import 'package:my_video_player/model/playlist.dart';
import 'package:my_video_player/model/video.dart';
import 'package:my_video_player/repository/local_playlist_dao.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  final String title;

  LoginPage({this.title});

  @override
  State createState() => new LoginState();
}

class LoginState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();

    globals.googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) {
      setState(() {
        globals.currentUser = account;
        print(
            "Change Current User. Now user is ${globals.currentUser != null}");
      });
    });

    globals.googleSignIn.signInSilently();
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];

    final Map<String, dynamic> contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<Null> _handleSignIn() async {
    try {
      await globals.googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Widget _buildBody() {
    if (globals.currentUser != null) {
      return new HomePage();
    } else {
      return new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are NOT currently signed in."),
          new RaisedButton(
            child: const Text('SIGN IN'),
            onPressed: _handleSignIn,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (globals.currentUser != null) {
      return new HomePage();
    } else {
      return new Scaffold(
          appBar: new AppBar(
            title: new Text(widget.title),
          ),
          body: new ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: _buildBody(),
          ));
    }
  }
}
