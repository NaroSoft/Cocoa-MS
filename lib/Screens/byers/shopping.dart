import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocoa_system/Screens/byers/buy_home_screen.dart';
import 'package:cocoa_system/Screens/byers/details_screen.dart';
import 'package:cocoa_system/Screens/byers/myorders.dart';
import 'package:cocoa_system/Screens/byers/setting.dart';
import 'package:cocoa_system/Screens/byers/video.dart';
import 'package:cocoa_system/Screens/product/product_home.dart';
import 'package:cocoa_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';



class ShoppingScreen extends StatefulWidget {
  String user_name,user_contact,user_image,user_location,user_email;
  ShoppingScreen({
    Key key, this.user_contact,this.user_image,this.user_location,this.user_name,this.user_email
  }) : super(key: key);

  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {

 List<String> categories = [
    "All Products",
    "Tools",
    "Agrochemical",
    "Other Product",
    
  ];

 


int selectedPos = 1;
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

    Future resultsLoaded;
    List _allResults=[];
    List _resultsList =[];

   @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      resultsLoaded= getUsersPastTripsStreamSnapshots();
    }

    _onSearchChanged(){
      searchResultsList();
      print(_searchController.text);
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


    getUsersPastTripsStreamSnapshots() async{
      //final uid = await Provider.of(context).au
      var data = await FirebaseFirestore.instance.collection('Products').get();
      setState(() {
        _allResults= data.docs;
      });
      searchResultsList();
      return "complete";
    }


  @override
  void initState() {
    super.initState();
     _navigationController = CircularBottomNavigationController(selectedPos);
    _searchController.addListener(_onSearchChanged);
  }


    @override
  void dispose() {
    super.dispose();
     _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _navigationController.dispose();
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
        title: Text("Shopping"),
        centerTitle: true,

       actions: <Widget>[
        //IconButton(
          //  icon: SvgPicture.asset("assets/icons/search.svg"),
            //onPressed: () {}),
        IconButton(
            icon: SvgPicture.asset("assets/icons/cart.svg"), onPressed: () {
              print(widget.user_email);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> MyOrdersScreen(
                user_email: widget.user_email,user_name: widget.user_name
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
       
       //SizedBox(height: 10,),
        
        Container(
            color: Color.fromARGB(255, 235, 220, 215),
          child:Padding(
          padding: EdgeInsets.only(left: 30, right: 30, bottom: 10),
          child: TextField(
            style: TextStyle(color: Color.fromARGB(255, 73, 41, 29),fontWeight: FontWeight.bold),
            controller: _searchController,
            decoration: InputDecoration(
              iconColor: Colors.brown,
              label: Text("Search",style: TextStyle(color: Colors.brown)),
              prefixIcon: Icon(Icons.search,color: Colors.brown,),
            ),
          ),
        ),
          ),

      Divider(color: Colors.black54,),
      Center(
        child: Text("Tools and Agrochemicals",
          style: TextStyle(fontSize: 20),
          ),
        ),
       
        Divider(color: Colors.black54,),
        Expanded(
          child: Container(
            color: Color.fromARGB(255, 235, 220, 215),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20,10,20,10),
            child: _resultsList.isEmpty ? Center(child: CircularProgressIndicator()) : GridView.builder(
              itemCount: _resultsList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.80,
              ),
              itemBuilder: (context, index){
                 return GestureDetector(
                      onTap: (){
                            Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailsScreen(
                                          user_name: widget.user_name,
                                          user_contact: widget.user_contact,
                                          user_location: widget.user_location,
                                          user_email: widget.user_email,
                                          product_image: _resultsList[index]["image"],
                                          category: _resultsList[index]["category"],
                                          name: _resultsList[index]["name"],
                                          description: _resultsList[index]["description"],
                                          price: _resultsList[index]["price"],

                                          seller_email: _resultsList[index]["seller_email"],
                                          seller_name: _resultsList[index]["seller_name"],
                                        ),
                                  ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              //padding: EdgeInsets.all(kDefaultPadding),
              height: 180,
              width: 160,
              decoration: BoxDecoration(
                //color: Colors.red,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Image.network(_resultsList[index]["image"],
                                     fit: BoxFit.cover,
                                
              ),
            ),
          ),
          
          Center(
            child: Text(
              //Product List in Demo List
              _resultsList[index]["name"],
              style: TextStyle(color: kTextColor),
            ),
            ),
          Divider(color: Colors.black,),

          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Price :"
                ),
              TextSpan(
                text: " GH₵ ${_resultsList[index]["price"]}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ]
              ),),

          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Categ :"
                ),
              TextSpan(
                text: " ${_resultsList[index]["category"]}",
              )
              ]
            )
          ),

          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Seller :"
                ),
              TextSpan(
                text: " ${_resultsList[index]["seller_name"]}",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
              ]
            )
          ),
        ],
      ),
                 );
    
            },
          )
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
          else if(selectedPos==0){
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => BuyHomeScreen(
              user_name: widget.user_name,
              user_image: widget.user_image,
              user_contact: widget.user_contact,
              user_location: widget.user_location,
            )));
            
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
