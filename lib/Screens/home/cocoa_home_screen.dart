import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocoa_system/Screens/SellerMessage/Seller/Cocoa/chatpage.dart';
import 'package:cocoa_system/Screens/details/details_screen.dart';
import 'package:cocoa_system/Screens/home/home_screen.dart';
import 'package:cocoa_system/Screens/product/product_home.dart';
import 'package:cocoa_system/Screens/weather/pages/home_page.dart';
import 'package:cocoa_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';

import '../setting/home_screen.dart';
import '../shopping/home_screen.dart';


class CocoaHomeScreen extends StatefulWidget {
  String user_name,user_contact,user_image,user_location,user_email;
  CocoaHomeScreen({
    Key key, this.user_contact,this.user_image,this.user_location,this.user_name,this.user_email
  }) : super(key: key);

  @override
  _CocoaHomeScreenState createState() => _CocoaHomeScreenState();
}

class _CocoaHomeScreenState extends State<CocoaHomeScreen> {

 List<String> categories = [
    "All Products",
    "Tools",
    "Agrochemical",
    "Other Product",
    
  ];

 


int selectedPos = 2;
int selectedIndex = 0;

  double bottomNavBarHeight = 40;

 List<TabItem> tabItems = List.of([
    TabItem(Icons.home, "Home", Colors.brown, 
        labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
    TabItem(Icons.shopping_cart, "Shopping", Colors.brown,
        labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
    TabItem(Icons.layers, "Orders", Colors.brown,
        labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
    TabItem(Icons.settings, "Settings", Colors.brown,
        labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
  ]);


  CircularBottomNavigationController _navigationController;
    TextEditingController _searchController =TextEditingController();
   TextEditingController _searchController1 =TextEditingController();
   TextEditingController _searchController2 =TextEditingController();
    
    Future resultsLoaded;
    Future resultsLoaded1;
    Future resultsLoaded2;

    List _allResults=[];
    List _allResults1=[];
    List _allResults2=[];

    List _resultsList =[];
    List _resultsList1 =[];
    List _resultsList2 =[];

   @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      resultsLoaded= getUsersPastTripsStreamSnapshots();
      resultsLoaded1= getUsersPastTripsStreamSnapshots1();
      resultsLoaded2= getUsersPastTripsStreamSnapshots2();
    }

    _onSearchChanged(){
      searchResultsList();
      //print(_searchController.text);
    }

    _onSearchChanged1(){
      searchResultsList1();
      //print(_searchController.text);
    }
    _onSearchChanged2(){
      searchResultsList2();
      //print(_searchController.text);
    }


    searchResultsList(){

      var showResults =[];

      if(_searchController.text !=""){

          for(var tripSnapshot in _allResults){

            var pname = Trip.fromSnapshot(tripSnapshot).name.toLowerCase();

            if(pname.contains(_searchController.text)){
              showResults.add(tripSnapshot);
            }
          }
      }else{
        showResults=List.from(_allResults);
      }

      setState(() {
        _resultsList=showResults;
      });
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

    searchResultsList2(){

      var showResults2 =[];

      if(_searchController2.text !=""){

          for(var tripSnapshot in _allResults2){

            var pname = Trip.fromSnapshot(tripSnapshot).name.toLowerCase();

            if(pname.contains(_searchController2.text)){
              showResults2.add(tripSnapshot);
            }
          }
      }else{
        showResults2=List.from(_allResults2);
      }

      setState(() {
        _resultsList2=showResults2;
      });
    }


    getUsersPastTripsStreamSnapshots() async{
      //final uid = await Provider.of(context).au
      var data = await FirebaseFirestore.instance.collection('Users').get();
      setState(() {
        _allResults= data.docs;
      });
      searchResultsList();
      return "complete";
    }

   getUsersPastTripsStreamSnapshots1() async{
      //final uid = await Provider.of(context).au
      var data = await FirebaseFirestore.instance.collection('Cocoa_Orders').where('seller_email', isEqualTo: widget.user_email).get();
      setState(() {
        _allResults1= data.docs;
      });
      searchResultsList1();
      return "complete";
    }

     getUsersPastTripsStreamSnapshots2() async{
      //final uid = await Provider.of(context).au
      var data = await FirebaseFirestore.instance.collection('Orders').where('user_email',isEqualTo: widget.user_email).get();
      setState(() {
        _allResults2= data.docs;
      });
      searchResultsList2();
      return "complete";
    }


  

  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(selectedPos);
     _searchController.addListener(_onSearchChanged);
     _searchController1.addListener(_onSearchChanged1);
     _searchController2.addListener(_onSearchChanged2);
  }


    @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();

    _searchController1.removeListener(_onSearchChanged1);
    _searchController1.dispose();

    _searchController2.removeListener(_onSearchChanged2);
    _searchController2.dispose();
  }


  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  

  num _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
  length: 2,
  child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 105, 53, 9),
        elevation: 0,
       leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color.fromARGB(255, 105, 53, 9),
          onPressed: () {
           
          },
        ),
        title: Text("Buyers Requests"),
      
