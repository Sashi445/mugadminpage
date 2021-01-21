import 'package:flutter/material.dart';
import 'package:mugadminpage/services/firebase_firestore_services.dart';

class CreateService extends StatelessWidget {
  
  final FirestoreServices firestoreServices;

  CreateService({this.firestoreServices});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              
            ),
          ],
        ),
      )
    );
  }
}