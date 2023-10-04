import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'message.dart';

class chatpage extends StatefulWidget {
  String user_email,seller_email,user_name,seller_name;
  chatpage({@required this.user_email, this.seller_email, this.user_name, this.seller_name});
  @override
  _chatpageState createState() => _chatpageState(user_email: user_email,
   seller_email: seller_email, user_name: user_name, seller_name:seller_name);
}

class _chatpageState extends State<chatpage> {

  String uid;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    uid="${user_email}_${seller_email}";
    super.setState(fn);
  }

  String user_email,seller_email,user_name,seller_name;
  _chatpageState({@required this.user_email, this.seller_email, this.user_name,this.seller_name});

  final fs = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final TextEditingController message = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 105, 53, 9),
        title: Text(
          'Chat with Seller',
        ),
        centerTitle: true,
        
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            Container(
              height: MediaQuery.of(context).size.height * 0.79,
              child: messages(
                user_email: user_email,
                seller_email: seller_email,
                user_name: user_name,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: message,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 243, 229, 212),
                      hintText: 'message',
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Color.fromARGB(255, 20, 11, 4)),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(color: Color.fromARGB(255, 37, 30, 6)),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {},
                    onSaved: (value) {
                      message.text = value;
                    },
                  ),
                ),
                
                IconButton(
                  onPressed: () {
                    if (message.text.isNotEmpty) {
                      fs.collection('Messages').doc().set({
                        'message': message.text.trim(),
                        'time': DateTime.now(),
                        'email': seller_email,
                        'name' : user_name,
                        'uid' : '${user_email}_${seller_email}'
                      });

                      message.clear();
                    }
                  },
                  icon: Icon(Icons.send_sharp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
