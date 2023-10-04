import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocoa_system/Screens/byers/buy_home_screen.dart';
import 'package:cocoa_system/Screens/byers/setting.dart';
import 'package:cocoa_system/Screens/byers/shopping.dart';
import 'package:cocoa_system/Screens/product/farm_videos.dart';
import 'package:cocoa_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:webview_flutter/webview_flutter.dart';


class VideoScreen extends StatefulWidget {
  String user_name,user_contact,user_image,user_location, user_email;
  VideoScreen({
    Key key, this.user_contact,this.user_image,this.user_location,this.user_name,this.user_email
  }) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {

 List<String> categories = [
    "All Products",
    "Tools",
    "Agrochemical",
    "Other Product",
    
  ];

int selectedPos = 2;
int selectedIndex = 0;

  double bottomNavBarHeight = 50;

  List<TabItem> tabItems = List.of([
     TabItem(Icons.home, "Home", Colors.brown, 
        labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
    TabItem(Icons.shopping_cart, "Shopping", Colors.brown,
        labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
    TabItem(Icons.video_call, "Videos", Colors.brown,
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
  
   final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  num _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 105, 53, 9),
        elevation: 0,
       leading: IconButton(
          icon: Icon(Icons.settings),
          color: Color.fromARGB(255, 105, 53, 9),
          onPressed: () {
           
          },
        ),
        title: Text("Farm Videos"),
        //centerTitle: true,
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
            child:   IndexedStack(
          index: _stackToView,
          children: [
            Column(
              children: <Widget>[
                Expanded(
                    child: WebView(
                  initialUrl: "https://www.youtube.com/results?search_query=cocoa+farming+in+ghana",
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: _handleLoad,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                )),
              ],
            ),
            Container(
              child: Center(child: CircularProgressIndicator(),)
            ),
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
      barHeight: 40,
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
            context, MaterialPageRoute(builder: (BuildContext context) => BuyHomeScreen(
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
          else if(selectedPos==3){
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => SettingScreen(
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
