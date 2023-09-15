import 'package:contact/editProfile.dart';
import 'package:contact/models/userModel.dart';
import 'package:contact/services/userService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class Profile extends StatefulWidget {
  final String uid;
  Profile({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  late final Stream<UserModel?> userModelStream;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Center(child: Text('Profile'),),
      ),
      drawer: const SideDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(user.photoURL!),
              ),
              SizedBox(height: 10,),
              Text('Name : ' + user.displayName!),
              SizedBox(height: 20,),
              Text('Email : ' + user.email!),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadingView() => const Center(
    child: CircularProgressIndicator(),
  );
}

