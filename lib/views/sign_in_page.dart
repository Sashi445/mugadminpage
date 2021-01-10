import 'package:flutter/material.dart';
import 'package:mugadminpage/services/firebase_auth_services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuthServices = Provider.of<FirebaseAuthServices>(context);

    return Scaffold(
      //appBar: AppBar(),
      body: Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.yellow,
                  child: Image.network(
                    'https://images.theconversation.com/files/222785/original/file-20180612-112602-1n6vzvh.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=926&fit=clip',
                    fit: BoxFit.fill,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'S',
                          style: GoogleFonts.droidSerif(
                              color: Colors.blue[900], fontSize: 40,fontWeight: FontWeight.w500)),
                      TextSpan(
                          text: 'ERV UDYAM',
                          style: GoogleFonts.droidSerif(
                              color: Colors.black, fontSize: 30)),
                    ])),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.5,
            color: Colors.amber,
            child: Center(
              child: Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          color: Colors.grey,
                          offset: Offset(1, 1),
                        )
                      ]),
                  height: MediaQuery.of(context).size.height * 3 / 4,
                  padding: EdgeInsets.symmetric(vertical: 100, horizontal: 75),
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'LOGIN',
                          style: GoogleFonts.paytoneOne(
                              fontSize: 30, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          autofocus: true,
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              //prefixIcon: Icon(Icons.email),
                              hintText: 'Email'),
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'This field is required!!';
                            } else {
                              return '';
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              hintText: 'Password'),
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'This field is required!!';
                            } else {
                              return '';
                            }
                          },
                        ),
                      ),
                      Text(
                        errorMessage,
                        style: GoogleFonts.roboto(color: Colors.red),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            child: Text('Sign In',style: TextStyle(color: Colors.white,fontSize: 17.5),),
                          ),
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
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
