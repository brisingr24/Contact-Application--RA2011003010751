import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact/contactDisplay.dart';
import 'package:contact/profile.dart';
import 'package:contact/register.dart';
import 'package:contact/services/authService.dart';
import 'package:contact/services/contactService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/contactModel.dart';
import 'models/userModel.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _LoggedInState createState() => _LoggedInState();
}

class _LoggedInState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      drawer: const SideDrawer(),
      body: ContactScreen(FirebaseAuth.instance.currentUser!.uid),
    );
  }
}

class ContactScreen extends StatefulWidget {
  String uid;
  ContactScreen(this.uid,{super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
  
}

class _ContactScreenState extends State<ContactScreen> {
  final ContactService _contactService = ContactService();
  String name = "";
  String number = "";

  
  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text('Add a new Contact'),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Enter Name",
              ),
              keyboardType: TextInputType.name,
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Enter Number",
              ),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                setState(() {
                  number = val;
                });
              },
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                onPressed: () async {
                  _contactService.saveContact(name, number);
                  //Navigator.pop(context);
                },
                child: const Text('SAVE')),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Your Contacts",
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              child: Expanded(
                  child: ContactDisplay(FirebaseAuth.instance.currentUser!.uid)),
            ),
            //Container(height: 200,width: 300,color: Colors.red,)
          ],
        ),
      ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'uniqueTag',
        onPressed: () async {
          _contactService.saveContact(name, number);
        }, label: const Text('Save Contact'),
      ),
    );
  }
}

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          const DrawerHeader(
            child: Text('LOGO'),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: const Text('Profile'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profile(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                  ),
                ),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () async {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const Register(),
                ),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
