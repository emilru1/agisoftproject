import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group7/core/dataDisplay.dart';
import 'package:group7/features/current_aqi/aqi_model.dart';
import 'package:provider/provider.dart';

import 'package:group7/features/current_aqi/aqi_provider.dart';


void main() {

  group('Datadisplay Widget Tests', () {

    testWidgets('shows AQI data and filter chips',
        (WidgetTester tester) async {

      // Fake provider
      final provider = FakeAqiProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider<AqiProvider>.value(
          value: provider,
          child: const MaterialApp(
            home: Scaffold(
              body: Datadisplay(),
            ),
          ),
        ),
      );
      
      // Verify general AQI text
      expect(find.text('Good'), findsWidgets);

      // Verify chips exist
      expect(find.text('PM2_5'), findsOneWidget);


      // Check that filters work
      expect(find.text('243'), findsOneWidget);

      await tester.tap(find.text('PM2.5'));
      
      await tester.pump();

      expect(find.text('243'), findsNothing);


    });
  });
}
class FakeAqiProvider extends ChangeNotifier implements AqiProvider {

  AqiModel? _currentData = AqiModel(
    general: 2,
    pm2_5: 243,
    pm10: 1,
    city: "Skövde",
    timestamp: DateTime.now(),
    threeDayForecast: [
      ForecastDay(
        date: "1",
        pm10: AqiType(avg: 1, max: 1, min: 1),
        pm2_5: AqiType(avg: 1, max: 1, min: 1),
      )
    ],
    lat: 2,
    lon: 2,
  );

  @override
  AqiModel? get currentData => _currentData;

  set currentData(AqiModel? value) {
    _currentData = value;
    notifyListeners();
  }
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
class FakeAqiData {
  final String general = 'Good';

  final style = FakeStyle();

  final double pm10 = 12.0;
  final double pm2_5 = 5.0;
}

class FakeStyle {
  final String description = 'Air quality is good';
}