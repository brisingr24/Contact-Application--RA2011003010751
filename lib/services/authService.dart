import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/userModel.dart';

class GoogleSignInProvider extends ChangeNotifier{
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  //late final Stream<UserModel?> userModelStream;
  //final newUser = FirebaseAuth.instance.currentUser!;

  Future googleLogin() async{
    final googleUser = await googleSignIn.signIn();
    if(googleUser == null)return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    notifyListeners();
  }

  Future change() async{
    if(_user!=null){
      // await FirebaseFirestore.instance
      //     .collection("users")
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .update({
      //   'name': user.displayName,
      //   'age': '',
      //   'photo' : user.photoUrl,
      // });
      // print('${user.displayName}');
      return const Wrapper();
    }
  }

  Future logOut() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}