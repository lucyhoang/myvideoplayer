import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/widgets.dart';
import 'package:my_video_player/model/globals.dart' as globals;

class LogoutPage extends StatelessWidget {
  Future<GoogleSignInAccount> getData() async {
    return globals.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<GoogleSignInAccount>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? (snapshot.data != null
                  ? new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        new ListTile(
                          leading: new GoogleUserCircleAvatar(
                            identity: snapshot.data,
                          ),
                          title: new Text(snapshot.data.displayName),
                          subtitle: new Text(snapshot.data.email),
                        ),
                        new RaisedButton(
                          child: const Text('SIGN OUT'),
                          onPressed: _handleSignOut,
                        ),
                      ],
                    )
                  : new Text("SIGN OUT SUCCESS"))
              : new CircularProgressIndicator();
        });
  }

  Future<Null> _handleSignOut() async {
    globals.googleSignIn.disconnect().then((u) {
      //Navigator.push(null, MaterialPageRoute(builder: (context) => LoginPage(),),);
    }); // ignore: missing_identifier, expected_token
  }
}
