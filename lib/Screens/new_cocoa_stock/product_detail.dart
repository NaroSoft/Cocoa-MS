import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocoa_system/Screens/product/image_update.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';


class Cocoatock extends StatefulWidget {
  final String image,name,price,description,category;
  Cocoatock({Key key,this.image,this.name,this.category,this.description,this.price}) : super(key: key);
  static const routeName = '/addBlogPage';
  @override
  _CocoatockState createState() => _CocoatockState();
}

class _CocoatockState extends State<Cocoatock> {

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
    _pdtNameController.text=widget.name;
  _pdtPriceController.text=widget.price;
  _pdtDescribeController.text=widget.description;
   _pdtCategoryController=widget.category;
   productimage=widget.image;
   textFromSecondScreen=widget.image;
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
        padding: EdgeInsets.only(top: 40.0, left: 25.0, right: 25.0),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
           
            SizedBox(height: 20.0),
            Center(child: Text("Available Cocoa Stock",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,),),),
            SizedBox(height: 50.0,),
            Text("Qty Number (Bags)"),
            SizedBox(height: 10,),
            Container(
              child: TextFormField(
                style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold,),
                controller: _pdtNameController,
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
                  labelText: '0',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 97, 94, 94), fontSize: 16.0),
                ),
              ),
            ),

            SizedBox(height: 20.0),

              
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
           
             if (_pdtNameController.text.isEmpty) {
              setState(() => _isLoading = false);
               _mostrarAlert('Error', 'Product Name is Blanck');
             } else {
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
                  productData["name"] = _pdtNameController.text;
                  productData["price"] = _pdtPriceController.text;
                  productData["category"] = _pdtCategoryController;
                  productData["description"] = _pdtDescribeController.text;
                 
                  FirebaseFirestore.instance
                      .collection('Products').doc(_pdtNameController.text)
                      .update(productData)
                      .whenComplete((){
                  setState(() => _isLoading = false);
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(text: widget.text,text2: widget.house)));
                    Navigator.pop(context);
                  } );

                }
                   
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
            : Text("Update Product".toUpperCase(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white,)
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
