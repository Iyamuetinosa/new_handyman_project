import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handyman/AllScreens/selectActivityScreen.dart';
import 'package:handyman/main.dart';
import 'package:handyman/widgets/progressDialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OtpScreen extends StatefulWidget

{

  // static const String idScreen = "otpScreen";
  final String phone;
  OtpScreen(this.phone);
  @override
  _OtpScreenState createState() => _OtpScreenState();
}
class _OtpScreenState extends State<OtpScreen> {

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  String _verificationCode;

  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery
        .of(context)
        .size
        .width;
    final _height = MediaQuery
        .of(context)
        .size
        .height;
    // final _controller = TextEditingController();




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
                  "Please Enter the verification number received for ${widget.phone}",
                  style: TextStyle(fontSize: 24.0,
                      fontFamily: "Brand Bold",
                      color: Colors.white),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),

                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(height: _height * 0.02,),

                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: PinPut(
                            fieldsCount: 6,
                            withCursor: true,
                            textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
                            eachFieldWidth: 40.0,
                            eachFieldHeight: 55.0,
                            focusNode: _pinPutFocusNode,
                            controller: _pinPutController,
                            submittedFieldDecoration: pinPutDecoration,
                            selectedFieldDecoration: pinPutDecoration,
                            followingFieldDecoration: pinPutDecoration,
                            pinAnimationType: PinAnimationType.fade,
                            onSubmit: (pin) async {

                              // showDialog(
                              //     context: context,
                              //     barrierDismissible: false,
                              //     builder: (BuildContext context)
                              //     {
                              //       return ProgressDialog(message: "Loading");
                              //     }
                              // );


                              try{
                                await FirebaseAuth.instance.signInWithCredential(
                                    PhoneAuthProvider.credential(
                                        verificationId: _verificationCode,
                                        smsCode: pin)).then((value) async
                                {
                                  // Navigator.pop(context);
                                  if(value.user!=null)
                                  {
                                    Map userDataMap = {
                                      "phone": widget.phone,

                                    };
                                    // Navigator.pop(context);

                                    usersRef.child(value.user.uid).set(userDataMap);
                                    buildShowToast("Welcome...");
                                    Navigator.pushNamedAndRemoveUntil(context, SelectActivityScreen.idScreen, (route) => false);
                                  }
                                 });
                                }catch(e){
                                FocusScope.of(context).unfocus();
                                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Invalid OTP')));
                                // Navigator.pop(context);
                              }


                            },
                          ),
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



  _verifyPhone()async{



    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phone,
        verificationCompleted: (PhoneAuthCredential credential)async
        {
          await FirebaseAuth.instance.signInWithCredential(credential)
              .then((value) async{
                if(value.user!=null)
                {
                  Map userDataMap = {
                    "phone": widget.phone,
                  };

                  usersRef.child(value.user.uid).set(userDataMap);
                  buildShowToast("Welcome...");

                  Navigator.pushNamedAndRemoveUntil(context, SelectActivityScreen.idScreen, (route) => false);
                  // Navigator.pop(context);
                }
                else
                {
                  buildShowToast("Login failed");
                  // Navigator.pop(context);
                }
          });
        },
        verificationFailed: (FirebaseAuthException e)
        {
          print(e.message);
          // Navigator.pop(context);
        },
        codeSent:(String verificationID, int resendToken)
        {
          setState(() {
            _verificationCode =verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID)
        {
          setState(() {
            _verificationCode = verificationID;
          });
        }, timeout: Duration(seconds: 60));
  }




@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }



}
