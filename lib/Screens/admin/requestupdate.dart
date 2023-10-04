import 'dart:io';
import 'package:cocoa_system/Screens/byers/setting.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/common/custom_input_field.dart';
import '../components/common/page_heading.dart';




class RequestUpdatePage extends StatefulWidget {
  String user_name,user_contact,user_image,user_location,user_email;
   RequestUpdatePage({Key key, this.user_contact,this.user_image,this.user_location,this.user_name,this.user_email
  }) : super(key: key);

  @override
  State<RequestUpdatePage> createState() => RequestUpdatePageState();
}

class RequestUpdatePageState extends State<RequestUpdatePage> {

  File _profileImage;

  final _signupFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  var _value=1;
  String _statusController="Registered";


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
   void initState() {
    // TODO: implement initState
    nameController.text=widget.user_name;
    contactController.text=widget.user_contact;
    locationController.text=widget.user_location;
    super.initState();
  }

   @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  contactController.dispose();
  locationController.dispose();
   
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading:
          IconButton(
              icon: Icon(Icons.arrow_back),
            onPressed: (){
                Navigator.pop(context);
            },
          ),
        backgroundColor: Color.fromARGB(255, 105, 53, 9),
        centerTitle: true,
        title: Text('User Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        /* actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_b_and_w,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],*/

        // backgroundColor: Colors.black,
      ),

        backgroundColor: const Color(0xffEEF1F3),
        body: SingleChildScrollView(
          child: Form(
            key: _signupFormKey,
            child: Column(
              children: [
                //const PageHeader(),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20),),
                  ),
                  child: Column(
                    children: [
                      const PageHeading(title: 'Registration Update',),
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 243, 227, 206),
                          backgroundImage: NetworkImage(widget.user_image),
                         
                        ),
                      ),
                      const SizedBox(height: 16,),
                      
                      CustomInputField(
                        readOnly: true,
                        controller: nameController.text,
                          labelText: 'Name',
                          hintText: widget.user_name,
                          isDense: true,
                          
                      ),
                      const SizedBox(height: 20,),
                     
                      CustomInputField(
                        textinput: TextInputType.number,
                        controller: contactController.text,
                          labelText: 'Contact no.',
                          hintText: widget.user_contact,
                          
                          isDense: true,
                          
                      ),
                       const SizedBox(height: 16,),
                      CustomInputField(
                        controller: locationController.text,
                          labelText: 'Location',
                          hintText: widget.user_location,
                          isDense: true,
                          
                      ),
                                  SizedBox(height: 20,),

        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Row(children: [
        Text("Select Status: ",style: TextStyle(fontSize: 17.0,color: Colors.brown),),
        SizedBox(width: 10.0,),
        DropdownButton(
            dropdownColor: Color.fromARGB(255, 248, 234, 229),
            value: _value,
            items: [
              DropdownMenuItem(
                child: Text("Registered",style: TextStyle(fontSize: 17.0,),),
                value: 1,
              ),
              DropdownMenuItem(
                child: Text("Not Registered",style: TextStyle(fontSize: 17.0),),
                value: 2,
              ),
            

            ],
            onChanged: (value) {
              setState(() {
                _value = value;
                if(value==1){
                  _statusController="Registered";
                }
                else {
                  _statusController="Not Registered";
                }
                
              });
            }),

      ],),),
                     
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
                              
                            FocusScope.of(context).unfocus();

                           if(_isLoading) return;

                              setState(() => _isLoading = true);
                          
                           
                                  Map<String, dynamic> UserData = new Map<String,dynamic>();
                                
                                  UserData["status"] = _statusController;
                                  
                                  FirebaseFirestore.instance
                                      .collection("Users").doc(widget.user_email)
                                      .update(UserData)
                                      .whenComplete((){
                                    setState(() => _isLoading = false);
                                    
                                    Navigator.of(context).pop();
                                  } );

                       
                               // Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                         
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
                                : Text("Update",style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
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
