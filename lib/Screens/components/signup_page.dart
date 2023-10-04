import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'common/custom_form_button.dart';
import 'common/custom_input_field.dart';
import 'common/page_header.dart';
import 'common/page_heading.dart';
import 'login_page.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({Key key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  File _profileImage;

  final _signupFormKey = GlobalKey<FormState>();

  bool _isLoading = false;


  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future _pickProfileImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;

      final imageTemporary = File(image.path);
      setState(() => _profileImage = imageTemporary);
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image error: $e');
    }
  }

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

   


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: SingleChildScrollView(
          child: Form(
            key: _signupFormKey,
            child: Column(
              children: [
                const PageHeader(),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20),),
                  ),
                  child: Column(
                    children: [
                      const PageHeading(title: 'Sign-up',),
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 243, 227, 206),
                          backgroundImage: _profileImage != null ? FileImage(_profileImage) : null,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: _pickProfileImage,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 85, 63, 34),
                                      border: Border.all(color: Colors.white, width: 3),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_sharp,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16,),
                      
                      CustomInputField(
                        controller: nameController.text,
                          labelText: 'Name',
                          hintText: 'Your name',
                          isDense: true,
                          validator: (textValue) {
                            if(textValue == null || textValue.isEmpty) {
                              return 'Name field is required!';
                            }
                            else{
                              nameController.text=textValue;
                            }
                            return null;
                          }
                      ),
                      const SizedBox(height: 16,),
                      CustomInputField(
                        textinput: TextInputType.emailAddress,
                        controller: emailController.text,
                          labelText: 'Email',
                          hintText: 'Your email id',
                          isDense: true,
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
                        textinput: TextInputType.number,
                        controller: contactController.text,
                          labelText: 'Contact no.',
                          hintText: 'Your contact number',
                          
                          isDense: true,
                          validator: (textValue) {
                            if(textValue == null || textValue.isEmpty) {
                              return 'Contact number is required!';
                            }
                            else{
                              contactController.text=textValue;
                            }
                            return null;
                          }
                      ),
                       const SizedBox(height: 16,),
                      CustomInputField(
                        controller: locationController.text,
                          labelText: 'Location',
                          hintText: 'Residence',
                          isDense: true,
                          validator: (textValue) {
                            if(textValue == null || textValue.isEmpty) {
                              return 'Residence is required!';
                            }
                            else{
                              locationController.text=textValue;
                            }
                            return null;
                          }
                      ),
                      const SizedBox(height: 16,),
                      CustomInputField(
                        controller: passwordController.text,
                        labelText: 'Password',
                        hintText: 'Your password',
                        isDense: true,
                        obscureText: true,
                        validator: (textValue) {
                          if(textValue == null || textValue.isEmpty) {
                            return 'Password is required!';
                          }else if(textValue.length<6){
                            return 'Weak password. Less than 6 characters!';
                          }
                          else{
                              passwordController.text=textValue;
                            }
                          return null;
                        },
                        suffixIcon: true,
                      ),
                      const SizedBox(height: 22,),

                      Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          //color: const Color(0xff233743),
                          color: Color.fromARGB(255, 83, 49, 38),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: TextButton(
                          onPressed: () async{
                              
                               if (_profileImage == null) {
                                setState(() => _isLoading=false);
                            _mostrarAlert('Error', 'Pruduct image is Blanck');
                          } 
                          else {

                            if(passwordController.text.length<6){
                              setState(() => _isLoading=false);
                            _mostrarAlert('Error','Weak password. Less than 6 characters!');
                          }
                          else{
                           if(_isLoading) return;
                              
                              FocusScope.of(context).unfocus();
                              
                              setState(() => _isLoading = true);
                              await Future.delayed(Duration(seconds: 2));

                               final snapShot = await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(emailController.text).get();

                            if (snapShot == null || !snapShot.exists) {
                              // docuement is not exist
                              
                           
                              Reference ref = await FirebaseStorage.instance.ref().child("user_image").child(_profileImage.uri.toString() + ".jpg");


                             await  _firebaseAuth.createUserWithEmailAndPassword(email: emailController.text.toString(), password: passwordController.text.toString()).then((value) async {
                                if(value != null) {

                                  Map<String, dynamic> UserData = new Map<String,dynamic>();
                                  
                                  UploadTask uploadTask = ref.putFile(_profileImage);
                                  String downloadUrl = await (await uploadTask).ref.getDownloadURL();
                              
                                  UserData["name"] = nameController.text;
                                  UserData["email"] = emailController.text;
                                  UserData["contact"] = contactController.text;
                                  UserData["location"] = locationController.text;
                                  UserData["password"] = passwordController.text;
                                  UserData["image"]= downloadUrl;
                                  UserData["status"]= "Not Registered";

                                  FirebaseFirestore.instance
                                      .collection("Users").doc(emailController.text.toString())
                                      .set(UserData)
                                      .whenComplete((){
                                    setState(() => _isLoading = false);
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
                                  } );

                                /*  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);*/
                                } else {
                                  setState(() {
                                   _isLoading = false;
                                  });
                                }
                              });


                               // Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                          }
                           else {
                              setState(() => _isLoading = false);
                              _mostrarAlert('Error', 'Email Already in Use or Exists');
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
                                : Text("SignUp",style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),

                      const SizedBox(height: 18,),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Already have an account ? ', style: TextStyle(fontSize: 13, color: Color(0xff939393), fontWeight: FontWeight.bold),),
                            GestureDetector(
                              onTap: ()=> Navigator.of(context).pop(),
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage())),
                              child: Text("Log-in",style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 68, 41, 10), fontWeight: FontWeight.bold),
                                ),
                              //child: const Text('Log-in', style: TextStyle(fontSize: 15, color: Color(0xff748288), fontWeight: FontWeight.bold),),
                            ),

                          
                          ],
                        ),
                      ),
                      const SizedBox(height: 30,),
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

 /* void _handleSignupUser() {
    // signup user
    if (_signupFormKey.currentState.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitting data..')),
      );
    }
  }*/
  
void _mostrarAlert(String title, String message){
  AlertDialog alertDialog=AlertDialog(
    title: Text(title),
    content: Text(message),
  );
  showDialog(context: context,builder: (_)=>alertDialog);
}
}
