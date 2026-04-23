import "aqi_style.dart";


// Homepage class, add more attributes to account for more data
class AqiModel {
  final int aqi;
  final String city;
  final DateTime timestamp;

  AqiModel({required this.aqi, required this.city, required this.timestamp});


  /* 
  
  This factory will be used to fetch data from thea AQI/MAP API. 
  The structure of the json calls might need to be changed.
  
  */

  factory AqiModel.fromJson(Map<String, dynamic> json) {
    return AqiModel(
      aqi: json["data"]["aqi"],
      city: json["data"]["city"]["name"],
      timestamp: DateTime.now(),
    );
  }


  AqiStyle get style => AqiStyle.fromAqi(aqi);




}