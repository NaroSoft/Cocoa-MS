import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocoa_system/Screens/admin/admin_home.dart';
import 'package:cocoa_system/Screens/product/product_home.dart';
import 'package:cocoa_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';

import '../Messages/chatpage.dart';
import '../byers/setting.dart';
import '../byers/video.dart';
import '../details/details_screen.dart';


class CocoaOrdersScreen extends StatefulWidget {
  String user_name,user_contact,user_image,user_location,user_email;
  CocoaOrdersScreen({
    Key key, this.user_contact,this.user_image,this.user_location,this.user_name,this.user_email
  }) : super(key: key);

  @override
  _CocoaOrdersScreenState createState() => _CocoaOrdersScreenState();
}

class _CocoaOrdersScreenState extends State<CocoaOrdersScreen> {




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
      var data = await FirebaseFirestore.instance.collection('Cocoa_Orders').where('user_email',isEqualTo: widget.user_email).get();
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
    //_navigationController.dispose();
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
        title: Text("My Orders"),
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
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Padding(
          padding: EdgeInsets.only(left: 30, right: 30, bottom: 10),
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
        SizedBox(height: 5,),
        Center(child: Text("Select A Request to chat Seller")),
        SizedBox(height: 5,),
        Expanded(
          child: _resultsList.isEmpty ? Center(child: CircularProgressIndicator())
              :ListView.builder(
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
                                        chatpage(
                                          seller_email: _resultsList[index]["seller_email"],
                                         user_email: _resultsList[index]["user_email"],
                                         user_name: _resultsList[index]["user_name"],
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
                                     child: Image.network(_resultsList[index]["seller_image"],
                                     fit: BoxFit.fill,
                                        ),                  
                              ),
                                ),
                                );
                                },
                                child: new Container(

                                child: Image.network(_resultsList[index]["seller_image"],height: MediaQuery.of(context).size.width*0.3,width: MediaQuery.of(context).size.width*0.3,
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
                                                  Text(_resultsList[index]["seller_name"], style: TextStyle(fontWeight: FontWeight.w500,fontFamily: 'Roboto-Black'),)
                                                ],
                                              ),

                                             SizedBox(height:10.0),

                                              Text('Quantity:  ${_resultsList[index]["cocoa_qty"]}',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black54),),
                                              
                                              SizedBox(height:10.0),

                                              Text('Location: ${_resultsList[index]["seller_location"]}',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black26),),

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
        
            padding: EdgeInsets.only(bottom: 30),
          ),
      

       
        ],
      ),
    );
  }
  
}
