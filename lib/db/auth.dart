

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth{
  Future<UserCredential> googleSignIn();
}

class Auth implements BaseAuth{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<UserCredential> googleSignIn() async{
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

    try{
      UserCredential user = await _firebaseAuth.signInWithCredential(credential);
      return user;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}