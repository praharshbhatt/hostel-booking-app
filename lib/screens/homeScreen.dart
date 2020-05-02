import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hts/services/auth.dart';
import 'package:hts/widgets/appbar.dart';
import 'package:hts/widgets/drawer.dart';
import '../main.dart';
import '../themes/maintheme.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  //Keys
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  //Initialize
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width
        : (!kIsWeb) ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height / 2;

    //For Refreshing the theme
    if (userProfile.containsKey("Theme"))
      myAppTheme = userProfile["Theme"] == "Light Theme"
          ? getMainThemeWithBrightness(context, Brightness.light)
          : getMainThemeWithBrightness(context, Brightness.dark);

    return SafeArea(
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: myAppTheme.scaffoldBackgroundColor,
          appBar: getAppBar(
            scaffoldKey: scaffoldKey,
            context: context,
            strAppBarTitle: "HTS",
            showBackButton: false,
          ),

          //drawer
          drawer: getDrawer(context, scaffoldKey),

          //Body
          body: Container()),
    );
  }
}
