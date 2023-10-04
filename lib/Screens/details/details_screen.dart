import 'package:cocoa_system/Models/Product.dart';
import 'package:cocoa_system/Screens/details/components/body.dart';
import 'package:cocoa_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



class DetailsScreen extends StatefulWidget {
  DetailsScreen({
    Key key,
  }) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {


  int numOfItems = 1;


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: product.color,
      appBar: AppBar(
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
                    top: size.height * 0.12,
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
        Expanded(
                child: RichText(
                  text: TextSpan(style: TextStyle(color: kTextColor), children: [
                    TextSpan(
                      text: "Size\n",
                    ),
                    TextSpan(
                      text: "20 cm",
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
                        padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPadding,
                        ),
                        child: Text("Product description here",
                          style: TextStyle(height: 1.5),
                        ),
                      ),
                      SizedBox(height: kDefaultPadding / 2),
                      
                      
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
              setState(() {
                numOfItems--;
              });
            }
          },
        child: Icon(Icons.remove),
      ),
    ),
       
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Text(
            numOfItems.toString().padLeft(2, "0"),
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
            if (numOfItems > 1) {
              setState(() {
                numOfItems++;
              });
            }
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
            "Aristocratic Bag",
            style: TextStyle(color: Color.fromARGB(255, 22, 21, 21)),
          ),
          Text("Product Name",
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
                    text: "\GHc 200",
                    style: Theme.of(context).textTheme.headline4.copyWith(
                        color: Color.fromARGB(255, 109, 89, 89), fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              SizedBox(width: kDefaultPadding),
              Expanded(
                child: Hero(
                  tag: "Product ID",
                  child: Image.asset(
                   "assets/images/bag_1.png",
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
