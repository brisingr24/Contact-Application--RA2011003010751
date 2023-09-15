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
  TextEditingController _name = new TextEditingController();
  TextEditingController _number = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CREATE NEW CONTACT'),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              onPressed: () async {
                if(_name.text.isNotEmpty && _number.text.length ==10){
                  _contactService.saveContact(_name.text, _number.text);
                  Navigator.pop(context);
                }
              },
              child: Text('SAVE'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter your username",
                    labelText: " Username",
                    prefixIcon: Icon(Icons.person_add_alt_1),
                    errorText:
                        _name.text.isEmpty ? 'Value Cannot be empty' : null,
                  ),
                  keyboardType: TextInputType.name,
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller: _number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "+91 Enter number here",
                      labelText: " Phone Number",
                      prefixIcon: Icon(Icons.phone),
                      errorText: _number.text.length != 10
                          ? 'Invalid Phone number'
                          : null,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        number = val;
                      });
                    }),
              ),
              // TextFormField(
              //   decoration: const InputDecoration(
              //     hintText: "Enter Name",
              //   ),
              //   keyboardType: TextInputType.name,
              //   onChanged: (val) {
              //     setState(() {
              //       name = val;
              //     });
              //   },
              // ),
              // TextFormField(
              //   decoration: const InputDecoration(
              //     hintText: "Enter Number",
              //   ),
              //   keyboardType: TextInputType.number,
              //   onChanged: (val) {
              //     setState(() {
              //       number = val;
              //     });
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
