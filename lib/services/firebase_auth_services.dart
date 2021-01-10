import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices{

  final instance = FirebaseAuth.instance;

  Stream<User> get  userStream => instance.authStateChanges();

  Future createUserEmailandPassword() async {
    try {
      UserCredential userCredential =
          await instance.createUserWithEmailAndPassword(
              email: 'master.seud@gmail.com', password: 'initpass');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak password') {
        return 'Password is too weak';
      } else if (e.code == 'email-already-in-use') {
        return 'Account already in use';
      }
      return null;
    } catch (e) {
      throw Exception('Something went wrong $e');
    }
  }

  Future signInWithEmailandPassword({String email, String password}) async {
    try{
      UserCredential userCredential = await instance
      .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    }on FirebaseAuthException catch(e){
      if(e.code == 'wrong-password'){
        return 'password-incorrect';
      }else if(e.code == 'user-not-found'){
        return 'User not registered';
      }
    }
  }

  Future signOutTheSession() async  => instance.signOut();

}
