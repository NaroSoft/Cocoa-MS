import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocoa_system/Screens/product/image_update.dart';
import 'package:cocoa_system/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';


class ProductDetail extends StatefulWidget {
  final String product_image,name,price,description,category;
  ProductDetail({Key key,this.product_image,this.name,this.category,this.description,this.price}) : super(key: key);
  static const routeName = '/addBlogPage';
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {

  TextEditingController _pdtNameController = TextEditingController();
  TextEditingController _pdtPriceController = TextEditingController();
  TextEditingController _pdtDescribeController = TextEditingController();

    int numOfItems = 1;
  String totalprice="0.0";

   @override
  void initState() {
    super.initState();
    _pdtNameController.text=widget.name;
  _pdtPriceController.text=widget.price;
  _pdtDescribeController.text=widget.description;
  totalprice=widget.price;
 
  }


    @override
  void dispose() {
    super.dispose();
    _pdtNameController.dispose();
  _pdtPriceController.dispose();
  _pdtDescribeController.dispose();
   
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
        icon: SvgPicture.asset('assets/icons/back.svg', color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
        backgroundColor: Color.fromARGB(255, 105, 53, 9),
        centerTitle: true,
        title: Text('Product Detail',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
         actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],

        // backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,

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
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
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
                onPressed: () {},
                child: Text(
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
                  TextSpan(text: "Price :"),
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

void _mostrarAlert(String title, String message){
  AlertDialog alertDialog=AlertDialog(
    title: Text(title),
    content: Text(message),
  );
  showDialog(context: context,builder: (_)=>alertDialog);
}
}
