import 'package:cocoa_system/Models/Product.dart';
import 'package:cocoa_system/Screens/product/add_product.dart';
import 'package:cocoa_system/Screens/product/components/categories.dart';
import 'package:cocoa_system/Screens/product/components/item_card.dart';
import 'package:cocoa_system/Screens/product/product_detail.dart';
import 'package:cocoa_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';



class ProductHomeScreen extends StatefulWidget {
  String user_email,user_contact,user_name;
  ProductHomeScreen({
    Key key, this.user_email, this.user_contact, this.user_name,
  }) : super(key: key);

  @override
  _ProductHomeScreenState createState() => _ProductHomeScreenState();
}

class Trip {
  final String name;
  final DocumentReference reference;

  Trip.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.data() as Map<String, dynamic>,
          reference: snapshot.reference,
        );

  Trip.fromMap(
    Map<String, dynamic> map, {
    @required this.reference,
  })  : name = map['name'];
        

  @override
  String toString() => 'Post<$name>';
}

class _ProductHomeScreenState extends State<ProductHomeScreen> {


int selectedPos = 3;

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
      var data = await FirebaseFirestore.instance.collection('Products').where('seller_email', isEqualTo: widget.user_email).get();
      setState(() {
        _allResults= data.docs;
      });
      searchResultsList();
      return "complete";
    }


  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }


    @override
  void dispose() {
    super.dispose();
     _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
  }


  int _selectedIndex = 2;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 105, 53, 9),
        elevation: 0,
       leading: IconButton(
        icon: SvgPicture.asset('assets/icons/back.svg', color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
        title: Text("My Products"),
        centerTitle: true,
        actions: <Widget>[
          
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AddProduct(
                                          user_email: widget.user_email,
                                          user_contact: widget.user_contact,
                                          user_name: widget.user_name,
                                        ),
                                  ));
            },
          )
        ]
        ),
      body: Stack(
        children: <Widget>[
          Padding(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Padding(
          padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
          child: TextField(
            controller: _searchController,
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
          child: ListView.builder(
            itemCount: _resultsList.length,
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
                                        ProductDetail(
                                          image: _resultsList[index]["image"],
                                          name: _resultsList[index]["name"],
                                          price: _resultsList[index]["price"],
                                          description: _resultsList[index]["description"],
                                          category: _resultsList[index]["category"],
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
                                     child: Image.network(_resultsList[index]["image"],
                                     fit: BoxFit.fill,
                                        ),                  
                              ),
                                ),
                                );
                                },
                                child: new Container(

                                child: Image.network(_resultsList[index]["image"],height: MediaQuery.of(context).size.width*0.3,width: MediaQuery.of(context).size.width*0.3,
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
                                              
                                              Text(_resultsList[index]["name"], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0,fontFamily: 'Roboto-Black'),),
                                               

                                             SizedBox(height:20.0),

                                              Text('GH₵ ${_resultsList[index]["price"]}',style: TextStyle(fontWeight: FontWeight.w700,fontSize:18.0,color: Colors.black26),),

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

            padding: EdgeInsets.only(bottom: bottomNavBarHeight),
          ),
          
          /*Align(
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
            context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
            
          }
         
          //print(_navigationController.value);
        });
      },
    ),
            ),*/
        ],
      ),
    );
  }

 
}
