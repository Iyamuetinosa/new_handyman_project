import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:handyman/Services/auth_service.dart';
import 'package:handyman/main.dart';
import 'dart:io' show Platform;


import 'package:international_phone_input/international_phone_input.dart';

import '../configMaps.dart';


final primaryColor = const Color(0xFF75A2EA);

enum AuthFormType{signIn, signUp, reset, phone}




class SignUpView extends StatefulWidget {
  final AuthFormType authFormType;
   SignUpView({Key key, @required this.authFormType}) : super(key: key);
  @override
  _SignUpViewState createState() => _SignUpViewState(authFormType: this.authFormType);
}




class _SignUpViewState extends State<SignUpView> {

  AuthFormType authFormType;
  _SignUpViewState({this.authFormType});

  final formKey = GlobalKey<FormState>();
  String phoneIsoCode;
  String _email, _password, _firstName, _lastName, _rePassword, _warning, _phone, token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSPToken();
  }


  void switchFormState(String state)
  {
    formKey.currentState.reset();
    if(state == "signUp")
    {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    }
    else
    {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  bool validate()
  {
    final form = formKey.currentState;
    form.save();
    if(form.validate())
    {
      form.save();
      return true;
    }else{
      return false;
    }
  }



//submit method
  void submit() async
  {

    if (validate()) {
      try {
        final auth = Provider.of(context).auth;

        switch (authFormType)
        {
          case AuthFormType.signIn:
            await auth.signInWithEmailAndPassword(_email, _password);
            Navigator.of(context).pushReplacementNamed('/SelectActivityScreen');

            break;
          case AuthFormType.signUp:
            if (_password != _rePassword) {
              buildShowToast("Password miss-match.");
            }
            else
            {
              String uid = await auth.createUserWithEmailAndPassword(
                  _email, _password, _firstName, _lastName);
              Map userDataMap = {
                "firstName": _firstName,
                "lastName": _lastName,
                "email": _email,
                "phone": "",
                "Address": "",
                "profilePic": "",
                "token": token,
              };
              usersRef.child(uid).set(userDataMap);
              buildShowToast("Registration Complete, Congratulations.");
              Navigator.of(context).pushReplacementNamed('/SelectActivityScreen');
              // getSPToken();
            }
            break;
          case AuthFormType.reset:
            await auth.sendPassWordResetEmail(_email);
            print("Password reset email sent");
            _warning = "A re-set password link has been sent to $_email";
            setState(() {
              authFormType = AuthFormType.signIn;
            });
            break;
          case AuthFormType.phone:
            var result = await auth.createUserWithPhone(_phone, context);
            if(_phone == ""||_phone== null || result == "error")
            {
              setState(() {
                _warning = "Please Enter a valid Phone number that Matches your country code you picked";
              });
            }
            // String uid = await auth.signInWithEmailAndPassword(_email, _password);
            // Navigator.of(context).pushReplacementNamed('/SelectActivityScreen');
            break;
        }

      }
      catch (e) {
        setState(() {
          print(e);
          _warning = e.message;
        });

      }
    }
  }

  //main Scaffold
  @override
  Widget build(BuildContext context)
  {
    final _height = MediaQuery.of(context).size.height;
    final _width= MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: buildHeaderText(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: primaryColor,
          height: _height,
          width: _width,
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: _height * 0.01),
                showAlert(),
                SizedBox(height: _height * 0.01),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: buildInputs() +buildButtons(),
                    ),
                  ),
                ),



              ],),
          ),

        ),
      ),
    );
  }

  AutoSizeText buildHeaderText()
  {
    String _headerText;
    if(authFormType == AuthFormType.signUp)
    {
      _headerText = "Create New Account";
    }
    else if(authFormType == AuthFormType.reset)
    {
      _headerText = "Reset Password";
    }
    else if(authFormType == AuthFormType.phone)
    {
      _headerText = "Phone Sign In";
    }
    else
    {
      _headerText = "Sign In";
    }
    return AutoSizeText(
              _headerText,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30,
              color: Colors.white
              ),
            );
  }


  List<Widget> buildInputs()
  {

    List<Widget> textFields = [];
    //if were in the sign up state add name

    //adding textFields
    if(authFormType == AuthFormType.reset)
    {
      textFields.add(
        TextFormField(
          style: TextStyle(fontSize: 22.0),
          validator: EmailValidator.validate,
          keyboardType: TextInputType.emailAddress,
          decoration: buildSignUpInputDecoration("Email"),
          onSaved: (value) => _email = value,
        ),
      );
      textFields.add(SizedBox(height: 15.0,));
      return textFields;
    }

    if(authFormType == AuthFormType.phone)
    {
      // String languageCode = Platform.localeName.split('_')[0];
      // String countryCode = Platform.localeName.split('_')[1];
      // String myLocale = Localizations.localeOf(context).toString();
      // print (Text("phone location: $languageCode"));
      // print (Text("phone location2: $countryCode"));
      // final Locale deviceLocale = CountryCodes.getDeviceLocale();
      // print(deviceLocale.languageCode); // Displays en
      // print(deviceLocale.countryCode); // Displays US

      textFields.add(
        // TextFormField(
        //   style: TextStyle(fontSize: 22.0),
        //   validator: PhoneNumberValidator.validate,
        //   keyboardType: TextInputType.phone,
        //   decoration: buildSignUpInputDecoration("Phone Number"),
        //   onSaved: (value) => _phone = value,
        // ),

          InternationalPhoneInput(
              decoration: buildSignUpInputDecoration("Phone Number"),
              onPhoneNumberChange: onPhoneNumberChange,
              initialPhoneNumber: _phone,
              initialSelection: "NG",
              // enabledCountries: ['+233', '+1'],
              showCountryCodes: false
          ),
      );
      textFields.add(SizedBox(height: 15.0,));
      return textFields;
    }



    if(authFormType == AuthFormType.signUp)
    {
      textFields.add(
        TextFormField(
          style: TextStyle(fontSize: 22.0),
          validator: FirstNameValidator.validate,
          decoration: buildSignUpInputDecoration("First Name"),
          onSaved: (value) => _firstName = value,
        ),
      );

      textFields.add(SizedBox(height: 15.0,));

      textFields.add(
        TextFormField(
          style: TextStyle(fontSize: 22.0),
          validator: LastNAmeValidator.validate,
          decoration: buildSignUpInputDecoration("Last Name"),
          onSaved: (value) => _lastName = value,
        ),
      );
      textFields.add(SizedBox(height: 15.0,));
    }

    //add email & password
    textFields.add(
      TextFormField(
        style: TextStyle(fontSize: 22.0),
        validator: EmailValidator.validate,
        keyboardType: TextInputType.emailAddress,
        decoration: buildSignUpInputDecoration("Email"),
        onSaved: (value) => _email = value,
      ),
    );

    textFields.add(SizedBox(height: 15.0,));

    textFields.add(
      TextFormField(
        style: TextStyle(fontSize: 22.0),
        validator: PasswordValidator.validate,
        decoration: buildSignUpInputDecoration("Password"),
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    );
    textFields.add(SizedBox(height: 15.0,));

    if(authFormType == AuthFormType.signUp)
    {
      textFields.add(
        TextFormField(
          style: TextStyle(fontSize: 22.0),
          validator: RePasswordValidator.validate,
          decoration: buildSignUpInputDecoration("Re-Enter Password"),
          obscureText: true,
          onSaved: (value) => _rePassword = value,
        ),
      );
      textFields.add(SizedBox(height: 15.0,));
    }

    return textFields;
  }

  InputDecoration buildSignUpInputDecoration(String hint)
  {
    return InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 0.0)),
        contentPadding: const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
      );
  }

  List<Widget> buildButtons()
  {
    String _switchButtonText, _newFormState, _submitButtonText;
    bool _showForgotPassword = false;
    bool _showSocial = true;

    if(authFormType == AuthFormType.signIn)
    {
      _switchButtonText = "Create New Account";
      _newFormState = "signUp";
      _submitButtonText = "Sign In";
      _showForgotPassword = true;

    }
    else if(authFormType == AuthFormType.reset)
    {
      _switchButtonText = "Return to Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Submit";
      _showSocial = false;
    }
    else if(authFormType == AuthFormType.phone)
    {
      _switchButtonText = "Return to Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Submit";
      _showSocial = false;
    }
    else
    {
      _switchButtonText = "Already have an Account? Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Sign Up";
      _showSocial = false;
    }

    return [

      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: ElevatedButton(onPressed: submit,
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _submitButtonText, style: TextStyle(fontSize: 20.0, color: primaryColor),
            ),
          ),
        ),
      ),


      showForgotPassword(_showForgotPassword),

      TextButton(
          onPressed: ()
          {
            switchFormState(_newFormState);
          },
          child: Text(_switchButtonText, style: TextStyle(fontSize: 15.0, color: Colors.white),),
      ),

      buildSocialIcons(_showSocial),
    ];
  }

  Widget showForgotPassword(bool visible)
  {
    return Visibility(
      child: TextButton(onPressed: ()
      {
        setState(() {
          authFormType = AuthFormType.reset;
        });
      },
          child: Text("Forgot Password?",
            style: TextStyle(color: Colors.white), )
      ),
      visible: visible,
    );
  }



  Future<String> getSPToken() async
  {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    token = await firebaseMessaging.getToken();
    print("this is your token::");
    print(token);
    // usersRef.child(firebaseUser.uid).child("token").set(token);

    firebaseMessaging.subscribeToTopic("serviceproviders");
    firebaseMessaging.subscribeToTopic("servicerequests");
    // return token;
  }


  Future<bool> buildShowToast(String message)
  {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }

  Widget showAlert()
  {
    if(_warning !=null)
    {
      // buildShowToast(_warning);
      return Container(
        color: Colors.red,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(child: AutoSizeText(_warning, maxLines: 3,)),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: IconButton(onPressed: ()
              {
                setState(() {
                  _warning = null;
                });
              },
                  icon: Icon(Icons.close)),
            )

          ],
        ),
      );
    }
    return SizedBox(height: 8.0,);
  }

  //social media buttons
  Widget buildSocialIcons(bool visible)
  {
    final _auth = Provider.of(context).auth;
    return Visibility(
      child: Column(
        children: [
          Divider(color: Colors.white),
          SizedBox(height: 10,),
          GoogleSignInButton(
            onPressed: () async
            {
              try
              {
                await _auth.signInWithGoogle();
                Navigator.of(context).pushReplacementNamed('/SelectActivityScreen');
              }
              catch(e)
              {
                print (e);
                setState(() {
                  _warning = e.message;
                });
              }
            },
          ),

          Container(
            width: 220.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                textStyle: TextStyle(color: Colors.white),
                  ),
                child: Row(
                  children: [
                    Icon(Icons.phone),
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0, top: 10.0, bottom: 10.0),
                      child: Text("Sign In with Phone", style: TextStyle(fontSize: 18.0),),
                    )
                  ],
                ),
                onPressed: ()
                {
                  setState(() {
                    authFormType = AuthFormType.phone;
                  });
                }
            ),
          )
        ],
      ),
      visible: visible,
    );
  }

  void onPhoneNumberChange(String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      _phone = internationalizedPhoneNumber;
      phoneIsoCode = isoCode;
      print(internationalizedPhoneNumber);
    });

  }
}


