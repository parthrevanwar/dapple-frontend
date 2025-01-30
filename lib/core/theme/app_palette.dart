import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppPalette{
  static const bgColor = Color(0xFFF9F9F9);
  static const primaryColor = Color(0xFF6A5AE0);
  static const blackColor = Color(0xFF1A1A1A);
  static const primaryLightColor = Color(0xFFEFEEFC);
  static const white = Color(0xFFFFFFFF);
  static const transparent = Color(0x00000000);
  static const grey =Color(0xFFCCCCCC);
  static const secondaryColor = Color(0xFFF06100);


  static BoxShadow primaryShadow = BoxShadow(
    color: Colors.grey.withValues(alpha: 0.2),
    spreadRadius: 1,
    blurRadius: 7,
    offset: Offset(0, 3),
  );

  static LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8B7EE7), Color(0xFF6A5AE0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}