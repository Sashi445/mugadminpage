import 'package:flutter/material.dart';
import 'package:mugadminpage/services/firebase_auth_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mugadminpage/services/firebase_firestore_services.dart';
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
          appBarTheme: AppBarTheme(
            elevation: 0,
          ),
          accentColor: Color(0xffffcc),
          primarySwatch: Colors.amber,
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
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthServices>(
            create: (context) => FirebaseAuthServices()),
        Provider<FirestoreServices>(create: (context) => FirestoreServices())
      ],
      child: LandingPage(),
    );
  }
}
