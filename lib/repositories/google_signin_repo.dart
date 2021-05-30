import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInRepository {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  ///
  Future<GoogleSignInAccount> signIn() async {
    try {
      var ggUser = await _googleSignIn.signIn();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userEmail', ggUser.email);
      return ggUser;
    } catch (error) {
      print(error);
      return null;
    }
  }

  ///
  void signOut() async {
    _googleSignIn.signOut();
  }

  //
  GoogleSignInAccount getCurrentUser() {
    return _googleSignIn.currentUser;
  }
}
