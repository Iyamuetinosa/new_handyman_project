import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handyman/Services/assistantMethods.dart';

class CollectFareDialog extends StatelessWidget {
  // const ({Key key}) : super(key: key);

  final String paymentMethod;
  final int fareAmount;

  CollectFareDialog({this.paymentMethod, this.fareAmount});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(12.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 22.0,),

            Text("Trip Fare"),

            SizedBox(height: 22.0,),

            Divider(),
            SizedBox(height: 16.0,),
            Text("\$$fareAmount", style: TextStyle(fontSize: 10.0, fontFamily: "Brand-Bold"),),
            SizedBox(height: 16.0,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text("Amount due, charged to the client.", textAlign: TextAlign.center,),
            ),
            SizedBox(height: 30.0,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Collect Cash",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Brand Bold",
                              color: Colors.white
                          )
                      ),
                      Icon(Icons.payment_sharp, color: Colors.white,size: 26.0,)
                    ],
                  ),

                  onPressed: ()
                   {
                     Navigator.pop(context);
                     Navigator.pop(context);

                     AssistantMethods.enableServiceLiveLocationUpdate();
                   }
              ),
            ),

            SizedBox(height: 30.0,),

          ],
        ),
      ),
    );
  }

}
