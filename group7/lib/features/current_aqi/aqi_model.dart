import "aqi_style.dart";


// Homepage class, add more attributes to account for more data
class AqiModel {
  final int general;
  final int pm2_5;
  final int pm10;
  final String city;
  final DateTime timestamp;

  AqiModel({
    required this.general,
    required this.pm2_5,  
    required this.pm10,  
    required this.city, 
    required this.timestamp}
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
      city: json["data"]["city"]["name"],
      timestamp: DateTime.now(),
    );
  }


  AqiStyle get style => AqiStyle.fromAqi(general);




}