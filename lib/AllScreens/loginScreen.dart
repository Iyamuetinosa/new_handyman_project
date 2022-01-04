import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handyman/AllScreens/otpScreen.dart';
import 'package:handyman/AllScreens/selectActivityScreen.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget
{
  // LoginScreen({Key key}):super(key: key);
  static const String idScreen = "login";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen>
{
  @override




  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final _controller = TextEditingController();




    return Scaffold(
      backgroundColor: Colors.white60,
      body: SingleChildScrollView(
        child: Container(
          width: _width,
          height: _height,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: _height * 0.08,),
                Image(
                  image: AssetImage("images/logo.png"),
                  width: 250.0,
                  height: 250.0,
                  alignment: Alignment.center,
                ),

                SizedBox(height: _height * 0.03,),
                AutoSizeText(
                  "Login using your mobile phone number",
                  style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold", color: Colors.white),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),

                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(height: _height * 0.02,),

                      // TextField(
                      //   controller: _controller,
                      //   keyboardType: TextInputType.number,
                      //   decoration: InputDecoration(
                      //     labelText: "phone number",
                      //     labelStyle: TextStyle(
                      //       fontSize: 14.0,
                      //     ),
                      //     hintStyle: TextStyle(
                      //       color: Colors.grey[100],
                      //       fontSize: 10.0,
                      //     ),
                      //   ),
                      //   style: TextStyle(fontSize: 14.0),
                      // ),
                      InternationalPhoneInput(
                          decoration: buildInputDecoration("8012345678"),
                          onPhoneNumberChange: onPhoneNumberChange,
                          initialPhoneNumber: "",
                          initialSelection: 'US',
                          showCountryCodes: true,
                      ),

                      SizedBox(height: _height * 0.02,),

                      
                      ElevatedButton(
                          child: Container(
                            // color: Colors.yellow,
                            // height: 50.0,
                            child: Center(
                              child: Text(
                                "Submit",
                                style: TextStyle(fontSize: 25.0, fontFamily: "Brand Bold"),
                              ),
                            ),
                          ),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  // side: BorderSide(color: Colors.red),
                                ),
                              ),
                          ),


                        onPressed: ()
                        {

                          if(_phoneNumber == "")
                          {
                            buildShowToast("Please enter a valid phone number");
                          }
                          else if(_phoneNumber== null)
                        {
                          buildShowToast("Please this field cannot be empty");
                        }
                        else
                        {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OtpScreen(_phoneNumber)));
                          // Navigator.pushNamedAndRemoveUntil(context, OtpScreen.idScreen, (route) => false);
                          // registerNewUser(context);
                        }

                        },
                      )
                    ],
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> buildShowToast(String message) {
    return Fluttertoast.showToast(
                          msg: message,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 20.0,
                        );
  }

  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //
  //
  // void registerNewUser(BuildContext context) async
  // {
  //   _firebaseAuth.verifyPhoneNumber(
  //       phoneNumber: _phoneNumber,
  //       verificationCompleted: (PhoneAuthCredential credential)
  //       {
  //         // _firebaseAuth.signInWithCredential(credential).then((user) async=>
  //         // {
  //         //   if(user != null)
  //         //   {
  //         //     await _firestore
  //         //   }
  //         //   else
  //         //   {
  //         //     buildShowToast("User registration failed",);
  //         //   }
  //         // });
  //       },
  //       verificationFailed: (FirebaseAuthException e)
  //       {
  //         return ("Error");
  //       },
  //       codeSent: (String verificationId, int resendToken) {},
  //       timeout: Duration(seconds: 10),);
  //   print("the phone number entered is $_phoneNumber");
  // }



  String _phoneNumber;

  void onPhoneNumberChange(String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      _phoneNumber = internationalizedPhoneNumber;
      print(_phoneNumber);

      // phoneIsoCode = isoCode;
    });
  }

  InputDecoration buildInputDecoration(String hint) {
    return InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 0.0)),
                          contentPadding: const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
                          hintText: hint,
                          hintStyle: TextStyle(color: Colors.grey[200]),
                        );
  }


}
