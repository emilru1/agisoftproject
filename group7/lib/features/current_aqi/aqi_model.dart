import "dart:typed_data";

import "aqi_style.dart";


/// Homepage class, add more attributes to account for more data
/// * [general] - The main AQI value
/// * [pm2_5]  - Recorded pm2_5 value
/// * [pm10]  - Recorded pm10 value
/// * [city]  - The city defined by the request
/// * [timestamp] - When the request was made
/// * [threeDayForecast] - A list of [ForecastDay]:s  for today(index 0) and 3 upcoming days
/// 
/// ### Example of [threeDayForecast]
/// * threeDayForecast[0] - will return all the forecasts for today + date
/// * threeDayForecast[0].pm2_5.avg - will return the avg pm2.5 for today
/// * threeDayForecast[1].date - will return the date for tomorrow
/// 

class AqiModel {
  final int general;
  final int pm2_5;
  final int pm10;
  final int? no2;

  final double? co;
  final double? o3;
  final double? so2;
  //final int uvi;
  final String city;
  final DateTime timestamp;
  final List<ForecastDay> threeDayForecast;

  final double lat;
  final double lon;

  AqiModel({
    required this.general,
    required this.pm2_5,  
    required this.pm10,
    required this.no2,

    required this.co,
    required this.o3,  
    required this.so2,  
    //required this.uvi,  
    required this.city, 
    required this.timestamp,
    required this.threeDayForecast,
    required this.lat,
    required this.lon
    }
  );


  /* 
  
  This factory will be used to fetch data from thea AQI/MAP API. 
  The structure of the json calls might need to be changed.
  
  */

  factory AqiModel.fromJson(Map<String, dynamic> json) {
  return AqiModel(
    general: json["data"]["aqi"],
    pm2_5: json["data"]["iaqi"]["pm25"]["v"],
    pm10: json["data"]["iaqi"]["pm10"]["v"],
    //no2: json["data"]["iaqi"]["no2"]["v"],
    no2: json["data"]["iaqi"]["no2"] != null
       ? (json["data"]["iaqi"]["no2"]["v"] as num).toInt()
       : null,

    co: json["data"]["iaqi"]["co"] != null
       ? (json["data"]["iaqi"]["co"]["v"] as num).toDouble()
       : null,

    o3: json["data"]["iaqi"]["o3"] != null
      ? (json["data"]["iaqi"]["o3"]["v"] as num).toDouble()
       : null,
    so2: json["data"]["iaqi"]["so2"] != null
      ? (json["data"]["iaqi"]["so2"]["v"] as num).toDouble()
       : null,
    //uvi: json["data"]["iaqi"],
    city: json["data"]["city"]["name"],
    timestamp: DateTime.now(),
    lat: json["data"]["city"]["geo"][0].toDouble(),
    lon: json["data"]["city"]["geo"][1].toDouble(),
    threeDayForecast: getForecastFromJson(json),
  );
}

  ///Extracts Forecast based on API [json] response
  static List<ForecastDay> getForecastFromJson(Map<String, dynamic> json) {
    List<ForecastDay> forecastDays = [];

    for(var i=0; i < 4; i++){
      String date = json["data"]["forecast"]["daily"]["pm10"][i+2]["day"];

      //Check if index out of range(missing data)
      if( 
        i+2 >= json["data"]["forecast"]["daily"]["pm25"].length || 
        i+2 >= json["data"]["forecast"]["daily"]["pm10"].length
      ){break;}
      //pm2,5
        AqiType pm2_5 = AqiType(
        avg: json["data"]["forecast"]["daily"]["pm25"][i+2]["avg"],
        min: json["data"]["forecast"]["daily"]["pm25"][i+2]["min"],
        max: json["data"]["forecast"]["daily"]["pm25"][i+2]["max"],
      );

      //pm10
        AqiType pm10 = AqiType(
        avg: json["data"]["forecast"]["daily"]["pm10"][i+2]["avg"],
        min: json["data"]["forecast"]["daily"]["pm10"][i+2]["min"],
        max: json["data"]["forecast"]["daily"]["pm10"][i+2]["max"],
      );

      forecastDays.add(ForecastDay(date: date, pm2_5: pm2_5, pm10: pm10));
    }
    return forecastDays;
}


AqiStyle get style => AqiStyle.fromAqi(general);

}

///A specific [date] of avg,min,max air qualities for different [AqiType]:s
class ForecastDay {
  final String date;
  final AqiType pm2_5;
  final AqiType pm10;
  ForecastDay({required this.date, required this.pm2_5,required this.pm10 });
}

///A specific intance of recorded avg,min,values for an air quality metri (pm2,5 pm10 etc). 
class AqiType{
  final int avg;
  final int min;
  final int max;
  AqiType({required this.avg,required this.min,required this.max});
}