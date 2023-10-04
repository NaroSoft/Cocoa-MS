import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocoa_system/Models/Product.dart';
import 'package:cocoa_system/Screens/details/components/body.dart';
import 'package:cocoa_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class DetailsScreen extends StatefulWidget {
  String product_image,category,name,description,price,user_email,user_name,user_contact,user_location,
  seller_email, seller_name;
  DetailsScreen({
    Key key, this.product_image,this.category, this.name, this.price, this.description, this.user_email,
    this.user_contact,this.user_location,this.user_name,this.seller_email,this.seller_name
  }) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {


  int numOfItems = 1;
  String totalprice="0.0";
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    totalprice=widget.price;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 253, 236, 224),
      appBar: AppBar(
      backgroundColor: Color.fromARGB(255, 99, 72, 54),
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset('assets/icons/back.svg', color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        //IconButton(
          //  icon: SvgPicture.asset("assets/icons/search.svg"),
            //onPressed: () {}),
        IconButton(
            icon: SvgPicture.asset("assets/icons/cart.svg"), onPressed: () {}),
        SizedBox(
          width: kDefaultPadding,
        )
      ],
    ),
      body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.3),
                  padding: EdgeInsets.only(
                    top: size.height * 0.05,
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                  ),
                  //height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                   
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: Text(widget.description,
                          style: TextStyle(height: 1.5),
                        ),
                      ),
                      //SizedBox(height: kDefaultPadding / 2),
                      
                      
                      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        
        Row(
      children: <Widget>[
        SizedBox(
      width: 40,
      height: 32,
      child: FlatButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        onPressed: () {
            if (numOfItems > 1) {
              var b;
          var c = widget.price;
              setState(() {
                numOfItems=numOfItems-1;
                b=double.tryParse(c)*numOfItems;
              totalprice=b.toString();
              });
            }
          },
        child: Icon(Icons.remove),
      ),
    ),
       
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Text(
            numOfItems.toString(),
            style: Theme.of(context).textTheme.headline6,
          ),
        ),

        SizedBox(
      width: 40,
      height: 32,
      child: FlatButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        onPressed: () {
          var a = numOfItems+1;
          var b;
          var c = widget.price;
            print(a);
            setState(() {
              numOfItems=a;
              b=double.tryParse(c)*numOfItems;
              totalprice=b.toString();
            });
          },
        child: Icon(Icons.add),
      ),
    ),
       
      ],
    ),


        Container(
          padding: EdgeInsets.all(8),
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: Color(0xFFFF6464),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset("assets/icons/heart.svg"),
        )
      ],
    ),


                      SizedBox(height: kDefaultPadding / 2),

                         Row(
      children: <Widget>[
        /*Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Colour"),
              Row(
                children: <Widget>[
                  ColorDot(
                    color: Color(0xFF356C96),
                    isSelected: true,
                  ),
                  ColorDot(color: Color(0xFFF8C078)),
                  ColorDot(color: Color(0xFFA29B9B)),
                ],
              )
            ],
          ),
        ),*/

        SizedBox(height: kDefaultPadding / 2),

        Expanded(
                child: RichText(
                  text: TextSpan(style: TextStyle(color: kTextColor), children: [
                    TextSpan(
                      text: "Total Price\n",
                    ),
                    TextSpan(
                      text: "GH₵ ${totalprice}",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.bold),
                    )
                  ]),
                ),
              )
            ],
          ),

                      SizedBox(height: kDefaultPadding / 2),


                      
                      Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: kDefaultPadding),
            height: 50,
            width: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.brown),
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                "assets/icons/add_to_cart.svg",
               // color: product.color,
              ),
              onPressed: () {},
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: Colors.brown,
                onPressed: () async{
                if(_isLoading) return;

                setState(() => _isLoading = true);

               // await Future.delayed(Duration(seconds: 3));

              FocusScope.of(context).unfocus();
          
                                  // _uploadPost(_image, _stdNameController.text, _stdPhoneController.text,_stdCourseController,_stdLocController.text,_gudNameController.text,_gudRelController.text,_gudPhoneController.text);

                  //TODO: FirebaseFirestore create a new record code


                  Map<String, dynamic> productData = new Map<String,dynamic>();

                  setState(() {
                  _isLoading = true;
                  });

                var now= new DateTime.now();
                var formatter=new DateFormat('dd-MM-yyyy hh:mm a');
                String formatdate = formatter.format(now);
                var date_to_be_added=[formatdate];
                 
                  productData["uid"] = '${widget.user_email}_${widget.seller_email}';
                  productData["name"] = widget.name;
                  productData["price"] = widget.price;
                  productData["qty"] = numOfItems;
                  productData["totalprice"] = totalprice;
                  productData["user_email"] = widget.user_email;
                  productData["user_name"] = widget.user_name;
                  productData["user_contact"] = widget.user_contact;
                  productData["user_location"] = widget.user_location;
                  productData["category"] = widget.category;
                  productData["image"] = widget.product_image;

                  productData["seller_name"] = widget.seller_name;
                  productData["seller_email"] = widget.seller_email;
                 
                  FirebaseFirestore.instance
                      .collection('Orders').add(productData)
                      .whenComplete((){
                  setState(() => _isLoading = false);
                  
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(text: widget.text,text2: widget.house)));
                    Navigator.pop(context);
                  } );

              
            },
                child: _isLoading
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white,),
                const SizedBox(width: 24),
                Text("Please Wait....")
              ],
            )
            : Text(
                  "Buy Now".toUpperCase(),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
                    ],
                  ),
                ),
                
                
                Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.category,
            style: TextStyle(color: Color.fromARGB(255, 22, 21, 21)),
          ),
          Text(widget.name,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Color.fromARGB(255, 22, 22, 22), fontWeight: FontWeight.bold),
          ),
          SizedBox(height: kDefaultPadding),
          Row(
            children: <Widget>[
              RichText(
                text: TextSpan(children: [
                  TextSpan(text: "Price :",style: TextStyle(color: Colors.black)),
                  TextSpan(
                    text: "\GH₵ ${widget.price}",
                    style: Theme.of(context).textTheme.headline4.copyWith(
                        color: Color.fromARGB(255, 109, 89, 89), fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              SizedBox(width: kDefaultPadding),
              Expanded(
                child: Hero(
                tag: widget.name,
                  child: Image.network(widget.product_image,
                                     fit: BoxFit.fill,
                  ),  
                ),
              )
            ],
          )
        ],
      ),
    ),

              ],
            ),
          )
        ],
      ),
    ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      //backgroundColor: product.color,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset('assets/icons/back.svg', color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        IconButton(
            icon: SvgPicture.asset("assets/icons/search.svg"),
            onPressed: () {}),
        IconButton(
            icon: SvgPicture.asset("assets/icons/cart.svg"), onPressed: () {}),
        SizedBox(
          width: kDefaultPadding,
        )
      ],
    );
  }
}
