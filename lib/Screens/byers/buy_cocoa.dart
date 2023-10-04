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




class BuyCocoa extends StatefulWidget {
  String user_name,user_contact,user_image,user_location,user_email,
   seller_email,seller_name,seller_image,seller_location,seller_contact,cocoa_qty;
   BuyCocoa({Key key, this.user_contact,this.user_image,this.user_location,this.user_name,this.user_email,
   this.cocoa_qty,this.seller_contact,this.seller_email,this.seller_image,this.seller_location,this.seller_name
  }) : super(key: key);

  @override
  State<BuyCocoa> createState() => _BuyCocoaState();
}

class _BuyCocoaState extends State<BuyCocoa> {

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
        title: Text('Buy Cocoa',
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
                      const PageHeading(title: 'Cocoa Seller Profile',),
                  
                      const SizedBox(height: 16,),
                       CircleAvatar(
                        radius: 90,
                          backgroundColor: Color.fromARGB(255, 54, 24, 13),
                          //backgroundImage: NetworkImage(widget.user_image),
                          child:  CircleAvatar(
                            radius: 85,
                          backgroundColor: Color.fromARGB(255, 243, 227, 206),
                          backgroundImage: NetworkImage(widget.seller_image),
                       
                        ),
                        ),

                       SizedBox(height: 20,),
                      
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
                          readOnly: true,
                          isDense: true,
                          
                      ),
                       const SizedBox(height: 16,),
                      CustomInputField(
                        controller: locationController.text,
                          labelText: 'Location',
                          hintText: widget.user_location,
                          isDense: true,
                          readOnly: true,
                      ),

                      SizedBox(height: 30,),

                      Center(child: Text("Total Available Cocoa(Bags)",
                      style: TextStyle(fontSize: 18,color: Colors.black54),
                      ),),
                      SizedBox(height: 10,),
                      Center(child: Text(widget.cocoa_qty,
                      style: TextStyle(fontSize: 28,color: Colors.black,fontWeight: FontWeight.bold),
                      ),),
                     SizedBox(height: 20,),
                     Divider(color: Colors.black,),
                      Center(child: Text("No. Of Bags Purchasing",
                      style: TextStyle(fontSize: 18,color: Color.fromARGB(255, 238, 142, 87),fontWeight: FontWeight.bold),
                      ),),
                     Divider(color: Colors.black,),

                      CustomInputField(
                        controller: locationController.text,
                        style:  TextStyle(fontSize: 28,color: Colors.black,fontWeight: FontWeight.bold),
                        Borders: OutlineInputBorder(),
                          labelText: 'Quantity',
                          hintText: "0",
                          isDense: true,
                          textinput: TextInputType.number,
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
                              
                            FocusScope.of(context).unfocus();

                           if(_isLoading) return;

                              setState(() => _isLoading = true);
                              await Future.delayed(Duration(seconds: 2));
                          
                           
                                  Map<String, dynamic> UserData = new Map<String,dynamic>();
                                
                                  UserData["seller_name"] = widget.seller_name;
                                  UserData["seller_contact"] = widget.seller_contact;
                                  UserData["seller_location"] = widget.seller_location;
                                  UserData["seller_image"] = widget.seller_image;
                                  UserData["seller_email"] = widget.seller_email;

                                   UserData["user_name"] = widget.user_name;
                                  UserData["user_contact"] = widget.user_contact;
                                  UserData["user_location"] = widget.user_location;
                                  UserData["user_image"] = widget.user_image;
                                  UserData["user_email"] = widget.user_email;

                                  UserData["cocoa_qty"] = locationController.text;

                                  FirebaseFirestore.instance
                                      .collection("Cocoa_Orders").doc("${widget.user_email}_${widget.seller_email}")
                                      .set(UserData)
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
                                : Text("Place Request",style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
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
