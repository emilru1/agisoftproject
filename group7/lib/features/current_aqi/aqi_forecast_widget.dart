import 'package:flutter/material.dart';
import 'package:group7/core/widgets/pollutantText.dart';
import 'aqi_style.dart';
import 'package:group7/theme/app_theme.dart';

class AqiForecastWidget extends StatelessWidget {
  final List<dynamic> forecastData;

  const AqiForecastWidget({super.key, required this.forecastData});

  @override
  Widget build(BuildContext context) {
    if (forecastData.isEmpty) return const SizedBox.shrink();
    double cardWidth = MediaQuery.of(context).size.width * 0.4;

    return Container(
      width: cardWidth,
      constraints: const BoxConstraints(maxWidth: 480, minWidth: 360),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white60, // Semi-transparent look
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.white24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text("3-DAY FORECAST"),
          _buildForecastDay(forecastData[1]),
          _buildForecastDay(forecastData[2]),
          _buildForecastDay(forecastData[3]),
        ],
      ),
    );
  }

  Widget _buildForecastDay(dynamic forecast) {
    String weekday = _getWeekdayName(forecast.date);
    AqiStyle style = AqiStyle.fromAqi(forecast.pm2_5.max);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white90, // Semi-transparent look
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.white24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                weekday,
                style: const TextStyle(
                  color: AppTheme.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              // The Small Rounded Label
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: style.color.withValues(
                    alpha: 0.2,
                  ), // Subtle background
                  borderRadius: BorderRadius.circular(6), // Rounded corners
                  border: Border.all(color: style.color, width: 1),
                ),
                child: Text(
                  style.label,
                  style: TextStyle(
                    color: AppTheme.black,
                    fontSize: 10, // Tiny font
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Text(forecast.date, textAlign: TextAlign.left),
          SizedBox(height: 8),
          Divider(
            height: 2, // Adjust this to match your text height
            color: AppTheme.grey30,
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildCol("2_5", forecast.pm2_5)),

              Container(
                width: 2, // Thickness of the line
                height: 140, // Adjust this to match your text height
                color: AppTheme.grey30,
              ),
              SizedBox(width: 12),

              Expanded(child: _buildCol("10", forecast.pm10)),
            ],
          ),
        ],
      ),
    );
  }

  String _getWeekdayName(String dateString) {
    DateTime dt = DateTime.parse(dateString);

    // Dart's weekday returns 1 for Monday, 7 for Sunday
    switch (dt.weekday) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thu";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return "";
    }
  }

  Widget _buildCol(String pmValue, dynamic forecastParticle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PollutantText(subscript: pmValue, color: AppTheme.black, fontSize: 24),
        SizedBox(height: 8),
        Text(
          "MAX",
          style: TextStyle(
            color: AppTheme.black,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          "${forecastParticle.max}",
          style: TextStyle(
            color: AppTheme.black,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        Row(
          children: [
            Text(
              "min: ",
              style: TextStyle(
                color: AppTheme.black,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              "${forecastParticle.min}",
              style: TextStyle(
                color: AppTheme.black,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "avg: ",
              style: TextStyle(
                color: AppTheme.black,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              "${forecastParticle.avg}",
              style: TextStyle(
                color: AppTheme.black,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
