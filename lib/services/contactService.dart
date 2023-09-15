import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact/models/contactModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactService {
  List<ContactModel> _contactListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return ContactModel(
        id: doc.id,
        name: doc.data()['name'] ?? '',
        number: doc.data()['number'] ?? '',
      );
    }).toList();
  }


  Future saveContact(name,number) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('contacts')
        .add({
      'id': "",
      'name': name,
      'number': number,
    }).then((DocumentReference doc){
      print('My Document Id is ${doc.id}');
      getDocId(doc.id);
    });
  }

  Future getDocId(cid) async{
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('contacts')
        .doc(cid)
        .update({
      'id' : cid
    });
  }

  Stream<List<ContactModel>> getContactByUser(uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('contacts')
        .orderBy("name",descending: false)
        .snapshots()
        .map(_contactListFromSnapshot);
  }
}