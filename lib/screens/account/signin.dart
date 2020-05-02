import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hts/screens/account/registration/hostel_registration.dart';
import 'package:hts/screens/homeScreen.dart';
import 'package:hts/services/auth.dart';
import 'package:hts/widgets/buttons.dart';
import 'package:hts/widgets/dialogboxes.dart';

import '../../main.dart';

//==================This is the Login Screen for the app==================

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => new _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with TickerProviderStateMixin {
  //Animation
  AnimationController _animController;
  Animation<Offset> _animOffset;

  @override
  void initState() {
    //For animation
    _animController = AnimationController(vsync: this, duration: Duration(milliseconds: 3000));
    final curve = CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset = Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero).animate(curve);

    Timer(Duration(milliseconds: 500), () {
      _animController.forward();
    });

    super.initState();
  }

  @override
  void dispose() {
    //Animation
    _animController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width
        : (!kIsWeb) ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height / 2;

    return SafeArea(
      child: Scaffold(
        backgroundColor: myAppTheme.backgroundColor,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.asset("assets/images/bg.jpg").image,
              fit: BoxFit.cover,
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 80, 30, 80),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              color: myAppTheme.backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[


                  //LOGO AND TITLE
                  FadeTransition(
                    child: SlideTransition(
                      position: _animOffset,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              "assets/images/icon.png",
                              width: 150,
                              height: 150,
                            ),
                          ),
                          Text("Welcome to HTS", style: myAppTheme.textTheme.caption),
                          Text(
                            "- Let the journey begin",
                            style: myAppTheme.textTheme.body2,
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                    opacity: _animController,
                  ),

                  //Description
                  blIsSignedIn
                      ? Padding(
                    padding: const EdgeInsets.all(35),
                    child: FadeTransition(
                      child: SlideTransition(
                        position: _animOffset,
                        child: Text("Select one of the following:", style: myAppTheme.textTheme.body2),
                      ),
                      opacity: _animController,
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.all(35),
                    child: FadeTransition(
                      child: SlideTransition(
                        position: _animOffset,
                        child: Text("Please log in to continue", style: myAppTheme.textTheme.body2),
                      ),
                      opacity: _animController,
                    ),
                  ),

                  //Get the login Button
                  blIsSignedIn
                      ? Column(
                          children: <Widget>[
                            //User
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.search,
                                      color: myAppTheme.iconTheme.color,
                                      size: size * 0.08,
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => HostelRegistration(true)),
                                      );
                                    },
                                  ),
                                  Text(
                                    "User",
                                    style: myAppTheme.textTheme.body2,
                                  )
                                ],
                              ),
                            ),

                            //Hostel Admin
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.hotel,
                                      color: myAppTheme.iconTheme.color,
                                      size: size * 0.08,
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => HostelRegistration(true)),
                                      );
                                    },
                                  ),
                                  Text(
                                    "Hostel Admin",
                                    style: myAppTheme.textTheme.body2,
                                  )
                                ],
                              ),
                            ),

                            //Tiffin Service Admin
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.fastfood,
                                      color: myAppTheme.iconTheme.color,
                                      size: size * 0.08,
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => HostelRegistration(true)),
                                      );
                                    },
                                  ),
                                  Text(
                                    "Tiffin Service Admin",
                                    style: myAppTheme.textTheme.body2,
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      : Padding(padding: const EdgeInsets.all(20), child: getLogInButton())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //
  //
  //
  //
  //
  //
  //
  //
  //Get the login button
  getLogInButton() {
    return primaryRaisedButton(
      context: context,
      text: "Log In using Google",
      textColor: myAppTheme.backgroundColor == Colors.white ? Colors.white : Colors.black,
      onPressed: () {
        //LOGIN USING GOOGLE HERE
        showLoading(context);

        authService.googleSignIn().then((user) {
          if (user == null) {
            //Login failed
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: new Text("Failed to log in!"),
                  content: new Text(
                      "Please make sure your Google Account is usable. Also make sure that you have a active internet connection, and try again."),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    new FlatButton(
                      child: new Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            //Stop Loading
            Navigator.of(context).pop(false);

            //check if a new user
            if (userProfile.containsKey("type") && userProfile["type"] != null) {
              //Navigate to the HomeScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            } else {
              //Show the choices
              setState(() {
                blIsSignedIn = true;
              });
            }
          }
        });
      },
    );
  }
}
