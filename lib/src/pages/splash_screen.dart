import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:google_maps_rule/src/pages/Gmaps_page.dart';
class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
            height: MediaQuery.of(context).size.height/3,
            width: MediaQuery.of(context).size.height/3,
     // color: Colors.green,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/dash_maps.png'))
      ),
    ),
    SizedBox(
      height: 30,
    ),
    Text('Area and rule in Google Maps',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
            ],
          ),
        ));
  }

  @override
  void afterFirstLayout(BuildContext context) {
     Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return GmapsPage();
      }));
    });
  }
}