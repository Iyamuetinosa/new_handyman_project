import 'package:flutter/material.dart';


class  noServiceAvailableDialog extends StatelessWidget {
  // const ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10,),

                Text('Oops!!!', style: TextStyle(fontSize: 22.0, fontFamily: 'Brand-Bold'),),

                SizedBox(height: 25,),

                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Seems the Service providers for this Service are unavailable right now, please try again later', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontFamily: 'Brand-Bold'),),
                ),
                SizedBox(height: 30,),


                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed:()
                    {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).accentColor,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text("Close", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),

                  ),
                ),
              ],
            ),
          ),
        ),

      ),
    );

  }
}
