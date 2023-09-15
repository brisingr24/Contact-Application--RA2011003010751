import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact/models/contactModel.dart';
import 'package:contact/models/userModel.dart';
import 'package:contact/services/contactService.dart';
import 'package:flutter/material.dart';

class ContactDisplay extends StatefulWidget {
  String uid;
  ContactDisplay(this.uid, {Key? key}) : super(key: key);

  State<ContactDisplay> createState() => _ContactDisplayState();
}

class _ContactDisplayState extends State<ContactDisplay> {
  late final Stream<List<ContactModel>> contactModelStream;
  final ContactService _contactService = ContactService();
  late final Stream<UserModel?> userModelStream;
  String text = "";
  var _formkey = GlobalKey<FormState>();
  TextEditingController _name = new TextEditingController();
  TextEditingController _number = new TextEditingController();

  @override
  void initState() {
    contactModelStream = _contactService.getContactByUser(widget.uid);
    super.initState();
  }

  showModalBox(String? cid) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.9,
              color: Colors.grey.shade300,
              child: Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
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
                              errorText: _name.text.isEmpty ? 'Value Cannot be empty' : null,
                          ),
                          keyboardType: TextInputType.name,
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
                            errorText: _number.text.length !=10 ? 'Invalid Phone number' : null,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.blue),
                          onPressed: () async {
                            if(_name.text.isNotEmpty && _number.text.length ==10){
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(widget.uid)
                                  .collection("contacts")
                                  .doc(cid)
                                  .update({
                                'name': _name.text,
                                'number': _number.text,
                              }).then((value) {
                                _name.text = '';
                                _number.text = '';
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: const Text('Update')),
                    ],
                  ),
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
                  height: size.height,
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
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage('images/contact_user.png'),
                                radius: 26,
                              ),
                              title: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${contact.name}',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text('${contact.number}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w300)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                              trailing: PopupMenuButton<MenuItem>(
                                  onSelected: (value) async {
                                    if (value == MenuItem.item1) {
                                      _name.text = contact.name!;
                                      _number.text = contact.number!;
                                      showModalBox(contact.id);
                                    }
                                    if (value == MenuItem.item2) {
                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(widget.uid)
                                          .collection("contacts")
                                          .doc(contact.id)
                                          .delete();
                                    }
                                  },
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: MenuItem.item1,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    _name.text = contact.name!;
                                                    _number.text =
                                                        contact.number!;
                                                    showModalBox(contact.id);
                                                  },
                                                  icon: const Icon(Icons.edit)),
                                              Text('Edit'),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: MenuItem.item2,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("users")
                                                      .doc(widget.uid)
                                                      .collection("contacts")
                                                      .doc(contact.id)
                                                      .delete()
                                                      .then((value) {
                                                    print("Success");
                                                  }).catchError((error) => print(
                                                          "Failed cuz ${error}"));
                                                },
                                                icon: Icon(Icons.delete),
                                              ),
                                              Text('Delete'),
                                            ],
                                          ),
                                        ),
                                      ]),
                            ),
                          ),
                        );
                        // return Container(
                        //   decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.circular(20.0),
                        //       border: Border.all(color: Colors.black)),
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text('${contact.name}'),
                        //         Text('${contact.number}'),
                        //         const SizedBox(height: 20),
                        //         Row(
                        //           children: [
                        //             ElevatedButton(
                        //                 style:
                        //                 ElevatedButton.styleFrom(primary: const Color(0xFFFF9494)),
                        //                 onPressed: () async {
                        //                   await FirebaseFirestore.instance
                        //                       .collection("users")
                        //                       .doc(widget.uid)
                        //                       .collection("contacts")
                        //                       .doc(contact.id)
                        //                       .delete()
                        //                       .then((value) {
                        //                     print("Success");
                        //                   }).catchError((error) => print("Failed cuz ${error}"));
                        //                 },
                        //                 child: const Icon(Icons.delete)),
                        //             IconButton(onPressed: (){
                        //               _name.text = contact.name!;
                        //               _number.text = contact.number!;
                        //               showModalBox(contact.id);
                        //             }, icon: const Icon(Icons.edit)),
                        //           ],
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // );
                      }),
                ),
              ]),
            );
          }
        }
        //return loadingView();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('images/no_user.png',height: 300,width: 300,),
            SizedBox(height: 10,),
            Text('No Contacts Found',style: TextStyle(color:Colors.grey.shade700,fontSize: 20,fontWeight: FontWeight.w300),),
            SizedBox(height: 20,),
            Text('Start Adding!',style: TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.w300),),
          ],
        );
      },
    );
  }
}

enum MenuItem { item1, item2 }
