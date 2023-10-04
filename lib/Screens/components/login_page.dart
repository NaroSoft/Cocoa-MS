import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocoa_system/Screens/admin/admin_home.dart';
import 'package:cocoa_system/Screens/byers/buy_home_screen.dart';
import 'package:cocoa_system/Screens/home/home_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common/custom_form_button.dart';
import 'common/custom_input_field.dart';
import 'common/page_header.dart';
import 'common/page_heading.dart';
import 'forget_password_page.dart';
import 'signup_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              const PageHeader(),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20),),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          const PageHeading(title: 'Log-in',),
                          CustomInputField(
                            labelText: 'Email',
                            controller: emailController,
                            textinput: TextInputType.emailAddress,
                            hintText: 'Your email id',
                            validator: (textValue) {
                              if(textValue == null || textValue.isEmpty) {
                                return 'Email is required!';
                              }
                              if(!EmailValidator.validate(textValue)) {
                                return 'Please enter a valid email';
                              }else{
                                emailController.text=textValue;
                              }
                              return null;
                            }
                          ),
                          const SizedBox(height: 16,),
                          CustomInputField(
                            labelText: 'Password',
                            hintText: 'Your password',
                            controller: passwordController,
                            obscureText: true,
                            suffixIcon: true,
                            validator: (textValue) {
                              if(textValue == null || textValue.isEmpty) {
                                return 'Password is required!';
                              }else{
                              passwordController.text=textValue;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16,),
                          Container(
                            width: size.width * 0.80,
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgetPasswordPage()))
                              },
                              child: const Text(
                                'Forget password?',
                                style: TextStyle(
                                  color: Color(0xff939393),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
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
                          onPressed: () async{
                          if (_loginFormKey.currentState.validate()) {
                            try {
                              FocusScope.of(context).unfocus();
                  setState(() {
                    _isLoading = true;
                  });

                  //await Future.delayed(Duration(seconds: 2));
                  if(emailController.text=="admin@gmail.com" && passwordController.text=="admin"){

                    
                    Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => AdminHomeScreen(),));
                  }
                  else{
                  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                  String email = emailController.text.toString();
                  String password = passwordController.text.toString();
                  /*if(_isSignIn) {
      setState(() {
        _isLoading = true;
      });*/
                  await _firebaseAuth.signInWithEmailAndPassword(
                      email: email, password: password).then((value) async {
                    if (value.user != null) {

                        setState(() {
                              _isLoading = false;
                              emailController.text.isEmpty;
                              passwordController.text.isEmpty;
                              });

                        
                      FirebaseFirestore.instance.collection("Users").doc(
                          emailController.text).snapshots().listen((event) async {
                            
                            if(event.get("status")=="Registered"){
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>HomeScreen(
                              user_name: event.get("name"),
                              user_image: event.get("image"),
                              user_contact: event.get("contact"),
                              user_location: event.get("location"),
                              user_email: event.get("email"),
                            ) ));
                            }

                            else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>BuyHomeScreen(
                              user_name: event.get("name"),
                              user_image: event.get("image"),
                              user_contact: event.get("contact"),
                              user_location: event.get("location"),
                              user_email: event.get("email"),
                            ) ));
                            }

                   

                      });
                      
                    }
                  }
                  );
                  }

                }catch(error){
                  setState(() {
                    _isLoading = false;
                    // _openDialog(context);
                  });
                  switch (error.code) {
                    case "ERROR_WRONG_PASSWORD":
                      errorMessage = "Wrong email/password combination.";
                      return _openDialog(errorMessage);
                      break;
                    case "wrong-password":
                      errorMessage = "Wrong email/password combination.";
                      return _openDialog(errorMessage);
                      break;
                    case "ERROR_USER_NOT_FOUND":
                      errorMessage = "No user found with this email.";
                      return _openDialog(errorMessage);
                      break;
                    case "user-not-found":
                      errorMessage = "No user found with this email.";
                      return _openDialog(errorMessage);
                      break;
                    case "ERROR_USER_DISABLED":
                      errorMessage = "User disabled.";
                      return _openDialog(errorMessage);
                      break;
                    case "user-disabled":
                      errorMessage = "User disabled.";
                      return _openDialog(errorMessage);
                      break;
                    case "invalid-email":
                      errorMessage = "Email address is invalid.";
                      return _openDialog(errorMessage);
                      break;
                    default:
                      errorMessage = "Login failed. Please try again.";
                      return _openDialog(errorMessage);
                      break;
                  }
                    }

                       }
                          },
                           child:  _isLoading
                                ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(color: Colors.white,),
                                    const SizedBox(width: 24),
                                    Text("Please Wait....", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),)
                                  ],
                                )
                                : Text("Log-In",style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),

                          
                          const SizedBox(height: 18,),
                          SizedBox(
                            width: size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Don\'t have an account ? ', style: TextStyle(fontSize: 13, color: Color(0xff939393), fontWeight: FontWeight.bold),),
                                GestureDetector(
                                  onTap: () => {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()))
                                  },
                                  child: const Text('Sign-up', style: TextStyle(fontSize: 15, color: Color(0xff748288), fontWeight: FontWeight.bold),),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20,),
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
