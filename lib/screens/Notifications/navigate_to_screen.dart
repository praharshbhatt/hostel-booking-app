//Navigate after clicking on the Notification
import 'package:flutter/material.dart';
import 'package:hts/screens/profile.dart';
import 'package:hts/screens/settings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

Future<void> NavigateToScreen(Map message) async {
  try {
    //Get the Notification Data
    Map mapNotif = message["notification"];
    Map mapData = message["data"];

    if (mapData.containsKey("url")) {
      String strURL = mapData["url"];
      if (await canLaunch(strURL)) {
        await launch(strURL);
      } else {
        throw "Could not launch";
      }
    } else if (mapData.containsKey("Screen")) {
      Map mapScreen = mapData["Screen"];

      if (mapScreen["screen"] == "Settings") {
        if (mapScreen.containsKey("data")) {
          //Open the specific events page
          String strEventID = mapScreen["data"];
          navigatorKey.currentState.pushReplacement(MaterialPageRoute(builder: (context) => SettingsScreen()));
        } else {
          //Open the Settings page
          navigatorKey.currentState.pushReplacement(MaterialPageRoute(builder: (context) => SettingsScreen()));
        }
      } else if (mapScreen["screen"] == "Profile") {
        navigatorKey.currentState.pushReplacement(MaterialPageRoute(builder: (context) => ProfileScreen()));
      }
    }
  } catch (e) {
    print("Error: " + e.toString());
  }
}
