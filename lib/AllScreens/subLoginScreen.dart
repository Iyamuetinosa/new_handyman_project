import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:handyman/widgets/custom_dialog.dart';

class SubLoginScreen extends StatelessWidget {
  // const SubLoginScreen({Key? key}) : super(key: key);
  static const String idScreen = "subLogin";
  final primaryColor = const Color(0xFF75A2EA);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: _width,
          height: _height,
          color: primaryColor,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  SizedBox(height: _height * 0.05),
                  Text(
                    "Welcome",
                    style: TextStyle(fontSize: 44, color: Colors.white),
                  ),
                  SizedBox(height: _height * 0.02,),
                  Image(
                    image: AssetImage("images/logo.png"),
                    width: 200.0,
                    height: 200.0,
                    alignment: Alignment.center,
                  ),


                  SizedBox(height: _height * 0.02),

                  AutoSizeText(
                    "Let's find you a Handyman",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: _height * 0.02),
                  ElevatedButton(onPressed: ()
                  {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomDialog(
                            title: "Welcome",
                            description: "With an account, you data will be secure, allowing you to enjoy quality Handyman services",
                            primaryButtonText: "Create My Account",
                            primaryButtonRoute: "/signUp",
                            secondaryButtonText: "Maybe Later",
                            secondaryButtonRoute: "/back",
                        ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Get Started", style: TextStyle(fontSize: 20.0, color: primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(height: _height * 0.02),
                  TextButton(onPressed: ()
                  {
                    Navigator.of(context).pushReplacementNamed("/signIn");
                  },
                      child: Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 28.0),),)

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
