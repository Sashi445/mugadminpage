import 'package:flutter/material.dart';
import 'package:mugadminpage/services/firebase_auth_services.dart';
import 'package:mugadminpage/views/home_page.dart';
import 'package:mugadminpage/views/sign_in_page.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseAuthServices =
        Provider.of<FirebaseAuthServices>(context, listen: false);

    return StreamBuilder(
      stream: firebaseAuthServices.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.active){
          print(snapshot.hasData);
          print(snapshot.data);
            if(snapshot.hasData && snapshot.data!=null){
              return HomePage();
            }else{
              return SignInPage();
            }
        }else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(snapshot.connectionState.toString()),
                CircularProgressIndicator()
              ],
            ),
          );
        }
      },
    );
  }
}
