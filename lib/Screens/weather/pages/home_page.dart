import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
//
import '../utils/constanst.dart';
import '../model/weather_model.dart';
import '../services/weather_api_client.dart';
import '../widget/current_weather.dart';
import '../widget/more_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   String countryValue;
  String stateValue;
  String cityValue;
  var citylocation="kumasi";
  //
  WeatherApiClient weatherapi = WeatherApiClient();
  WeatherModel data;
  //
  Future<void> getData(String location) async {
    data = await weatherapi.getCurrentWeather(location);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.darken),
              filterQuality: FilterQuality.high,
              image: AssetImage("assets/images/backG.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          width: w,
          height: h,
          child: Column(
            children: [
              SelectState(
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),
              onCountryChanged: (value) {
              setState(() {
                countryValue = value;
              });
            },
            onStateChanged:(value) {
              setState(() {
                stateValue = value;
              });
            },
             onCityChanged:(value) {
              setState(() {
                cityValue = value;
                citylocation=cityValue;
              });
            },
            
            ),

            SizedBox(height: 20,),

            Container(margin: EdgeInsets.all(10), child: loadedData()),
          ]
          ),
        ),
      ),
    );
  }




/////////////////////////////////////
//@CodeWithFlexz on Instagram
//
//AmirBayat0 on Github
//Programming with Flexz on Youtube
/////////////////////////////////////
  FutureBuilder<void> loadedData() {
    return FutureBuilder(
      // Zanjan , Toronto, Yakutsk, las vegas, miami
      future: getData(citylocation), 
      builder: (ctx, snp) {
        if (snp.connectionState == ConnectionState.done) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              currentWeather(
                  onPressed: () {
                    setState(() {
                      loadedData();
                    });
                  },
                  temp: "${data.temp}",
                  location: "${data.cityName}",
                  status: "${data.status}",
                  country: "${data.country}"),

                  SizedBox(height: 20,),
              moreInfo(
                  wind: "${data.wind}",
                  humidity: "${data.humidity}",
                 // feelsLike: "${data.feelsLike}"
                    )
            ],
          );
        } else if (snp.connectionState == ConnectionState.waiting) {
          return Center(
            child: CupertinoActivityIndicator(
              radius: 20,
              color: Color.fromARGB(255, 172, 216, 247),
            ),
          );
        }
        return Container();
      },
    );
  }
}
