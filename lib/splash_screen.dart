import 'dart:async';

import 'package:cocoa_system/Screens/weather/pages/home_page.dart';
import 'package:cocoa_system/startup.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  double _progress = 0;

  void startTimer() {
    new Timer.periodic(
      Duration(seconds: 1),
          (Timer timer) =>
         setState ((){if (_progress == 1) {
        timer.cancel();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartUp()),);
      } else {
        _progress += 0.2;
      }
      },
    ));
  }

  @override
  void initState(){
    super.initState();
    setState(() {
      _progress = 0;
    });
    startTimer();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 65, 48, 24),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               
              Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0),
              child: Center(child: Text('SMARTCO', style: TextStyle(color: Colors.white, fontSize: 28.0), textAlign: TextAlign.center)),
              ),
              SizedBox(height: 10.0),
              Image(
                image: AssetImage("assets/images/login_img.jpg"),
                /*color: Colors.blueAccent,
                size: 100.0,*/
              ),
              SizedBox(height: 10.0),
              Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0),
              child: Center(child: Text('ONLINE SHOPPING', style: TextStyle(color: Colors.white, fontSize: 24.0), textAlign: TextAlign.center)),
              ),
              
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 40.0),
              child: CircularProgressIndicator(
                value: _progress,
                strokeWidth: 5,
                backgroundColor: Colors.black,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
