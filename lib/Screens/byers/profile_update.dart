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




class ProfileUpdatePage extends StatefulWidget {
  String user_name,user_contact,user_image,user_location,user_email;
   ProfileUpdatePage({Key key, this.user_contact,this.user_image,this.user_location,this.user_name,this.user_email
  }) : super(key: key);

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {

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
                      const PageHeading(title: 'Profile Update',),
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 243, 227, 206),
                          backgroundImage: NetworkImage(widget.user_image),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () async{
                                     try {
                                            final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                                            if(image == null) return;

                                            final imageTemporary = File(image.path);
                                            setState(() => _profileImage = imageTemporary);

                                            Reference photoRef =await FirebaseStorage.instance.refFromURL(widget.user_image);
                                  await photoRef.delete().then((value) async{

                                Reference ref = await FirebaseStorage.instance.ref().child("user_image").child(_profileImage.uri.toString() + ".jpg");


                                  Map<String, dynamic> UserData = new Map<String,dynamic>();
                                  
                                  UploadTask uploadTask = ref.putFile(_profileImage);
                                  String downloadUrl = await (await uploadTask).ref.getDownloadURL();
                              
                                  
                                  UserData["image"]= downloadUrl;

                                  FirebaseFirestore.instance
                                      .collection("Users").doc(widget.user_email)
                                      .update(UserData)
                                      .whenComplete((){
                                    //setState(() => _isLoading = false);
                                    setState(() {

                                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SettingScreen(
                                      user_name: widget.user_name,
                                          user_image: downloadUrl,
                                          user_contact: widget.user_contact,
                                          user_location: widget.user_location,
                                          user_email: widget.user_email,
                                    )),);

                                      //widget.user_image=downloadUrl;
                                    });
                                    //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
                                  } );

                                  }
                                  );
                                     
                                          } on PlatformException catch (e) {
                                            debugPrint('Failed to pick image error: $e');
                                          }
                                  },
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
                          hintText: widget.user_name,
                          isDense: true,
                          validator: (textValue) {
                            if(textValue == null || textValue.isEmpty) {
                              nameController.text=widget.user_name;
                              return 'Name field is required!';
                            }
                            else{
                              nameController.text=textValue;
                            }
                            return null;
                          }
                      ),
                      const SizedBox(height: 20,),
                     
                      CustomInputField(
                        textinput: TextInputType.number,
                        controller: contactController.text,
                          labelText: 'Contact no.',
                          hintText: widget.user_contact,
                          
                          isDense: true,
                          validator: (textValue) {
                            if(textValue == null || textValue.isEmpty) {
                              contactController.text=widget.user_contact;
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
                          hintText: widget.user_location,
                          isDense: true,
                          validator: (textValue) {
                            if(textValue == null || textValue.isEmpty) {
                              locationController.text=widget.user_location;
                              return 'Residence is required!';
                            }
                            else{
                              locationController.text=textValue;
                            }
                            return null;
                          }
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
                                
                                  UserData["name"] = nameController.text;
                                  UserData["contact"] = contactController.text;
                                  UserData["location"] = locationController.text;

                                  FirebaseFirestore.instance
                                      .collection("Users").doc(widget.user_email)
                                      .update(UserData)
                                      .whenComplete((){
                                    setState(() => _isLoading = false);
                                    
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SettingScreen(
                                      user_name: nameController.text,
                                          user_image: widget.user_image,
                                          user_contact: contactController.text,
                                          user_location: locationController.text,
                                          user_email: widget.user_email,
                                    )),);
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