       bottom: TabBar(
        isScrollable: true,
        tabs: [
          Tab(text: "Cocoa"),
          Tab(text: "Tools and Algrochem."),
        ],
      ),

        ),
      body: TabBarView(
        children: [
         
      //Registered
      Stack(
        children: <Widget>[
          
           Column(
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

        SizedBox(height: 5,),

        Center(child: Text("Select Buyer to chat"),),

        SizedBox(height: 5),

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
                                        chatpage(
                                          seller_email: _resultsList1[index]["seller_email"],
                                         user_email: _resultsList1[index]["user_email"],
                                         user_name: _resultsList1[index]["user_name"],
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

                                child: Image.network(_resultsList1[index]["user_image"],height: MediaQuery.of(context).size.width*0.3,width: MediaQuery.of(context).size.width*0.3,
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
                                                  Text(_resultsList1[index]["user_name"], style: TextStyle(fontWeight: FontWeight.w500,fontFamily: 'Roboto-Black'),)
                                                ],
                                              ),

                                             SizedBox(height:10.0),

                                              Text('${_resultsList1[index]["user_location"]}',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black54),),
                                              
                                              SizedBox(height:10.0),

                                              Text('${_resultsList1[index]["user_contact"]}',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black26),),

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
          else if(selectedPos==0){
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen(
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

      //Unregistered
      Stack(
        children: <Widget>[
           Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Padding(
          padding: EdgeInsets.only(left: 30, right: 30, bottom: 10),
          child: TextField(
            controller: _searchController2,
            decoration: InputDecoration(
              label: Text("Search"),
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),

        SizedBox(height: 5,),

        Center(child: Text("Select Request to chat"),),

        SizedBox(height: 5),

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
          child: _resultsList2.isEmpty ? Center(child: CircularProgressIndicator())
              :ListView.builder(
            itemCount: _resultsList2.length,
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
                    /*Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProductDetail(
                                          image: _resultsList[index]["image"],
                                          name: _resultsList[index]["name"],
                                          price: _resultsList[index]["price"],
                                          description: _resultsList[index]["description"],
                                          category: _resultsList[index]["category"],
                                        ),
                                  ));*/
                    },
                      title:  SizedBox(
                        height: MediaQuery.of(context).size.height*0.17,
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
                                     child: Image.network(_resultsList2[index]["image"],
                                     fit: BoxFit.fill,
                                        ),                  
                              ),
                                ),
                                );
                                },
                                child: new Container(

                                child: Image.network(_resultsList2[index]["image"],height: MediaQuery.of(context).size.width*0.3,width: MediaQuery.of(context).size.width*0.3,
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
                                                  Text(_resultsList2[index]["name"], style: TextStyle(fontWeight: FontWeight.w500,fontFamily: 'Roboto-Black'),)
                                                ],
                                              ),

                                             SizedBox(height:5.0),

                                              Text('Quantity : ${_resultsList2[index]["qty"]}',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black54),),
                                              
                                              SizedBox(height:5.0),

                                              Text('Price : GHc ${_resultsList2[index]["totalprice"]}',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black45),),

                                              SizedBox(height:5.0),

                                              Text('From : ${_resultsList2[index]["user_name"]}',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black26),),

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
          else if(selectedPos==0){
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen(
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
      ])

          )
    );
  }

 
}
