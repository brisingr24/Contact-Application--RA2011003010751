import 'dart:collection';
import 'dart:io';
import 'package:contact/models/userModel.dart';
import 'package:contact/services/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService{

  UtilsService _utilsService = UtilsService();


  UserModel? userFromFirebaseSnapshot(DocumentSnapshot<dynamic> snapshot){
    return snapshot != null
        ?UserModel(
      name: snapshot.data()['name'],
      age: snapshot.data()['age'],
    ) :UserModel();
  }

  Stream<UserModel?> getUserInfo(uid){
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map(userFromFirebaseSnapshot);
  }

  Future <void> updateProfile (String name,String age) async {


    Map<String,Object> data = HashMap();
    if (name != '') data['name'] = name;
    if (age != '') data['age'] = age;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(data);
  }

  Future <void> updatePic (File _profileImg) async {

    String profileImgURL = "";

    if(_profileImg != null){
      //save image to storage
      profileImgURL = await _utilsService.uploadFile(_profileImg,'user/profile/${FirebaseAuth.instance.currentUser?.uid}/profile');
    }

    Map<String,Object> data = HashMap();
    if (profileImgURL != '') data['profileImgURL'] = profileImgURL;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(data);
  }
}