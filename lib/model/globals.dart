import 'package:google_sign_in/google_sign_in.dart';
import 'package:event_bus/event_bus.dart';

GoogleSignIn googleSignIn = new GoogleSignIn(
  scopes: <String>[
    'https://www.googleapis.com/auth/drive',
  ],
);

String token;

GoogleSignInAccount _currentUser;

GoogleSignInAccount get currentUser {
  return _currentUser;
}

set currentUser(GoogleSignInAccount val) {
  _currentUser = val;
}

EventBus eventBus = new EventBus();

enum EventType {
  Add,
  Remove,
  Updated
}



