import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  // final FirebaseAuth FirebaseAuth.instance;

  // UserRepository()
  //     : FirebaseAuth.instance = FirebaseAuth.instance;

  static Future<void> signInWithCredentials(
      String email, String password) async {
    return await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> signUp(String email, String password) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    return Future.wait([FirebaseAuth.instance.signOut()]);
  }

  static Future<bool> isSignedIn() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null;
  }

  static Future<User> getUser() async {
    return FirebaseAuth.instance.currentUser;
  }
}
