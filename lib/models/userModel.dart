import 'package:flutter/cupertino.dart';

class UserModel extends ChangeNotifier{
  String? uid;
  String? name;
  String? age;
  String? profileImgURL;
  UserModel({this.uid,this.name,this.age,this.profileImgURL}){
    notifyListeners();
  }
}