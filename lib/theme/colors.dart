import 'package:flutter/material.dart';

class ThemeColors{
  static const MaterialColor success = MaterialColor(_successPrimaryValue, <int, Color>{
    50: Color(0xFFE2F4EA),
    100: Color(0xFFB6E4CB),
    200: Color(0xFF85D2A9),
    300: Color(0xFF54C087),
    400: Color(0xFF2FB36D),
    500: Color(_successPrimaryValue),
    600: Color(0xFF099D4C),
    700: Color(0xFF079342),
    800: Color(0xFF058A39),
    900: Color(0xFF037929),
  });
  static const int _successPrimaryValue = 0xFF0AA553;

  static const MaterialColor successAccent = MaterialColor(_successAccentValue, <int, Color>{
    100: Color(0xFF80FF80),
    200: Color(_successAccentValue),
    400: Color(0xFF2AFF2A),
    700: Color(0xFF1AFF1A),
  });
  static const int _successAccentValue = 0xFF43FF43;

  static const MaterialColor info = MaterialColor(_infoPrimaryValue, <int, Color>{
    50: Color(0xFFE1EFFA),
    100: Color(0xFFB3D7F3),
    200: Color(0xFF81BCEB),
    300: Color(0xFF4EA1E2),
    400: Color(0xFF288CDC),
    500: Color(_infoPrimaryValue),
    600: Color(0xFF0270D1),
    700: Color(0xFF0165CC),
    800: Color(0xFF015BC6),
    900: Color(0xFF0148BC),
  });
  static const int _infoPrimaryValue = 0xFF0278D6;

  static const MaterialColor infoAccent = MaterialColor(_infoAccentValue, <int, Color>{
    100: Color(0xFF90C9FF),
    200: Color(_infoAccentValue),
    400: Color(0xFF3A9FFF),
    700: Color(0xFF2A98FF),
  });
  static const int _infoAccentValue = 0xFF53ACFF;

  static const MaterialColor warning = MaterialColor(_warningPrimaryValue, <int, Color>{
    50: Color(0xFFFDF2E0),
    100: Color(0xFFFADEB3),
    200: Color(0xFFF6C980),
    300: Color(0xFFF2B34D),
    400: Color(0xFFF0A226),
    500: Color(_warningPrimaryValue),
    600: Color(0xFFEB8A00),
    700: Color(0xFFE87F00),
    800: Color(0xFFE57500),
    900: Color(0xFFE06300),
  });
  static const int _warningPrimaryValue = 0xFFED9200;

  static const MaterialColor warningAccent = MaterialColor(_warningAccentValue, <int, Color>{
    100: Color(0xFFFFF6F4),
    200: Color(_warningAccentValue),
    400: Color(0xFFFFB19D),
    700: Color(0xFFFFA58E),
  });
  static const int _warningAccentValue = 0xFFFFC5B6;

  static const MaterialColor error = MaterialColor(_errorPrimaryValue, <int, Color>{
    50: Color(0xFFFBE6E5),
    100: Color(0xFFF6C1BF),
    200: Color(0xFFF09895),
    300: Color(0xFFE96E6A),
    400: Color(0xFFE54F4A),
    500: Color(_errorPrimaryValue),
    600: Color(0xFFDC2B25),
    700: Color(0xFFD8241F),
    800: Color(0xFFD31E19),
    900: Color(0xFFCB130F),
  });
  static const int _errorPrimaryValue = 0xFFE0302A;

  static const MaterialColor errorAccent = MaterialColor(_errorAccentValue, <int, Color>{
    100: Color(0xFFFFBFC8),
    200: Color(_errorAccentValue),
    400: Color(0xFFFF687E),
    700: Color(0xFFFF5971),
  });
  static const int _errorAccentValue = 0xFFFF8294;
  static const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
    50: Color(0xFFEDE3E5),
    100: Color(0xFFD2B9BF),
    200: Color(0xFFB48A95),
    300: Color(0xFF955B6A),
    400: Color(0xFF7F384A),
    500: Color(_primaryPrimaryValue),
    600: Color(0xFF601225),
    700: Color(0xFF550F1F),
    800: Color(0xFF4B0C19),
    900: Color(0xFF3A060F),
  });
  static const int _primaryPrimaryValue = 0xFF68152A;

  static const MaterialColor primaryAccent = MaterialColor(_primaryAccentValue, <int, Color>{
    100: Color(0xFFFF2484),
    200: Color(_primaryAccentValue),
    400: Color(0xFFCC005A),
    700: Color(0xFFBD0053),
  });
  static const int _primaryAccentValue = 0xFFE50065;
}