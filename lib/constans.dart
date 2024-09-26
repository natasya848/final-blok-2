import 'package:flutter/material.dart';

class Palette {
  static const String sUrl =
      "http://192.168.201.199/codeigniter3"; // Local environment
  // static const String sUrl = "https://10.0.2.2/codeigniter3"; // Use this for emulator

  // Define colors
  static const Color bg1 = Color.fromRGBO(7, 179, 42, 1);
  static const Color bg2 = Color.fromRGBO(14, 145, 34, 1);
  static const Color orange = Color.fromRGBO(171, 249, 180, 1);
  static const Color menuTix = Color(0xffe86f16);
  static const Color menuNiaga = Color.blueAccent[700];

  // List of colors
  static const List<Color> colors = <Color>[
    Color.fromARGB(255, 255, 0, 0), // Red
    Color.fromARGB(255, 255, 128, 0), // Orange
    Color.fromARGB(255, 0, 178, 0), // Green
    Color.fromARGB(255, 0, 0, 255), // Blue
    Color.fromARGB(255, 127, 0, 255), // Purple
    Color.fromARGB(255, 255, 0, 255), // Magenta
    Color.fromARGB(255, 255, 0, 127), // Pink
    Color.fromARGB(255, 128, 128, 128), // Gray
  ];
}
