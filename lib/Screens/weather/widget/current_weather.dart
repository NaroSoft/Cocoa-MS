import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//
import '../utils/constanst.dart';

Widget currentWeather({
  VoidCallback onPressed,
  String temp,
  String location,
  String country,
  String status,
}) {
  return Container(
    width: w,
    child: Container(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("$location, $country", style: kTitleFont),
                  SizedBox(width: 5,),
                  IconButton(
                      onPressed: onPressed,
                      icon: Icon(
                        CupertinoIcons.refresh,
                        color: Colors.white,
                        size: 30,
                      )),
                ],
              ),
              Text("${temp}°", style: kTempFont),
            ],
          ),
          Expanded(child: Container()),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: w / 13,
            height: h / 5,
            child: RotatedBox(
              quarterTurns: -1,
              child: Center(
                child: Text(
                  status,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
