import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:handyman/AllScreens/serviceSelectionScreen.dart';

class CustomDialog extends StatelessWidget
{
  final String title, description, primaryButtonText, primaryButtonRoute, secondaryButtonText, secondaryButtonRoute;
  bool serviceProvider;


  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.primaryButtonText,
    @required this.primaryButtonRoute,
    this.secondaryButtonText,
    this.secondaryButtonRoute,
    this.serviceProvider
  });
  static const double padding = 20.0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding)),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                )
              ]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 24.0,),
                AutoSizeText(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(height: 24.0,),
                AutoSizeText(
                  description,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18.0,
                  ),
                ),

                SizedBox(height: 24.0,),
                ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        // side: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  child: AutoSizeText(
                    primaryButtonText,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Brand Bold",
                      color: Colors.white
                    ),
                  ),

                  onPressed: ()
                  {
                    if(serviceProvider != null)
                    {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceSelectionScreen(serviceProvider:serviceProvider)));


                    }
                    else
                    {

                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed(primaryButtonRoute);
                    }
                  },
                ),
                SizedBox(height: 10.0,),
                showSecondaryButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

   showSecondaryButton(BuildContext context) {
    if(secondaryButtonRoute != null && secondaryButtonText != null)
    {
      return TextButton(
        child: AutoSizeText(
          secondaryButtonText,
          maxLines: 1,
          style: TextStyle(
            fontSize: 18,
            color: Colors.blue,
            fontFamily: "Brand Bold",
          ),
        ),
        onPressed: ()
        {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(secondaryButtonRoute);
        },
      );
    }else
      {
        return SizedBox(height: 10.0,);
      }

  }
}
