import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocoa_system/Screens/product/image_update.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';


class CocoaStockUpdate extends StatefulWidget {
  final String user_image, user_contact, user_location, user_email,user_name,cocoa_qty;
  CocoaStockUpdate({Key key,this.user_contact,this.user_email,this.user_image,this.user_location,this.user_name,this.cocoa_qty}) : super(key: key);

    @override
  _CocoaStockUpdateState createState() => _CocoaStockUpdateState();
}

class _CocoaStockUpdateState extends State<CocoaStockUpdate> {

  TextEditingController _pdtNameController = TextEditingController();
  TextEditingController _pdtPriceController = TextEditingController();
  TextEditingController _pdtDescribeController = TextEditingController();


  String _pdtCategoryController='Tools';
  String textFromSecondScreen='';

  bool _isLoading = false;
  String _blogId = '';
  int _value = 1;

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,);
    File compressedFile = await FlutterNativeImage.compressImage(pickedFile.path,
      quality: 25,);
    setState(() {
     // _image = File(pickedFile.path);
      _image=compressedFile;
    });
  }

  Future getImages() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera,);
    File compressedFile = await FlutterNativeImage.compressImage(pickedFile.path,
      quality: 25,);
    setState(() {
     // _image = File(pickedFile.path);
      _image=compressedFile;
    });
  }

  Future<File> compressFile(File file) async{
    File compressedFile = await FlutterNativeImage.compressImage(file.path,
      quality: 5,);
    _image=compressedFile;
    return _image;
  }

  String productimage='';

   @override
  void initState() {
    super.initState();
   
  _pdtPriceController.text=widget.cocoa_qty;
 
  }


    @override
  void dispose() {
    super.dispose();
  
  _pdtPriceController.dispose();

   
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
        title: Text('Cocoa Stocking',
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
           
            SizedBox(height: 20.0),
            Center(child: Text("Available Cocoa Number",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,),),),
            SizedBox(height: 50.0,),
            Text("Quantity (Bags)"),
            SizedBox(height: 10,),
            Container(
              child: TextFormField(
                style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold,),
                controller: _pdtPriceController,
                cursorColor: Colors.blueAccent,
                keyboardType: TextInputType.text,
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
                  labelText: widget.cocoa_qty,
                  labelStyle: TextStyle(color: Color.fromARGB(255, 97, 94, 94), fontSize: 16.0),
                ),
              ),
            ),

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
           
             if (_pdtPriceController.text.isEmpty) {
              setState(() => _isLoading = false);
               _mostrarAlert('Error', 'Cocoa Qty is Blanck');
             }              // _uploadPost(_image, _stdNameController.text, _stdPhoneController.text,_stdCourseController,_stdLocController.text,_gudNameController.text,_gudRelController.text,_gudPhoneController.text);

                  //TODO: FirebaseFirestore create a new record code


                  Map<String, dynamic> productData = new Map<String,dynamic>();

                  setState(() {
                  _isLoading = true;
                  });

                  //Reference ref = await FirebaseStorage.instance.ref().child("product_image").child(_image.uri.toString() + ".jpg");
                 // UploadTask uploadTask = ref.putFile(_image);
                 // String downloadUrl = await (await uploadTask).ref.getDownloadURL();

                  productData["cocoa_qty"] = _pdtDescribeController.text;
                 
                  FirebaseFirestore.instance
                      .collection('Cocoa_Sellers').doc(widget.user_email)
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
                Text("Please Wait....")
              ],
            )
            : Text("Update Stock".toUpperCase(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white,)
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
