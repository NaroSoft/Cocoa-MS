import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocoa_system/Screens/details/details_screen.dart';
import 'package:cocoa_system/Screens/home/components/body.dart';
import 'package:cocoa_system/Screens/product/product_home.dart';
import 'package:cocoa_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';


class HomeScreens extends StatefulWidget {
  HomeScreens({
    Key key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreens> {

 List<String> categories = [
    "All Products",
    "Tools",
    "Agrochemical",
    "Other Product",
    
  ];

int selectedPos = 0;
int selectedIndex = 0;

  double bottomNavBarHeight = 50;

  List<TabItem> tabItems = List.of([
    TabItem(Icons.home, "Home", Colors.brown, 
        labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
    TabItem(Icons.search, "Search", Colors.brown,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Text(
            "Available Products",
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
       
       
        //Categories,
        Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: SizedBox(
        height: 25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index){
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text(
              categories[index],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selectedIndex == index ? Colors.brown : kTextLightColor),
            ),
            ),
            
            Container(
              margin: EdgeInsets.only(top: kDefaultPadding / 4),
              height: 2,
              width: 40,
              color: selectedIndex == index ? Colors.brown : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
        ),
      ),
    ),



        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Products').snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              :GridView.builder(
              itemCount: snapshot.data.docs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: kDefaultPadding,
                crossAxisSpacing: kDefaultPadding,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index){
                 return GestureDetector(
      onTap: (){
            Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailsScreen(),
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
              child: Hero(
                tag: "${snapshot.data.docs[index]["name"]}",
                //child: Image.asset(product.image),
                child: Image.network(snapshot.data.docs[index]["image"],
                                     fit: BoxFit.cover,
                  ),                
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
            child: Text(
              //Product List in Demo List
              snapshot.data.docs[index]["name"],
              style: TextStyle(color: kTextColor),
            ),
          ),
          Text(
            "\  GH₵${snapshot.data.docs[index]["price"]}",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
              }
              
              /*ItemCard(
                product: products[index],
                press: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        product: products[index],
                      ),
                    )),
              ),*/
              
            );
        }
          ),
          ),
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
      barHeight: bottomNavBarHeight,
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
            context, MaterialPageRoute(builder: (BuildContext context) => ProductHomeScreen()));
            
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
