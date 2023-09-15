import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact/models/contactModel.dart';
import 'package:contact/models/userModel.dart';
import 'package:contact/services/contactService.dart';
import 'package:flutter/material.dart';
import 'contactEdit.dart';

class ContactDisplay extends StatefulWidget {
  String uid;
  ContactDisplay(this.uid, {Key? key}) : super(key: key);

  State<ContactDisplay> createState() => _ContactDisplayState();
}

class _ContactDisplayState extends State<ContactDisplay> {
  late final Stream<List<ContactModel>> contactModelStream;
  final ContactService _contactService = ContactService();
  late final Stream<UserModel?> userModelStream;
  String text="";
  var _formkey = GlobalKey<FormState>();
  TextEditingController _name = new TextEditingController();
  TextEditingController _number = new TextEditingController();

  @override
  void initState() {
    contactModelStream = _contactService.getContactByUser(widget.uid);
    // _name.dispose();
    // _number.dispose();
    super.initState();
  }

  showModalBox(String? cid){
    showModalBottomSheet(context: context, builder: (BuildContext context) => Container(
      height: MediaQuery.of(context).size.height*0.5,
      width: MediaQuery.of(context).size.width*0.9,
      color: Colors.green,
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                hintText: "Name",
              ),
              keyboardType: TextInputType.name,
            ),
            TextFormField(
              controller: _number,
              decoration: const InputDecoration(
                hintText: "Number",
              ),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.uid)
                      .collection("contacts")
                      .doc(cid)
                      .update({
                    'name': _name.text,
                    'number': _number.text,
                  }).then((value){
                    _name.text='';
                    _number.text='';
                    Navigator.pop(context);
                  });
                },
                child: const Text('Update')),
          ],
        ),
      ),
    ));
  }

  // Widget loadingView() => const Center(
  //       child: CircularProgressIndicator(),
  //     );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<List<ContactModel>>(
      stream: contactModelStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          if (snapshot.data!.isNotEmpty) {
            List<ContactModel> contacts = snapshot.data!;
            return SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: size.height*0.55,
                  child: Expanded(
                    child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 25,
                          );
                        },
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          final contact = contacts[index];
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(color: Colors.black)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${contact.name}'),
                                  Text('${contact.number}'),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                          style:
                                          ElevatedButton.styleFrom(primary: const Color(0xFFFF9494)),
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(widget.uid)
                                                .collection("contacts")
                                                .doc(contact.id)
                                                .delete()
                                                .then((value) {
                                              print("Success");
                                            }).catchError((error) => print("Failed cuz ${error}"));
                                          },
                                          child: const Icon(Icons.delete)),
                                      IconButton(onPressed: (){
                                        _name.text = contact.name!;
                                        _number.text = contact.number!;
                                        showModalBox(contact.id);
                                      }, icon: const Icon(Icons.edit)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ]),
            );
          }
        }
        //return loadingView();
        return Container(
          child: Image.asset('images/default_contact.png'),
        );
      },
    );
  }
}
