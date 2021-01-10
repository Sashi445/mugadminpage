import 'package:flutter/material.dart';
import 'package:mugadminpage/services/firebase_auth_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mugadminpage/views/landing_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Something went wrong'),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                return Wrapper();
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseAuthServices>(
        create: (context) => FirebaseAuthServices(), child: LandingPage());
  }
}
