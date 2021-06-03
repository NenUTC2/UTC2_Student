import 'package:google_sign_in/google_sign_in.dart';

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
      return ggUser;
    } catch (error) {
      print("Lỗi đây ----------" + error.toString());
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
