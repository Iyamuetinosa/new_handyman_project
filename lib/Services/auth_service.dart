

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:handyman/main.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<String> get onAuthStateChanged =>
      _firebaseAuth.authStateChanges().map(
            (User user) => user?.uid,
      );

  // Email & Password Sign Up

  Future<String> createUserWithEmailAndPassword(String email, String password,
      String firstName, String lastName) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _firebaseAuth.currentUser.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return "Error occurred";
    }

    // await FirebaseAuth.instance.currentUser.updateProfile(
    //     displayName: firstName + " " + lastName);
    // await FirebaseAuth.instance.currentUser.reload();
    // return FirebaseAuth.instance.currentUser.uid;


    // final currentUser = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    // var userUpdateInfo = currentUser.user.updateProfile(displayName: firstName + " " + lastName);
    // // userUpdateInfo.displayName = firstName + " " + lastName;
    // // await currentUser.updateProfile(userUpdateInfo);
    // await currentUser.user.reload();
    // return currentUser.user.uid;
  }

  //Update the Username
  Future updateUserName(String firstname, String lastName, User currentUser) async
  {
    await currentUser.updateProfile(displayName: firstname + " "+ lastName);
    await currentUser.reload();
  }

  //Creating User with Phone
  Future createUserWithPhone(String phone, BuildContext context) async
  {
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 0),
        verificationCompleted: (AuthCredential authCredential)
        {
          _firebaseAuth.signInWithCredential(authCredential).then((UserCredential result)
          {
            Navigator.of(context).pushReplacementNamed('/SelectActivityScreen');
          }).catchError((e)
          {
            return "error";
          });
        },
        verificationFailed: (FirebaseAuthException exception)
        {
          return "error";
        },
        codeSent: (String verificationId, [int forceResendingToken])
        {
          final _codeController = TextEditingController();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: Text("Enter Verification Code here"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: _codeController)
                  ],
                ),
                actions: [
                    ElevatedButton(onPressed:()
                    {
                      var _credential = PhoneAuthProvider.credential(
                          verificationId: verificationId,
                          smsCode: _codeController.text.trim()
                      );
                      _firebaseAuth.signInWithCredential(_credential).then((UserCredential result)
                      async {
                        FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
                        String token = await firebaseMessaging.getToken();
                        final String uid = _firebaseAuth.currentUser.uid;
                        Map userDataMap = {
                          "firstName": "",
                          "lastName": "",
                          "email": "",
                          "phone": phone,
                          "address": "",
                          "profilePic": "",
                          "token": token,
                        };
                        usersRef.child(uid).set(userDataMap);

                        Navigator.of(context).pushReplacementNamed('/SelectActivityScreen');
                      }).catchError((e)
                      {
                        return "error";
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "submit", style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  ),

                ],
              )
          );
        },
        codeAutoRetrievalTimeout: (String verificationId)
        {
          verificationId = verificationId;
          print(verificationId);
          print("Timeout");
        }
    );
  }

  // Email & Password Sign In
  Future<String> signInWithEmailAndPassword(String email,
      String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)).user.uid;
  }

  // Sign Out
  signOut() {
    return _firebaseAuth.signOut();
  }


  //Reset Password
  Future sendPassWordResetEmail(String email) async
  {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  //GET UID
  Future<String>getCurrentUID()async
  {
    return (_firebaseAuth.currentUser).uid;
  }

  //sign in with google
  Future<String> signInWithGoogle() async
  {
    final GoogleSignInAccount account= await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: _googleAuth.idToken,
        accessToken: _googleAuth.accessToken
    );



    // Navigator.of(context).pushReplacementNamed('/SelectActivityScreen');
    return(await _firebaseAuth.signInWithCredential(credential)).user.uid;


  }



  Future<bool> buildShowToast(String message) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }
}

class EmailValidator
{
  static String validate(String value)
  {
    if(value.isEmpty)
    {
      return "Please enter an email";
    }
    if(!value.contains("@") || !value.contains("."))
    {
      return "Please enter a valid email";
    }
    return null;
  }
}

class FirstNameValidator
{
  static String validate(String value)
  {
    if(value.isEmpty)
    {
      return "Please enter your first name...";
    }
    if(value.length<2)
    {
      return "name must be atleast 2 characters long";
    }
    if(value.length>20)
    {
      return "name must be not be more than 20 characters long";
    }

    return null;
  }
}

class LastNAmeValidator
{
  static String validate(String value)
  {
    if(value.isEmpty)
    {
      return "Please enter your last name...";
    }
    if(value.length<2)
    {
      return "name must be atleast 2 characters long";
    }
    if(value.length>20)
    {
      return "name must be not be more than 20 characters long";
    }
    return null;
  }
}
class PasswordValidator
{
  static String validate(String value)
  {
    if(value.isEmpty)
    {
      return "Please enter a password";
    }
    return null;
  }
}

class RePasswordValidator
{
  static String validate(String value)
  {
    if(value.isEmpty)
    {
      return "Please confirm your password";
    }
    return null;
  }
}

class PhoneNumberValidator
{
  static String validate(String value)
  {
    if(value.isEmpty)
    {
      return "Please Enter your phone";
    }
    return null;
  }
}


