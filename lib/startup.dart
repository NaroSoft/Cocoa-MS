import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocoa_system/Screens/components/login_page.dart';
import 'package:cocoa_system/Screens/home/home_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'Screens/byers/buy_home_screen.dart';
import 'Screens/components/common/custom_input_field.dart';
import 'Screens/components/common/page_header.dart';
import 'Screens/components/common/page_heading.dart';
import 'Screens/components/forget_password_page.dart';
import 'Screens/components/signup_page.dart';



class StartUp extends StatefulWidget {
  const StartUp({Key key}) : super(key: key);

  @override
  State<StartUp> createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {
  //
  final _loginFormKey = GlobalKey<FormState>();

    bool _isLoading = false;
    TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

    
      void _openDialog(String msg) {
     showCupertinoDialog(
         context: context,
         builder: (_) => CupertinoAlertDialog(
           title: Text("Error Message",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,color: Colors.red),),
           content:   Card(
             color: Colors.transparent,
             elevation: 0.0,
             child: Column(
               children: <Widget>[
                 SizedBox(
                   height: 2.0,
                   child: new Center(
                     child: new Container(
                       margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                       height: 2.0,
                       color: Colors.black87,
                     ),
                   ),
                 ),

                 SizedBox(height: 15.0,),
                Text(errorMessage)

               ],
             ),
           ),

           actions: [
             // Close the dialog
             // You can use the CupertinoDialogAction widget instead
             CupertinoButton(
                 child: Text('Ok',style: TextStyle(color: Colors.red),),
                 onPressed: () {
                   Navigator.of(context).pop();
                   setState(() {
                     errorMessage="";
                   });
                 }),

           ],
         ));
      }


      String errorMessage; 


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffEEF1F3),
          body: Column(
            children: [
              //const PageHeader(),

               Center(
        child: SizedBox(
          height: 400.0,
          width: MediaQuery.of(context).size.width,
          child: Carousel(
            images: [
              ExactAssetImage("assets/images/cocoa.jpg"),
              ExactAssetImage("assets/images/login_img.jpg"),
              ExactAssetImage("assets/images/cocoa1.jpg"),
              ExactAssetImage("assets/images/cocoa2.jpg"),
              ExactAssetImage("assets/images/cocoa3.jpg"),
            ],
            autoplay: true,
            animationDuration: Duration(milliseconds: 800),
            dotSize: 10.0,
            dotSpacing: 30.0,
            dotColor: Color.fromARGB(255, 238, 181, 148),
            //borderRadius: true,
          ),
        ),
      ),

              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 236, 207, 197),
                    //borderRadius: BorderRadius.vertical(top: Radius.circular(20),),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [

                          SizedBox(height: 10,),
                          Padding(
                            padding: EdgeInsets.only(left:10),
                          child: Text(
                            'Welcome',
                            style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NotoSerif'
                            ),
                          ),
                          ),
                          SizedBox(height: 10,),
                          
                         Padding(
                          padding: EdgeInsets.only(left: 25, right: 25),
                          child: Text('To SmartCo Online Shopping for Farmers. Best platform to Sell and Buy.',style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 128, 115, 115),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NotoSerif'
                            ),
                            ),
                         ),    
                      

                          const SizedBox(height: 20,),
                          
                          
                          Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          //color: const Color(0xff233743),
                          color: Color.fromARGB(255, 83, 49, 38),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: TextButton(
                          onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);
  
                          },
                           child:Text("Get Started",style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),

                          
                        
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  void _handleLoginUser() {
    // login user
    if (_loginFormKey.currentState.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitting data..')),
      );
    }
  }
}
