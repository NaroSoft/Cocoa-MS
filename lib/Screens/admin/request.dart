import 'dart:io';
import 'package:cocoa_system/Screens/admin/requestupdate.dart';
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
import '../product/product_home.dart';




class RequestPage extends StatefulWidget {
   RequestPage({Key key,});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {

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
    
    super.initState();
  }

   @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  contactController.dispose();
  locationController.dispose();
   
  }


  TextEditingController _searchController =TextEditingController();
   TextEditingController _searchController1 =TextEditingController();

    Future resultsLoaded1;
    List _allResults1=[];

    List _resultsList1 =[];

   @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      resultsLoaded1= getUsersPastTripsStreamSnapshots1();
    }


    _onSearchChanged1(){
      searchResultsList1();
      //print(_searchController.text);
    }

    searchResultsList1(){

      var showResults1 =[];

      if(_searchController1.text !=""){

          for(var tripSnapshot in _allResults1){

            var pname = Trip.fromSnapshot(tripSnapshot).name.toLowerCase();

            if(pname.contains(_searchController1.text)){
              showResults1.add(tripSnapshot);
            }
          }
      }else{
        showResults1=List.from(_allResults1);
      }

      setState(() {
        _resultsList1=showResults1;
      });
    }


   getUsersPastTripsStreamSnapshots1() async{
      //final uid = await Provider.of(context).au
      var data = await FirebaseFirestore.instance.collection('Users').where('status', isEqualTo: 'Awaiting').get();
      setState(() {
        _allResults1= data.docs;
      });
      searchResultsList1();
      return "complete";
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
        title: Text('Registration Request',
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
        body: Stack(
        children: <Widget>[
          Padding(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Padding(
          padding: EdgeInsets.only(left: 30, right: 30, bottom: 10),
          child: TextField(
            controller: _searchController1,
            decoration: InputDecoration(
              label: Text("Search"),
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        /*Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Text(
            "My Products",
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Categories(),*/

        //Main body, list of products
        Expanded(
          child: _resultsList1.isEmpty ? Center(child: CircularProgressIndicator())
              :ListView.builder(
            itemCount: _resultsList1.length,
            itemBuilder: (context, index) {
             // DocumentSnapshot data = snapshot.data.docs[index];
              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  width: double.infinity,
                  child: Row(

                    children: <Widget>[
                      Flexible(child: ListTile(
                    onTap: (){
                    Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        RequestUpdatePage(
                                          user_email: _resultsList1[index]["email"],
                                          user_name: _resultsList1[index]["name"],
                                          user_contact: _resultsList1[index]["contact"],
                                          user_location: _resultsList1[index]["location"],
                                          user_image: _resultsList1[index]["image"],
                                        ),
                                  ));
                    },
                      title:  SizedBox(
                        height: MediaQuery.of(context).size.height*0.15,
                        width: MediaQuery.of(context).size.width,
                        child:  Card(
                          elevation: 5,
                          child: Row(
                            children: <Widget>[

                              InkWell(
                                onTap: ()async {
                              await showDialog(
                                context: context,
                                builder: (_) =>  Dialog(      
                                  child: Container(
                                     width: 200,
                                     height: 300,
                                     child: Image.network(_resultsList1[index]["image"],
                                     fit: BoxFit.fill,
                                        ),                  
                              ),
                                ),
                                );
                                },
                                child: new Container(

                                child: Image.network(_resultsList1[index]["image"],height: MediaQuery.of(context).size.width*0.3,width: MediaQuery.of(context).size.width*0.3,
                                fit: BoxFit.fill,
                                ),
                              ),),
                              
                              Padding(
                                padding: const EdgeInsets.only(left: 5,right: 5,top: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    new Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[

                                                  SizedBox(width: 5),
                                                  Text(_resultsList1[index]["name"], style: TextStyle(fontWeight: FontWeight.w500,fontFamily: 'Roboto-Black'),)
                                                ],
                                              ),

                                             SizedBox(height:10.0),

                                              Text('${_resultsList1[index]["location"]}',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black54),),
                                              
                                              SizedBox(height:10.0),

                                              Text('${_resultsList1[index]["contact"]}',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black26),),

                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
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
                  padding: EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                       //color: Colors.black,
                  ),
                ),
              );
            },
          ),
        
        ),
      ],
    ),
        
            padding: EdgeInsets.only(bottom: 20),
          ),
      
        ],
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
