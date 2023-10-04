import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocoa_system/Screens/admin/cocoa_info.dart';
import 'package:cocoa_system/Screens/admin/request.dart';
import 'package:cocoa_system/Screens/admin/sysytem_users.dart';
import 'package:cocoa_system/Screens/admin/video.dart';
import 'package:cocoa_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';

import '../byers/setting.dart';


class AdminHomeScreen extends StatefulWidget {
  AdminHomeScreen({
    Key key, });
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {

 List<String> categories = [
    "All Products",
    "Tools",
    "Agrochemical",
    "Other Product",
    
  ];



int selectedPos = 0;
int selectedIndex = 0;

  double bottomNavBarHeight = 40;

  List<TabItem> tabItems = List.of([
    TabItem(Icons.home, "Home", Colors.brown, 
        labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
    TabItem(Icons.person,"Users", Colors.brown,
        labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
    TabItem(Icons.video_call, "Videos", Colors.brown,
        labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
      ]);

  CircularBottomNavigationController _navigationController;
  TextEditingController _searchController =TextEditingController();

  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(selectedPos);   
     //print(widget.user_email);
     countDocuments();
  }


    @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
    
  }

   var totalusers=0;
    var registered=0;
    var notregistered=0;
    var awaiting=0;
    var price="";
    var status="";
    var date="";
  

   void countDocuments() async{
    QuerySnapshot _myDoc=await FirebaseFirestore.instance.collection("Users").get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    

    QuerySnapshot _myDoc1=await FirebaseFirestore.instance.collection("Users").where("status",isEqualTo: "Registered").get();
    List<DocumentSnapshot> _myDocCount1 = _myDoc1.docs;

    QuerySnapshot _myDoc3=await FirebaseFirestore.instance.collection("Users").where("status",isEqualTo: "Awaiting").get();
    List<DocumentSnapshot> _myDocCount3 = _myDoc3.docs;
    

    QuerySnapshot _myDoc2=await FirebaseFirestore.instance.collection("Users").where("status",isEqualTo: "Not Registered").get();
    List<DocumentSnapshot> _myDocCount2 = _myDoc2.docs;
    setState(() {
      totalusers=_myDocCount.length;
      registered=_myDocCount1.length;
      notregistered=_myDocCount2.length;
      awaiting = _myDocCount3.length;
    });

    FirebaseFirestore.instance.collection("Cocoa").doc("info").snapshots().listen((event) async {
       setState(() {
         price=event.get("amount");
        status=event.get("status");
        date=event.get("date");
       });
        
      }
     );              
   
   }



  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 99, 72, 54),
        elevation: 0,
       /* leading: IconButton(
          icon: SvgPicture.asset("assets/icons/back.svg"),
          onPressed: () {},
        ),*/
        title: Text("SMART COCOA"),
        centerTitle: true,
        /*actions: <Widget>[
          
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AddProduct(),
                                  ));
            },
          )
        ]*/
        ),
      body: Stack(
        children: <Widget>[
          Padding(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
       
        //Divider(color: Colors.black54,),
        Expanded(
          child: Container(
       
          child: Padding(
            padding: EdgeInsets.all(5),
            child: ListView(
              
             children: [
             

          Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: 20,
              child: Material(
                child: Container(
                  height: 140,
                  width: MediaQuery.of(context).size.width*0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0.0),
                    boxShadow: [
                      new BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: new Offset(-10.0, 10.0),
                      blurRadius: 20.0,
                      spreadRadius: 4.0,
                    ),
                    ]
                  ),
                ),
              ),
              ),


            Positioned(
              left: 16,
              child: Card(
                elevation: 10.0,
                shadowColor: Colors.brown,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  height: 155,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: AssetImage("assets/images/cocoa2.jpg"),
                      fit: BoxFit.fill,
                      ),
                  ),
                ),
              ),
            ),

           Positioned(
              top: 30,
              left: 150,
              child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width*0.5,
                  child: Column(
                    children: [
                      Text("Cocoa Price",style: TextStyle(
                        fontWeight: FontWeight.bold,color: Color.fromARGB(255, 77, 43, 31),
                        //fontSize: 17,
                        ),),
                        Text(price,style: TextStyle(
                        fontWeight: FontWeight.bold,color: Colors.grey,
                        //fontSize: 16,
                        ),),

                        Divider(color: Colors.black,),

                        Text("Cocoa Calender",style: TextStyle(
                        fontWeight: FontWeight.bold,color: Color.fromARGB(255, 226, 99, 53),
                        //fontSize: 17,
                        ),),
                        
                        Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "  Status:  ",style: TextStyle(
                                      fontWeight: FontWeight.bold,color: Colors.brown,
                                      //fontSize: 16,
                                      ),
                                  ),
                                  TextSpan(
                                    text: status,style: TextStyle(
                                      fontWeight: FontWeight.bold,color: Color.fromARGB(255, 155, 150, 148),
                                      //fontSize: 16,
                                      ),
                                  )
                                ]
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "  Date:  ",style: TextStyle(
                                      fontWeight: FontWeight.bold,color: Colors.brown,
                                      //fontSize: 16,
                                      ),
                                  ),
                                  TextSpan(
                                    text: date,style: TextStyle(
                                      fontWeight: FontWeight.bold,color: Color.fromARGB(255, 155, 150, 148),
                                      //fontSize: 16,
                                      ),
                                  )
                                ]
                              ),
                            ),
                          ],
                        ),
                      
                       Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
              primary: Color.fromARGB(255, 70, 40, 31),
              
              ),

              onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context)=> CocoaDetail(
                      price: price,
                      status: status,
                      date: date,
                    ) 
                    ));
              },
              child: Text("Edit Info"),
              ),
              ),


                    ],
                  ),
              )
            ), 
             ],
    
            
          )
          ),

           Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: 20,
              child: Material(
                child: Container(
                  height: 140,
                  width: MediaQuery.of(context).size.width*0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0.0),
                    boxShadow: [
                      new BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: new Offset(-10.0, 10.0),
                      blurRadius: 20.0,
                      spreadRadius: 4.0,
                    ),
                    ]
                  ),
                ),
              ),
              ),


            Positioned(
              left: 16,
              child: Card(
                elevation: 10.0,
                shadowColor: Colors.brown,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  height: 155,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: AssetImage("assets/images/cocoa.jpg"),
                      fit: BoxFit.fill,
                      ),
                  ),
                ),
              ),
            ),

           Positioned(
              top: 30,
              left: 150,
              child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width*0.5,
                  child: Column(
                    children: [
                      Text("Total Users",style: TextStyle(
                        fontWeight: FontWeight.bold,color: Color.fromARGB(255, 77, 43, 31),
                        //fontSize: 17,
                        ),),
                        Text(totalusers.toString(),style: TextStyle(
                        fontWeight: FontWeight.bold,color: Colors.grey,
                        //fontSize: 16,
                        ),),

                        Divider(color: Colors.black,),

                        Text("Users Group",style: TextStyle(
                        fontWeight: FontWeight.bold,color: Color.fromARGB(255, 226, 99, 53),
                        //fontSize: 17,
                        ),),
                        
                        Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "  Registered:  ",style: TextStyle(
                                      fontWeight: FontWeight.bold,color: Colors.brown,
                                      //fontSize: 16,
                                      ),
                                  ),
                                  TextSpan(
                                    text: registered.toString(),style: TextStyle(
                                      fontWeight: FontWeight.bold,color: Color.fromARGB(255, 155, 150, 148),
                                      //fontSize: 16,
                                      ),
                                  )
                                ]
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "  Unregistered:  ",style: TextStyle(
                                      fontWeight: FontWeight.bold,color: Colors.brown,
                                      //fontSize: 16,
                                      ),
                                  ),
                                  TextSpan(
                                    text: notregistered.toString(),style: TextStyle(
                                      fontWeight: FontWeight.bold,color: Color.fromARGB(255, 155, 150, 148),
                                      //fontSize: 16,
                                      ),
                                  )
                                ]
                              ),
                            ),
                          ],
                        ),
                      
                       Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
              primary: Color.fromARGB(255, 70, 40, 31),
              
              ),

              onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context)=> SystemUserScreen() 
                    ));
              },
              child: Text("Detail Info"),
              ),
              ),


                    ],
                  ),
              )
            ), 
             ],
    
            
          )
          ),

           Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: 20,
              child: Material(
                child: Container(
                  height: 140,
                  width: MediaQuery.of(context).size.width*0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0.0),
                    boxShadow: [
                      new BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: new Offset(-10.0, 10.0),
                      blurRadius: 20.0,
                      spreadRadius: 4.0,
                    ),
                    ]
                  ),
                ),
              ),
              ),


            Positioned(
              left: 16,
              child: Card(
                elevation: 10.0,
                shadowColor: Colors.brown,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  height: 155,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: AssetImage("assets/images/cocoa2.jpg"),
                      fit: BoxFit.fill,
                      ),
                  ),
                ),
              ),
            ),

           Positioned(
              top: 30,
              left: 150,
              child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width*0.5,
                  child: Column(
                    children: [
                      Text("Registration Request",style: TextStyle(
                        fontWeight: FontWeight.bold,color: Color.fromARGB(255, 77, 43, 31),
                        //fontSize: 17,
                        ),),
                        Divider(color: Colors.black,),
                        Divider(color: Colors.black,),
                        Text(awaiting.toString(),style: TextStyle(
                        fontWeight: FontWeight.bold,color: Colors.grey,
                        //fontSize: 16,
                        ),),

                        Divider(color: Colors.black,),
                        Divider(color: Colors.black,),

                        
                      
                        Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
              primary: Color.fromARGB(255, 70, 40, 31),
              
              ),

              onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context)=> RequestPage() 
                    ));
              },
              child: Text("Check Request"),
              ),
              ),


                    ],
                  ),
              )
            ), 
             ],
    
            
          )
          ),
  

             ] 
          
        ),
        ),
            )
              )
      ],
    ),

            padding: EdgeInsets.only(bottom: bottomNavBarHeight),
          ),
          Align(
            alignment: Alignment.bottomCenter, 
            child: CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      selectedPos: selectedPos,
      barHeight: 45,
      barBackgroundColor: Colors.white,
      backgroundBoxShadow: <BoxShadow>[
        BoxShadow(color: Colors.black45, blurRadius: 10.0),
      ],
      animationDuration: Duration(milliseconds: 200),
      selectedCallback: (int selectedPos) {
        setState(() {
          this.selectedPos = selectedPos ?? 0;

          if(selectedPos==3){
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => SettingScreen(
       
            ),));
            
          }
          else if(selectedPos==1){
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => SystemUserScreen(
            
            ),));
            
          }
           else if(selectedPos==2){
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => VideoScreen(
            
            ),));
            
          }
          //print(_navigationController.value);
        });
      },
    ),
            ),
        ],
      ),
    );
  }

 
}
