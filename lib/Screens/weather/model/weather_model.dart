class WeatherModel {
  String cityName;
  double temp;
  double wind;
  int humidity;
  double feelsLike;
  String status;
  String country;
  //
  WeatherModel({
    this.cityName,
    this.temp,
    this.wind,
    this.humidity,
    this.feelsLike,
    this.status,
    this.country,
  });

  //

  WeatherModel.fromJson(Map<String, dynamic> json) {
    cityName = json["name"] as String;
    temp = json["main"]["temp"] as double;
    wind = json["wind"]["speed"] as double;
    humidity = json["main"]["humidity"]as int;
    //feelsLike = json["main"]["feels_like"]as double;
    status = json["weather"][0]["main"]as String;
    country = json["sys"]["country"]as String;
  }
}
