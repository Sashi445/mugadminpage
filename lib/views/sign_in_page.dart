import 'package:flutter/material.dart';
import 'package:mugadminpage/services/firebase_auth_services.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  
  final _formKey = GlobalKey<FormState>();

  var errorMessage = '';

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final firebaseAuthServices = Provider.of<FirebaseAuthServices>(context);

    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(17),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width / 4,
              decoration: BoxDecoration(
                color: Colors.amber
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('ADMIN PAGE'),
                    TextFormField(
                      autofocus: true,
                      controller: _emailController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email), labelText: 'Email'),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'This field is required!!';
                        } else {
                          return '';
                        }
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock), labelText: 'Password'),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'This field is required!!';
                        } else {
                          return '';
                        }
                      },
                    ),
                    Text(errorMessage, style: TextStyle(color: Colors.red)),
                    RaisedButton(
                      child: Text('SignIn'),
                      onPressed: () async {
                        var res = await firebaseAuthServices
                            .signInWithEmailandPassword(
                                email: _emailController.text,
                                password: _passwordController.text);
                        if (res == 'password-incorrect') {
                          setState(() {
                            errorMessage = res;
                          });
                        } else if (res == 'User not registered') {
                          setState(() {
                            errorMessage = res;
                          });
                        }
                      },
                    )
                  ],
                ),
              )),
        ));
  }
}
