import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocoa_system/Screens/byers/buy_cocoa.dart';
import 'package:cocoa_system/Screens/byers/cocoa_orders.dart';
import 'package:cocoa_system/Screens/byers/setting.dart';
import 'package:cocoa_system/Screens/byers/shopping.dart';
import 'package:cocoa_system/Screens/byers/video.dart';
import 'package:cocoa_system/Screens/details/details_screen.dart';
import 'package:cocoa_system/Screens/weather/pages/home_page.dart';
import 'package:cocoa_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';


class BuyHomeScreen extends StatefulWidget {
  String user_name,user_contact,user_image,user_location,user_email;
  BuyHomeScreen({
    Key key, this.user_contact,this.user_image,this.user_location,this.user_name,this.user_email
  }) : super(key: key);

  @override
  _BuyHomeScreenState createState() => _BuyHomeScreenState();
}

class _BuyHomeScreenState extends State<BuyHomeScreen> {

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
    TabItem(Icons.shopping_cart, "Shopping", Colors.brown,
        labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
    TabItem(Icons.video_call, "Videos", Colors.brown,
        labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
     TabItem(Icons.settings, "Settings", Colors.brown,
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




  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  
  var totalusers=0;
    var registered=0;
    var notregistered=0;
    var price="";
    var status="";
    var date="";
  

   void countDocuments() async{
    QuerySnapshot _myDoc=await FirebaseFirestore.instance.collection("Users").get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    

    QuerySnapshot _myDoc1=await FirebaseFirestore.instance.collection("Users").where("status",isEqualTo: "Registered").get();
    List<DocumentSnapshot> _myDocCount1 = _myDoc1.docs;
    

    QuerySnapshot _myDoc2=await FirebaseFirestore.instance.collection("Users").where("status",isEqualTo: "Not Registered").get();
    List<DocumentSnapshot> _myDocCount2 = _myDoc2.docs;
    setState(() {
      totalusers=_myDocCount.length;
      registered=_myDocCount1.length;
      notregistered=_myDocCount2.length;
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
      
          actions: <Widget>[
        //IconButton(
          //  icon: SvgPicture.asset("assets/icons/search.svg"),
            //onPressed: () {}),
        IconButton(
            icon: SvgPicture.asset("assets/icons/cart.svg"), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CocoaOrdersScreen(
                user_email: widget.user_email,
              )));
            }),
        SizedBox(
          width: kDefaultPadding,
        )
      ],
        ),
      body: Stack(
        children: <Widget>[
          Padding(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
       
       

       SizedBox(height: 10,),

      //information card
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
                      Text("Cocoa Price",style: TextStyle(
                        fontWeight: FontWeight.bold,color: Color.fromARGB(255, 77, 43, 31),
                        //fontSize: 17,
                        ),),
                        Text('GH₵ ${price.toString()}',style: TextStyle(
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
                                    text: status.toString(),style: TextStyle(
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
                                    text: date.toString(),style: TextStyle(
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
                    builder: (context)=> HomePage() 
                    ));
              },
              child: Text("Check Weather"),
              ),
              ),


                    ],
                  ),
              )
            ), 


          Positioned(
            top: 180,
            left: 120,
            child: Text("Cocoa Sellers",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black54,),
            ),
          ),
         
          ],
        ),
       ),

        Divider(color: Colors.black54,),
        Expanded(
          child: Container(
         /* decoration: BoxDecoration(
            boxShadow: [
                      new BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: new Offset(-10.0, 10.0),
                      blurRadius: 20.0,
                      spreadRadius: 4.0,
                    ),
                    ],
            color: Color.fromARGB(255, 245, 231, 217),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),*/
          
          child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Cocoa_Sellers').snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              :ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index){
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
                                        BuyCocoa(
                                          user_email: widget.user_email,
                                          user_image: widget.user_image,
                                          user_contact: widget.user_contact,
                                          user_location: widget.user_location,
                                          user_name: widget.user_name,

                                          seller_email: snapshot.data.docs[index]["email"],
                                          seller_name: snapshot.data.docs[index]["name"],
                                          seller_image: snapshot.data.docs[index]["image"],
                                          seller_location: snapshot.data.docs[index]["location"],
                                          seller_contact: snapshot.data.docs[index]["contact"],
                                          cocoa_qty: snapshot.data.docs[index]["cocoa_qty"],
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
                                     child: Image.network(snapshot.data.docs[index]["image"],
                                     fit: BoxFit.fill,
                                        ),                  
                              ),
                                ),
                                );
                                },
                                child: new Container(

                                child: Image.network(snapshot.data.docs[index]["image"],height: MediaQuery.of(context).size.width*0.3,width: MediaQuery.of(context).size.width*0.3,
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
                                              SizedBox(width: 5),
                                                  Text(snapshot.data.docs[index]["name"], style: TextStyle(fontWeight: FontWeight.w500,fontFamily: 'Roboto-Black'),),
                                                
                                             SizedBox(height:10.0),

                                              Text('Qty : ${snapshot.data.docs[index]["cocoa_qty"]}',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black54),),

                                                SizedBox(height:10.0),

                                              Text('Location : ${snapshot.data.docs[index]["location"]}',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black26),),

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
          );
            }

    
          ),
          
        ),
        ),
        SizedBox(height: 30,),
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
              user_name: widget.user_name,
              user_image: widget.user_image,
              user_contact: widget.user_contact,
              user_location: widget.user_location,
              user_email: widget.user_email,
            ),));
            
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
            context, MaterialPageRoute(builder: (BuildContext context) => VideoScreen(
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
