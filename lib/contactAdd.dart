import 'package:contact/models/userModel.dart';
import 'package:contact/services/contactService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final ContactService _contactService = ContactService();
  String name = "";
  String number = "";
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('CREATE NEW CONTACT'),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              onPressed: () async {
                _contactService.saveContact(name,number);
                //Navigator.pop(context);
              },
              child: Text('SAVE'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
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
            ],
          ),
        ),
      ),
    );
  }
}
