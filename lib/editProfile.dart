import 'dart:io';
import 'package:contact/services/userService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final user = FirebaseAuth.instance.currentUser!;
  final UserService _userService = UserService();

  File? _profileImg;
  final picker = ImagePicker();
  late String name = user.displayName!;
  String age = "";

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _profileImg = File(pickedFile.path);
      }
    });
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () async {
                await _userService.updateProfile(name,age);
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text("SAVE"))
        ],
      ),
      body: Form(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              "ADD PROFILE PICTURE!",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Color(0xFFFF9494))),
                onPressed: () => getImage(),
                child: _profileImg == null
                    ? const Icon(Icons.person_add_alt_1_rounded)
                    : Image.file(
                  _profileImg!,
                  height: 100,
                )),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Color(0xFFFF9494))),
                onPressed: () async {
                  await _userService.updatePic(_profileImg!);
                },
                child: Text("SAVE PIC")),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              onChanged: (val) => setState(() {
                age = val;
              }),
              keyboardType: TextInputType.name,
            ),
          ],
        ),
      ),
    );
  }
}