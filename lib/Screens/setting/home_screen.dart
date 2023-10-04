import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocoa_system/Screens/details/details_screen.dart';
import 'package:cocoa_system/Screens/home/cocoa_home_screen.dart';
import 'package:cocoa_system/Screens/home/cocoastock.dart';
import 'package:cocoa_system/Screens/home/cocoastockupdate.dart';
import 'package:cocoa_system/Screens/home/home_screen.dart';
import 'package:cocoa_system/Screens/product/farm_videos.dart';
import 'package:cocoa_system/Screens/product/product_detail.dart';
import 'package:cocoa_system/Screens/product/product_home.dart';
import 'package:cocoa_system/Screens/setting/profile_update.dart';
import 'package:cocoa_system/Screens/shopping/home_screen.dart';
import 'package:cocoa_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';



class SettingScreen extends StatefulWidget {
  String user_name,user_contact,user_image,user_location, user_email;
  SettingScreen({
    Key key, this.user_contact,this.user_image,this.user_location,this.user_name,this.user_email
  }) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

 List<String> categories = [
    "All Products",
    "Tools",
    "Agrochemical",
    "Other Product",
    
  ];

int selectedPos = 3;
int selectedIndex = 0;

  double bottomNavBarHeight = 50;

  List<TabItem> tabItems = List.of([
    TabItem(Icons.home, "Home", Colors.brown, 
        labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
    TabItem(Icons.shopping_cart, "Shopping", Colors.brown,
        labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
    TabItem(Icons.layers, "Reports", Colors.brown,
        labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
    TabItem(Icons.settings, "Settings", Colors.brown,
        labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
  ]);

  CircularBottomNavigationController _navigationController;
  

  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(selectedPos);
  }


    @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }


  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 105, 53, 9),
        elevation: 0,
       leading: IconButton(
          icon: Icon(Icons.settings),
          color: Colors.white,
          onPressed: () {
           
          },
        ),
        title: Text("Settings"),
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
      body:Stack(
        children: <Widget>[
          Padding(
            child:  SingleChildScrollView(child: Column(
            children: [
              
                 Container(
                  color: Colors.grey[200],
                  child: Column(
                    children: [

                      SizedBox(height: 30.0,),

                      CircleAvatar(
                      radius: 85,
                      backgroundColor: Color.fromARGB(255, 53, 34, 8),
                      child: CircleAvatar(
                        radius: 80.0,
                       // backgroundImage: AssetImage('assets/images/cocoa.jpg'),
                        backgroundImage: NetworkImage(widget.user_image),
                        backgroundColor: Color.fromARGB(255, 221, 200, 200),
                      ),
                      ),
                      SizedBox(height: 10.0,),
                      Text('${widget.user_name}',
                      style: TextStyle(
                        color:Color.fromARGB(255, 88, 49, 35),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )),
                      SizedBox(height: 10.0,),


                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Card(
                child: Padding(
                  padding:EdgeInsets.all(16.0),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                     
                   Align(
                        alignment: Alignment.topLeft,
                        child:Text("Personal Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                        ),
                      ),

                      Divider(color: Colors.black54,),
                      SizedBox(height: 10,),

                      Row(
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Name : ",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  )
                                ),

                                TextSpan(
                                  text: "${widget.user_name}",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 58, 32, 23),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )
                                ),
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
                                  text: "Location : ",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  )
                                ),

                                TextSpan(
                                  text: "${widget.user_location}",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 58, 32, 23),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )
                                ),
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
                                  text: "Contact : ",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  )
                                ),

                                TextSpan(
                                  text: "${widget.user_contact}",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 58, 32, 23),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )
                                ),
                              ]
                            ),
                          ),
                        ],
                      ),
                      
                      Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          
                          backgroundColor: Color.fromARGB(255, 151, 100, 81),
                          onPressed: () async{
                             String dataFromSecondPage = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProfileUpdatePage(
                                          user_name: widget.user_name,
                                          user_image: widget.user_image,
                                          user_contact: widget.user_contact,
                                          user_location: widget.user_location,
                                          user_email: widget.user_email,
                                        ),
                                  ));

                                  setState(() {
                                  //textFromSecondScreen = dataFromSecondPage;
                                  if (dataFromSecondPage==null){

                                  }else{
                                    widget.user_name=dataFromSecondPage;
                                  }
                                });

                          },
                          child: Icon(
                            Icons.edit,
                          ),
                          
                        ),
                        ),
                    ],
                  ),
                ),
                      ),
              ),

                SizedBox(height: 10,),

              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Card(
                child: Padding(
                  padding:EdgeInsets.all(16.0),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Align(
                        alignment: Alignment.topLeft,
                        child:Text("Management",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                        ),
                      ),

                      Divider(color: Colors.black54,),
                      
                      SizedBox(height: 10,),
                     
                      RaisedButton(
                                onPressed: () async{
                                   FirebaseFirestore.instance.collection("Cocoa_Sellers").doc(
                          widget.user_email).snapshots().listen((event) async {
                            
                            if(event.exists){
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>CocoaStockUpdate(
                              user_name: event.get("name"),
                              user_image: event.get("image"),
                              user_contact: event.get("contact"),
                              user_location: event.get("location"),
                              user_email: event.get("email"),
                              cocoa_qty: event.get("cocoa_qty"),
                            ) ));
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>CocoaStock(
                              user_name: widget.user_name,
                              user_image: widget.user_image,
                              user_contact: widget.user_contact,
                              user_location: widget.user_location,
                              user_email: widget.user_email,
                            ) ));
                            }
                          });
                                },
                                color: Color.fromARGB(255, 248, 226, 215),
                                child: Padding(
                                  padding: EdgeInsets.all(1),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Cocoa',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: Color.fromARGB(255, 71, 44, 34),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.brown,
                                      )
                                    ],
                                  ),
                                ),
                              ), 
                              
                              RaisedButton(
                                onPressed: () {
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProductHomeScreen(
                                          user_email: widget.user_email,
                                          user_contact: widget.user_contact,
                                          user_name: widget.user_name,
                                        ),
                                  ));
                                  
                                },
                                color: Color.fromARGB(255, 248, 226, 215),
                                child: Padding(
                                  padding: EdgeInsets.all(1),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Tools and Agrochemical',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: Color.fromARGB(255, 71, 44, 34),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.brown,
                                      )
                                    ],
                                  ),
                                ),
                              ), 

                              
                    ],
                  ),
                ),
                ),
              ),

              SizedBox(height: 10,),

              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Card(
                child: Padding(
                  padding:EdgeInsets.all(16.0),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Align(
                        alignment: Alignment.topLeft,
                        child:Text("Videos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                        ),
                      ),

                      Divider(color: Colors.black54,),
                      
                      SizedBox(height: 10,),
                     
                      RaisedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                     MaterialPageRoute(builder: ((context) => FarmVideos()))
                                  );
                                },
                                color: Color.fromARGB(255, 248, 226, 215),
                                child: Padding(
                                  padding: EdgeInsets.all(1),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Farming Activities',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: Color.fromARGB(255, 71, 44, 34),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.brown,
                                      )
                                    ],
                                  ),
                                ),
                              ), 
                              
                             
                    ],
                  ),
                ),
                ),
              ),
          
              SizedBox(height: 20,),
                     
                    
            
                    ]
                  ),
                  ),

                  
                    ]
              ),
            ),
   

            padding: EdgeInsets.only(bottom: bottomNavBarHeight),
          ),
          Align(
            alignment: Alignment.bottomCenter, 
            child: CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      selectedPos: selectedPos,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: Colors.white,
      backgroundBoxShadow: <BoxShadow>[
        BoxShadow(color: Colors.black45, blurRadius: 10.0),
      ],
      animationDuration: Duration(milliseconds: 200),
      selectedCallback: (int selectedPos) {
        setState(() {
          this.selectedPos = selectedPos ?? 0;

          if(selectedPos==0){
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen(
              user_name: widget.user_name,
              user_image: widget.user_image,
              user_contact: widget.user_contact,
              user_location: widget.user_location,
            )));
            
          }
          else if(selectedPos==1){
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => ShoppingScreen(
              user_name: widget.user_name,
              user_image: widget.user_image,
              user_contact: widget.user_contact,
              user_location: widget.user_location,
              user_email: widget.user_email,
            ),));
            
          }
          else if(selectedPos==2){
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => CocoaHomeScreen(
              user_name: widget.user_name,
              user_image: widget.user_image,
              user_contact: widget.user_contact,
              user_location: widget.user_location,
              user_email: widget.user_email,
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
