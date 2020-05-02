import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/Notifications/navigate_to_screen.dart';
import 'screens/account/signin.dart';
import 'screens/homeScreen.dart';
import 'services/auth.dart';
import 'themes/maintheme.dart';

//==================This file is the Splash Screen for the app==================
BuildContext _context;
AuthService authService;
ThemeData myAppTheme;
GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

//Firebase Messaging for screens.Notifications
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
String _strFirebaseMessagingToken;

void main() {
  runApp(MaterialApp(home: new SplashScreen()));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    //Call the Class so that the constructor is called
    authService = new AuthService();

    //Firebase Messaging
    initializeFirebaseMessaging();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    //Initialize the theme
    myAppTheme = getMainThemeWithBrightness(context, Brightness.light);

    return MaterialApp(
      theme: myAppTheme,
      navigatorKey: navigatorKey,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/icon.png",
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Welcome to\nHTS",
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> mainNavigationPage() async {
  if (blIsSignedIn && userProfile.containsKey("type") && userProfile["type"] != null) {
    if (userProfile.containsKey("Theme"))
      myAppTheme = userProfile["Theme"] == "Light Theme"
          ? getMainThemeWithBrightness(_context, Brightness.light)
          : getMainThemeWithBrightness(_context, Brightness.dark);

    //Subscribe to Firebase Messaging Topics
    subscribeToTopics();

    //Set the Firebase Messaging token
    if (_strFirebaseMessagingToken != null &&
        _strFirebaseMessagingToken != "" &&
        userProfile["firebase messaging token"] != _strFirebaseMessagingToken) userProfile["firebase messaging token"] = _strFirebaseMessagingToken;

    Navigator.pushReplacement(
      _context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  } else {
    Navigator.pushReplacement(
      _context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }
}

//Firebase Messaging for screens.Notifications
initializeFirebaseMessaging() {
  //Request the Notification Permissions for iOS
  _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));
  _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
  });

  //Configure the firebaseMessaging
  _firebaseMessaging.configure(
    //On Android, set the "click_action" to "FLUTTER_NOTIFICATION_CLICK"
    onMessage: (Map<String, dynamic> message) async {
      //When the app is in the foreground
      print("onMessage: $message");
      processNotification(message, "onMessage");
    },
    onResume: (Map<String, dynamic> message) async {
      //When the app is running in the background
      print("onResume: $message");
      processNotification(message, "onResume");
    },
    onLaunch: (Map<String, dynamic> message) async {
      //when ihe app is terminated
      print("onLaunch: $message");
      processNotification(message, "onLaunch");
    },
  );

  //Get the Token
  _firebaseMessaging.getToken().then((String token) {
    assert(token != null);
    print("Push Messaging token: $token");
    _strFirebaseMessagingToken = token;
  });
}

//Subscribe to Firebase Messaging Topics
subscribeToTopics() {
  _firebaseMessaging.subscribeToTopic(userProfile["email"].toString().replaceAll("@", "at").replaceAll(".", "dot"));
}

processNotification(Map message, String appState) async {
  print("FCM Message:");
  print(message.toString());

  //Wait till the userProfile is updated
  int loop = 0;
  while ((userProfile == null || userProfile.length == 0) && loop < 10) {
    loop++;
    Future.delayed(Duration(seconds: 1));
  }

  //Get the Notification Data
  Map mapNotif = message["notification"];
  Map mapData = message["data"];

  //If screen info is present, decode that info, since it'll be in a json String
  if (mapData.containsKey("Screen")) {
    //Decode using json
    Map mapScreen = json.decode(mapData["Screen"]);
    //Update the existing map
    mapData["Screen"] = mapScreen;
  }

  message = {"notification": mapNotif, "data": mapData, "read": false};

  //Update Notification Data in the Database
  if (message["notification"]["title"] != null && message["notification"]["body"] != null) {
    userNotifications[DateTime.now().toString()] = message;
    await authService.setData();
  } else if (message["data"]["title"] != null && message["data"]["body"] != null) {
    message["notification"]["title"] = message["data"]["title"];
    message["notification"]["body"] = message["data"]["body"];

    userNotifications[DateTime.now().toString()] = message;
    await authService.setData();
  }

  if (appState == "onMessage") {
    //Display Notification as a SnackBar message
    Scaffold.of(_context).showSnackBar(SnackBar(content: message["notification"]["title"]));
  } else {
    //Navigate to the appropriate screen
    NavigateToScreen(message);
  }
}
