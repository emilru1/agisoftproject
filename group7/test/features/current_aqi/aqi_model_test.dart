import 'package:flutter_test/flutter_test.dart';
import 'package:group7/features/current_aqi/aqi_model.dart';
import 'dummy_aqi_response.dart';

void main() {
  group("AqiModel Tests", () {
      
      test("fromJson  should contain general with correct value", () {
        
        final model = AqiModel.fromJson(dummyAqiResponse);
        expect(model.general, 9);
      
      });
      test("fromJson should contain pm2.5 with correct value", () {
        
        final model = AqiModel.fromJson(dummyAqiResponse);
        expect(model.pm2_5, 9);
      
      });

      test("fromJson  should contain pm10 with correct value", () {
        
        final model = AqiModel.fromJson(dummyAqiResponse);
        expect(model.pm10, 8);
      
      });

      test("fromJson should contain city with correct value", () {
        
        final model = AqiModel.fromJson(dummyAqiResponse);
        expect(model.city, "Göteborg Femman, Sweden");
      
      });

      test("fromJson should contain the pm2.5 forecast (avg,min,max,day) with correct values", () {
        final model = AqiModel.fromJson(dummyAqiResponse);
        
        //Today 
        expect(model.threeDayForecast[0].date, "2026-04-28");
        expect(model.threeDayForecast[0].pm2_5.avg, 11);
        expect(model.threeDayForecast[0].pm2_5.min, 5);
        expect(model.threeDayForecast[0].pm2_5.max, 17);

        //Next day
        expect(model.threeDayForecast[1].date, "2026-04-29");
        expect(model.threeDayForecast[1].pm2_5.avg, 19);
        expect(model.threeDayForecast[1].pm2_5.min, 9);
        expect(model.threeDayForecast[1].pm2_5.max, 24);

        //Second day
        expect(model.threeDayForecast[2].date, "2026-04-30");
        expect(model.threeDayForecast[2].pm2_5.avg, 18);
        expect(model.threeDayForecast[2].pm2_5.min, 11);
        expect(model.threeDayForecast[2].pm2_5.max, 25);

        //Third day
        expect(model.threeDayForecast[3].date, "2026-05-01");
        expect(model.threeDayForecast[3].pm2_5.avg, 17);
        expect(model.threeDayForecast[3].pm2_5.min, 8);
        expect(model.threeDayForecast[3].pm2_5.max, 31);
      });

      test("fromJson should contain the pm10 forecast (avg,min,max,day) with correct values", () {
        final model = AqiModel.fromJson(dummyAqiResponse);
        
        //Today 
        expect(model.threeDayForecast[0].date, "2026-04-28");
        expect(model.threeDayForecast[0].pm10.avg, 5);
        expect(model.threeDayForecast[0].pm10.min, 3);
        expect(model.threeDayForecast[0].pm10.max, 7);

        //Next day
        expect(model.threeDayForecast[1].date, "2026-04-29");
        expect(model.threeDayForecast[1].pm10.avg, 13);
        expect(model.threeDayForecast[1].pm10.min, 5);
        expect(model.threeDayForecast[1].pm10.max, 18);

        //Second day
        expect(model.threeDayForecast[2].date, "2026-04-30");
        expect(model.threeDayForecast[2].pm10.avg, 10);
        expect(model.threeDayForecast[2].pm10.min, 8);
        expect(model.threeDayForecast[2].pm10.max, 16);

        //Third day
        expect(model.threeDayForecast[3].date, "2026-05-01");
        expect(model.threeDayForecast[3].pm10.avg, 8);
        expect(model.threeDayForecast[3].pm10.min, 5);
        expect(model.threeDayForecast[3].pm10.max, 13);
      });


  });
}