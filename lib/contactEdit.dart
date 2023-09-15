import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactEditor extends StatefulWidget {
  ContactEditor(this.doc, this.uid, this.cid, {Key? key}) : super(key: key);
  DocumentSnapshot doc;
  String uid;
  String? cid;

  @override
  _ContactEditorState createState() => _ContactEditorState();
}

class _ContactEditorState extends State<ContactEditor> {
  TextEditingController _name = TextEditingController();
  TextEditingController _number = TextEditingController();

  @override
  void initState() {
    _name = TextEditingController(text: widget.doc["name"]);
    _number = TextEditingController(text: widget.doc["number"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF5E4),
      appBar: AppBar(
        title: const Text(
          "Contact",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          ElevatedButton(
              style:
              ElevatedButton.styleFrom(primary: Color(0xFFFF9494)),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.uid)
                    .collection("contacts")
                    .doc(widget.cid)
                    .delete()
                    .then((value) {
                  print("Success");
                  Navigator.pop(context);
                }).catchError((error) => print("Failed cuz ${error}"));
              },
              child: Icon(Icons.delete))
        ],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _name,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Name",
              ),
              keyboardType: TextInputType.name,
            ),
            TextFormField(
              controller: _number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Number",
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFF9494),
        onPressed: () async {
          print("hello" + widget.doc.toString());
          await FirebaseFirestore.instance
              .collection("users")
              .doc(widget.uid)
              .collection("contacts")
              .doc(widget.cid)
              .update({
            'number': _number.text,
            'name': _name.text,
          }).then((value) {
            print("Success");
            Navigator.pop(context);
          }).catchError((error) => print("Failed cuz ${error}"));
        },
        child: Icon(Icons.save, color: Colors.black),
      ),
    );
  }
}