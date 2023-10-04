import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webview_flutter/webview_flutter.dart';


class FarmVideos extends StatefulWidget {
  FarmVideos({
    Key key,
  }) : super(key: key);

  @override
  _FarmVideosState createState() => _FarmVideosState();
}


class _FarmVideosState extends State<FarmVideos> {


final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  num _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

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
        title: Text("Farming Videos"),
        centerTitle: true,
        
        ),
      body: IndexedStack(
          index: _stackToView,
          children: [
            Column(
              children: <Widget>[
                Expanded(
                    child: WebView(
                  initialUrl: "https://www.youtube.com/results?search_query=cocoa+farming+in+ghana",
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: _handleLoad,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                )),
              ],
            ),
            Container(
              child: Center(child: CircularProgressIndicator(),)
            ),
          ],
        ),
    );
  }

 
}
