import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum AqiLevel { good, 
                moderate, 
                sensitive, 
                unhealthy, 
                veryUnhealthy, 
                hazardous }

class AqiStyle {
  final AqiLevel level;
  final Color color;
  final String label;
  final String description;

  AqiStyle(
    { required this.level,
      required this.color, 
      required this.label, 
      required this.description
    });

static AqiStyle fromAqi(int aqi) {
    if (aqi <= 50) {
      return AqiStyle(
        level: AqiLevel.good,
        color: Color(0xFF4ADE80),
        label: "Good",
        description: "Air quality is satisfactory, and air pollution poses little or no risk.",
      );
    } else if (aqi <= 100) {
      return  AqiStyle(
        level: AqiLevel.moderate,
        color: Color(0xFFFDE047),
        label: "Moderate",
        description: "Air quality is acceptable. However, there may be a risk for some people, particularly those who are unusually sensitive to air pollution.",
      );
    } else if (aqi <= 150) {
      return AqiStyle(
        level: AqiLevel.sensitive,
        color: Color(0xFFFB923C),
        label: "Unhealthy for Sensitive Groups",
        description: "Members of sensitive groups may experience health effects. The general public is less likely to be affected.",
      );
    } else if (aqi <= 200) {
      return AqiStyle(
        level: AqiLevel.unhealthy,
        color: Color(0xFFF87171),
        label: "Unhealthy",
        description: "Some members of the general public may experience health effects; members of sensitive groups may experience more serious health effects.",
      );
    } else if (aqi <= 300) {
      return AqiStyle(
        level: AqiLevel.veryUnhealthy,
        color: Color(0xFFA855F7),
        label: "Very Unhealthy",
        description: "Health alert: The risk of health effects is increased for everyone.",
      );
    } else {
      return AqiStyle(
        level: AqiLevel.hazardous,
        color: Color(0xFF7F1D1D),
        label: "Hazardous",
        description: "Health warning of emergency conditions: everyone is more likely to be affected.",
      );
    }
}

