import 'package:cloud_firestore/cloud_firestore.dart' as MobFirebaseFirestore;
import 'package:firebase_auth/firebase_auth.dart' as MobFirebaseAuth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

MobFirebaseAuth.FirebaseUser firebaseUser;
Map<String, dynamic> userProfile = {"vibrate": true};
Map userNotifications = new Map();

//This is the main Firebase auth object
MobFirebaseAuth.FirebaseAuth mobAuth = MobFirebaseAuth.FirebaseAuth.instance;

// For google sign in
final GoogleSignIn mobGoogleSignIn = GoogleSignIn();

//CloudFireStore
MobFirebaseFirestore.Firestore dbFirestore = MobFirebaseFirestore.Firestore.instance;

bool blIsSignedIn = false;

class AuthService {
  // constructor
  AuthService() {
    checkIsSignedIn().then((_blIsSignedIn) async {
      //Get the profile data from the database
      if (blIsSignedIn) await getData();

      //redirect to appropriate screen
      mainNavigationPage();
    });
  }

  //Checks if the user has signed in
  Future<bool> checkIsSignedIn() async {
    //For mobile
    if (mobAuth != null && (await mobGoogleSignIn.isSignedIn())) {
      firebaseUser = await mobAuth.currentUser();

      if (firebaseUser != null) {
        //User is already logged in
        blIsSignedIn = true;
      } else {
        blIsSignedIn = false;
      }
    } else {
      blIsSignedIn = false;
    }
    return blIsSignedIn;
  }

  //Log in using google
  Future<dynamic> googleSignIn() async {
    //For mobile

    // Step 1
    GoogleSignInAccount googleUser = await mobGoogleSignIn.signIn();

    // Step 2
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    AuthResult _res = await mobAuth.signInWithCredential(credential);
    firebaseUser = _res.user;

    blIsSignedIn = true;

    //Add the data to the database
    try {
      userProfile = {"name": firebaseUser.displayName, "email": firebaseUser.email, "photo": firebaseUser.photoUrl};
      await setData();
    } catch (e) {
      print(e.toString());
    }

    //Get the data from the database
    getData();

    return firebaseUser;
  }

  //Gets the userData
  Future<bool> getData() async {
    //For mobile
    bool blReturn;

    dbFirestore.collection("Users").document(firebaseUser.email).snapshots().listen((snapshot) {
      if (snapshot.data != null) {
        userProfile = snapshot.data;
        print(userProfile);

        //Notifications
        if (userProfile.containsKey("Notifications")) {
          userNotifications = userProfile["Notifications"];
          userProfile.remove("Notifications");
        }

        blReturn = true;
      } else {
        blReturn = false;
      }
    });

    while (blReturn == null) await Future.delayed(Duration(seconds: 1));
    return blReturn;
  }

  //Update the data into the database
  Future<bool> setData() async {
    bool blReturn = false;

    //Notifications
    userProfile["Notifications"] = userNotifications;

    //For mobile
    await dbFirestore.collection("Users").document(firebaseUser.email).setData(userProfile, merge: true).then((onValue) async {
      blReturn = true;
    });
    return blReturn;
  }

  void signOut() {
    //For mobile
    mobAuth.signOut();
  }
}
