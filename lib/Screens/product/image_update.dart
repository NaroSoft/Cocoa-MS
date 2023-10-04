import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';


class ImageUpdate extends StatefulWidget {
  final String image;
  final String name;
  ImageUpdate({Key key,this.name,this.image}) : super(key: key);
  static const routeName = '/addBlogPage';
  @override
  _ImageUpdateState createState() => _ImageUpdateState();
}

class _ImageUpdateState extends State<ImageUpdate> {

  TextEditingController _pdtNameController = TextEditingController();
  TextEditingController _pdtPriceController = TextEditingController();
  TextEditingController _pdtDescribeController = TextEditingController();


  String _pdtCategoryController='Tools';

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       leading: IconButton(
        icon: SvgPicture.asset('assets/icons/back.svg', color: Colors.white),
        onPressed: () => Navigator.pop(context, widget.image),
      ),
        backgroundColor: Color.fromARGB(255, 105, 53, 9),
        centerTitle: true,
        title: Text('Image Update',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        /* actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_b_and_w,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],*/

        // backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 40.0, left: 25.0, right: 25.0),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Center(child:Text("Product Image")),
            SizedBox(height: 10.0),
            _image == null ? Container(
              color: Color.fromARGB(255, 250, 239, 234),
              width: MediaQuery.of(context).size.width, height: 300.0) : ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image(
                width: MediaQuery.of(context).size.width,
                height: 300.0,
                image: FileImage(_image),
                //color: Colors.blueGrey,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
            SizedBox(height: 20.0),

            Row(
              children: [
                SizedBox(width: 100.0,),
              FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 66, 45, 24),
                  child: Icon(Icons.camera_alt,color: Colors.white,),
                  heroTag: 1,
                  onPressed: (){
                   getImages();
                  }),

                SizedBox(width: 20.0,),
                FloatingActionButton(
                    backgroundColor: Color.fromARGB(255, 109, 84, 38),
                    child: Icon(Icons.add_photo_alternate_outlined,color: Colors.white,),
                    heroTag: 2,
                    onPressed: (){
                      getImage();
                    }),

              ],),

            SizedBox(height: 40.0),
           
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
              primary: Color.fromARGB(255, 70, 40, 31),
              
              ),
            
              onPressed: () async{
                if(_isLoading) return;

                setState(() => _isLoading = true);

                await Future.delayed(Duration(seconds: 3));

              FocusScope.of(context).unfocus();
           
               if (_image == null) {
                 _mostrarAlert('Error', 'Pruduct image is Blanck');
               } else {
                
                //Delete old image from firebase
                Reference photoRef =await FirebaseStorage.instance.refFromURL(widget.image);
                await photoRef.delete().then((value) async{
                  print('deleted Successfully');
                
                 // _uploadPost(_image, _stdNameController.text, _stdPhoneController.text,_stdCourseController,_stdLocController.text,_gudNameController.text,_gudRelController.text,_gudPhoneController.text);

                  //TODO: FirebaseFirestore create a new record code


                  Map<String, dynamic> productData = new Map<String,dynamic>();

                  setState(() {
                  _isLoading = true;
                  });

                  Reference ref = await FirebaseStorage.instance.ref().child("product_image").child(_image.uri.toString() + ".jpg");
                  UploadTask uploadTask = ref.putFile(_image);
                  String downloadUrl = await (await uploadTask).ref.getDownloadURL();

                  productData["image"] = downloadUrl;
                 
                  FirebaseFirestore.instance
                      .collection('Products').doc(widget.name)
                      .update(productData)
                      .whenComplete((){
                  setState(() => _isLoading = false);
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(text: widget.text,text2: widget.house)));
                    Navigator.pop(context, downloadUrl);
                  } );

                  });

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
            : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.update),
                Text("Proceed",style: TextStyle(fontSize: 18,))
                ],)
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
