import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocoa_system/Screens/product/image_update.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';


class CocoaDetail extends StatefulWidget {
  final String price,status,date;
  CocoaDetail({Key key,this.price,this.status,this.date}) : super(key: key);
  static const routeName = '/addBlogPage';
  @override
  _CocoaDetailState createState() => _CocoaDetailState();
}

class _CocoaDetailState extends State<CocoaDetail> {

  TextEditingController _priceController = TextEditingController();
  TextEditingController _dateController = TextEditingController();


  String _statusController='Opened';

  bool _isLoading = false;
  String _blogId = '';
  int _value = 1;

 

   @override
  void initState() {
    super.initState();
    _priceController.text=widget.price;
  _statusController=widget.status;
  _dateController.text=widget.date;
  if (widget.status=="Opened"){
    _value=1;
  }
  else{
    _value=2;
  }
  }


    @override
  void dispose() {
    super.dispose();
    _priceController.dispose();
  _dateController.dispose();
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
        icon: SvgPicture.asset('assets/icons/back.svg', color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
        backgroundColor: Color.fromARGB(255, 105, 53, 9),
        centerTitle: true,
        title: Text('Cocoa Info Update',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        
        // backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 40.0, left: 25.0, right: 25.0),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         
            Text("Current Cocoa Price (GH₵)"),
            SizedBox(height: 10,),
            Container(
              child: TextFormField(
                style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold,),
                controller: _priceController,
                cursorColor: Colors.blueAccent,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.brown,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.brown,
                    ),
                  ),
                  labelText: widget.price,
                  labelStyle: TextStyle(color: Color.fromARGB(255, 97, 94, 94), fontSize: 16.0),
                ),
              ),
            ),

            SizedBox(height: 20.0),

               Text("Opening Date"),
            SizedBox(height: 10,),
            Container(
              child: TextFormField(
                readOnly: true,
                onTap: () async{
                  var date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2021),
              lastDate: DateTime(2100));
          setState(() {
            //selectedDate = date!;
            _dateController.text= new DateFormat("MMM. dd, yyyy").format(date);
            //String Onlymonth = new DateFormat("MMMM, yyyy").format(date);
            //String Onlyday = new DateFormat("EEEE - dd").format(date);

          });
                },
                style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold,),
                controller: _dateController,
                cursorColor: Color.fromARGB(255, 206, 219, 243),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.brown,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.brown,
                    ),
                  ),
                  labelText: widget.date,
                  labelStyle: TextStyle(color: Color.fromARGB(255, 97, 94, 94), fontSize: 16.0),
                ),
              ),
            ),

            SizedBox(height: 20,),

      Row(children: [
        Text("Select Status: ",style: TextStyle(fontSize: 17.0,color: Colors.brown),),
        SizedBox(width: 10.0,),
        DropdownButton(
            dropdownColor: Color.fromARGB(255, 248, 234, 229),
            value: _value,
            items: [
              DropdownMenuItem(
                child: Text("Opened",style: TextStyle(fontSize: 17.0,),),
                value: 1,
              ),
              DropdownMenuItem(
                child: Text("Closed",style: TextStyle(fontSize: 17.0),),
                value: 2,
              ),
            

            ],
            onChanged: (value) {
              setState(() {
                _value = value;
                if(value==1){
                  _statusController="Opened";
                }
                else {
                  _statusController="Closed";
                }
                
              });
            }),

      ],),
            SizedBox(height: 20.0),

        
             Align(
              alignment: Alignment.bottomCenter,
              child:SizedBox(
              height: 50,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: Color.fromARGB(255, 70, 40, 31),
                onPressed: () async{
                if(_isLoading) return;

                setState(() => _isLoading = true);

                //await Future.delayed(Duration(seconds: 3));

              FocusScope.of(context).unfocus();
           
             if (_priceController.text.isEmpty) {
              _priceController.text=widget.price;
             } 
               if (_dateController.text.isEmpty) {
                _dateController.text=widget.date;
               } 
               
                                  // _uploadPost(_image, _stdNameController.text, _stdPhoneController.text,_stdCourseController,_stdLocController.text,_gudNameController.text,_gudRelController.text,_gudPhoneController.text);

                  //TODO: FirebaseFirestore create a new record code


                  Map<String, dynamic> productData = new Map<String,dynamic>();

                  setState(() {
                  _isLoading = true;
                  });

                  //Reference ref = await FirebaseStorage.instance.ref().child("product_image").child(_image.uri.toString() + ".jpg");
                 // UploadTask uploadTask = ref.putFile(_image);
                 // String downloadUrl = await (await uploadTask).ref.getDownloadURL();

                  //productData["image"] = downloadUrl;
                  productData["date"] = _dateController.text;
                  productData["amount"] = _priceController.text;
                  productData["status"] = _statusController;
                 
                 
                  FirebaseFirestore.instance
                      .collection('Cocoa').doc("info")
                      .update(productData)
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
                Text("Please Wait....",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white,))
              ],
            )
            : Text("Update Cocoa Info".toUpperCase(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white,)
            ),
            
              ),
            ),
        ),
           
        
          SizedBox(height: 10,),
       
            /*SizedBox(height: 20.0),
            _isLoading ? Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: Center(
                child: LinearProgressIndicator(minHeight: 5.0),
              ),
            ) : Container(width: 0.0, height: 0.0)*/
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
