import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/shapes.dart';

//This file contains the main theme settings

//Return the ThemeData with Brightness
ThemeData getMainThemeWithBrightness(BuildContext context, Brightness appBrightness) {
  double size = MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
      ? MediaQuery.of(context).size.width
      : (!kIsWeb) ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height / 2;

//  //Set StatusBar color, navigationBar color
//  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//    statusBarColor: appBrightness == Brightness.light ? Colors.white : Colors.black,
//    statusBarIconBrightness: appBrightness == Brightness.light ? Brightness.dark : Brightness.light,
//    systemNavigationBarColor: appBrightness == Brightness.light ? Colors.white : Colors.black,
//    systemNavigationBarIconBrightness: appBrightness == Brightness.light ? Brightness.dark : Brightness.light,
//  ));

  return ThemeData(
    // Define the default brightness and colors.
    brightness: appBrightness,
    primaryColor: appBrightness == Brightness.light ? Color.fromARGB(255, 252, 174, 74) : Color.fromARGB(255, 252, 174, 74),
    accentColor: appBrightness == Brightness.light ? Color.fromARGB(255, 252, 174, 74) : Color.fromARGB(255, 252, 174, 74),

    highlightColor: appBrightness == Brightness.light ? Color.fromARGB(255, 252, 174, 74) : Color.fromARGB(255, 252, 174, 74),
    cursorColor: appBrightness == Brightness.light ? Color.fromARGB(255, 252, 174, 74) : Color.fromARGB(255, 252, 174, 74),
    focusColor: appBrightness == Brightness.light ? Color.fromARGB(255, 252, 174, 74) : Color.fromARGB(255, 252, 174, 74),
    indicatorColor: appBrightness == Brightness.light ? Color.fromARGB(255, 252, 174, 74) : Color.fromARGB(255, 252, 174, 74),
    buttonColor: appBrightness == Brightness.light ? Color.fromARGB(255, 252, 174, 74) : Color.fromARGB(255, 252, 174, 74),

    splashColor: appBrightness == Brightness.light ? Color.fromARGB(255, 234, 76, 137) : Color.fromARGB(255, 8, 195, 164),
    primaryColorDark: appBrightness == Brightness.light ? Color.fromARGB(255, 234, 76, 137) : Color.fromARGB(255, 34, 95, 77),

    iconTheme: IconThemeData(color: appBrightness == Brightness.light ? Colors.black : Colors.white70, opacity: 1.0, size: size * 0.06),

    backgroundColor: appBrightness == Brightness.light ? Colors.white : Colors.black,
    scaffoldBackgroundColor: appBrightness == Brightness.light ? Colors.white : Colors.black,
    canvasColor: appBrightness == Brightness.light ? Colors.white : Colors.black,

    //For Card
    cardColor: appBrightness == Brightness.light ? Color.fromARGB(255, 250, 250, 250) : Color.fromARGB(255, 30, 30, 30),
    cardTheme: CardTheme(
      color: appBrightness == Brightness.light ? Color.fromARGB(255, 250, 250, 250) : Color.fromARGB(255, 30, 30, 30),
      elevation: 6,
      margin: EdgeInsets.all(12),
      shape: roundedShape(),
    ),

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, headline2s, bodies of text, and more.
    textTheme: TextTheme(
        title:
            TextStyle(fontSize: size * 0.09, fontWeight: FontWeight.bold, color: appBrightness == Brightness.light ? Colors.black : Colors.white70),
        subtitle:
            TextStyle(fontSize: size * 0.085, fontWeight: FontWeight.bold, color: appBrightness == Brightness.light ? Colors.black : Colors.white70),
        caption:
            TextStyle(fontSize: size * 0.06, fontWeight: FontWeight.bold, color: appBrightness == Brightness.light ? Colors.black : Colors.white70),
        body1: TextStyle(fontSize: size * 0.05, color: appBrightness == Brightness.light ? Colors.black : Colors.white70),
        body2: TextStyle(fontSize: size * 0.045, color: appBrightness == Brightness.light ? Colors.black : Colors.white70)),
  );
}
