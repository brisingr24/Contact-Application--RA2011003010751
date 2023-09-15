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
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Center(child: Text('Profile'),),
      ),
      drawer: const SideDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Profile"),
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.photoURL!),
            ),
            Text('Name : ' + user.displayName!),
            Text('Email : ' + user.email!),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
      // body: StreamBuilder<UserModel?>(
      //   stream: UserService().getUserInfo(_user.uid),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       if (snapshot.data != null) {
      //         UserModel user = snapshot.data!;
      //         return Column(
      //           children: [
      //             CircleAvatar(
      //               radius: 40,
      //               backgroundImage: NetworkImage(_user.photoURL!),
      //             ),
      //             const SizedBox(height: 10,),
      //             Text('${user.name}'),
      //             Text('${user.age}'),
      //             const SizedBox(height: 10,),
      //             ElevatedButton(
      //               onPressed: () => Navigator.push(context,
      //                   MaterialPageRoute(builder: (context) => EditProfile())),
      //               child: Text('Edit Profile'),
      //               style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
      //             ),
      //           ],
      //         );
      //       }
      //     }
      //     return loadingView();
      //   },
      // ),
    );
  }

  Widget loadingView() => const Center(
    child: CircularProgressIndicator(),
  );
}

