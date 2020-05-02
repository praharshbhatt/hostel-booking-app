import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hts/widgets/buttons.dart';
import 'package:hts/widgets/dialogboxes.dart';
import 'package:hts/widgets/form.dart';
import '../../../main.dart';

class HostelRegistration extends StatefulWidget {
  bool blFirst = true;

  HostelRegistration(this.blFirst);

  @override
  _HostelRegistrationState createState() => new _HostelRegistrationState(blFirst);
}

class _HostelRegistrationState extends State<HostelRegistration> with TickerProviderStateMixin {
  bool blFirst = true;

  //Keys
  final _formGeneralKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _HostelRegistrationState(this.blFirst);

  TextEditingController _tecName = new TextEditingController(),
      _tecPhone = new TextEditingController(),
      _tecEmail = new TextEditingController(),
      _tecCity = new TextEditingController(),
      _tecAddress = new TextEditingController(),
      _tecRates = new TextEditingController(),
      _tecFunctions = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tecName.dispose();
    _tecPhone.dispose();
    _tecEmail.dispose();
    _tecCity.dispose();
    _tecAddress.dispose();
    _tecRates.dispose();
    _tecFunctions.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width
        : (!kIsWeb) ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height / 2;

    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Registration for Hostel",
          ),
          backgroundColor: myAppTheme.primaryColor,
          leading: blFirst
              ? Container()
              : IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
        ),





        //
        //
        //
        //
        //
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.asset("assets/images/bg.jpg").image,
              fit: BoxFit.cover,
            ),
          ),

          child: Stack(
            children: <Widget>[
              //Registration Form
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 50, 30, 80),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  color: myAppTheme.backgroundColor,
                  child: Form(
                    key: _formGeneralKey,
                    child: ListView(
                      padding: EdgeInsets.all(15),
                      children: <Widget>[
                        //Name of the hostel
                        getTextFormFieldLogin(
                          context: context,
                          controller: _tecName,
                          strLabelText: "Name of the hostel",
                          strHintText: "e.g. Sankar Boys Hostel",
                          fillColor: myAppTheme.backgroundColor,
                          textColor: myAppTheme.textTheme.body1.color,
                          keyboardType: TextInputType.text,
                          validator: (val) {
                            if (val == "") {
                              return "This cannot be empty";
                            } else {
                              return null;
                            }
                          },
                        ),

                        //Contact Number
                        getTextFormFieldLogin(
                          context: context,
                          controller: _tecPhone,
                          strLabelText: "Contact Number",
                          strHintText: "e.g. 9876543210",
                          fillColor: myAppTheme.backgroundColor,
                          textColor: myAppTheme.textTheme.body1.color,
                          keyboardType: TextInputType.phone,
                          validator: (val) {
                            if (val == "") {
                              return "This cannot be empty";
                            } else {
                              return null;
                            }
                          },
                        ),

                        //Email
                        getTextFormFieldLogin(
                          context: context,
                          controller: _tecEmail,
                          strLabelText: "Email ID",
                          strHintText: "e.g. abc@xyz.com",
                          fillColor: myAppTheme.backgroundColor,
                          textColor: myAppTheme.textTheme.body1.color,
                          keyboardType: TextInputType.text,
                          validator: (val) {
                            if (val == "") {
                              return "This cannot be empty";
                            } else {
                              return null;
                            }
                          },
                        ),

                        //City
                        getTextFormFieldLogin(
                          context: context,
                          controller: _tecCity,
                          strLabelText: "City",
                          strHintText: "e.g. Anand",
                          fillColor: myAppTheme.backgroundColor,
                          textColor: myAppTheme.textTheme.body1.color,
                          keyboardType: TextInputType.text,
                          validator: (val) {
                            if (val == "") {
                              return "This cannot be empty";
                            } else {
                              return null;
                            }
                          },
                        ),

                        //Full Address
                        getTextFormFieldLogin(
                          context: context,
                          controller: _tecAddress,
                          strLabelText: "Full Address",
                          strHintText: "e.g. Bhai kaka road, op park...",
                          maxLines: 5,
                          fillColor: myAppTheme.backgroundColor,
                          textColor: myAppTheme.textTheme.body1.color,
                          keyboardType: TextInputType.text,
                          validator: (val) {
                            if (val == "") {
                              return "This cannot be empty";
                            } else {
                              return null;
                            }
                          },
                        ),

                        //Rates
                        getTextFormFieldLogin(
                          context: context,
                          controller: _tecRates,
                          strLabelText: "Rates",
                          strHintText: "e.g. 5k mer month",
                          fillColor: myAppTheme.backgroundColor,
                          textColor: myAppTheme.textTheme.body1.color,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val == "") {
                              return "This cannot be empty";
                            } else {
                              return null;
                            }
                          },
                        ),

                        //Add function for the specific rooms
                        getTextFormFieldLogin(
                          context: context,
                          controller: _tecFunctions,
                          strLabelText: "Add functions for the specific rooms",
                          strHintText: "e.g. Hot water every morning...\nRoom cleaning...\nDry cleaning",
                          maxLines: 5,
                          fillColor: myAppTheme.backgroundColor,
                          textColor: myAppTheme.textTheme.body1.color,
                          keyboardType: TextInputType.text,
                          validator: (val) {
                            if (val == "") {
                              return "This cannot be empty";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),


              //Registration Label
              Positioned(
                top: 20,
                left: MediaQuery
                    .of(context)
                    .size
                    .width * 0.5 - 90,
                child: primaryRaisedButton(
                  context: context,
                  text: "Registration",
                  textColor: myAppTheme.backgroundColor == Colors.white ? Colors.white : Colors.black,
                ),
              ),

              //Save Button
              Positioned(
                bottom: 50,
                left: MediaQuery
                    .of(context)
                    .size
                    .width * 0.5 - 60,
                child: primaryRaisedButton(
                  context: context,
                  text: "Register",
                  textColor: myAppTheme.backgroundColor == Colors.white ? Colors.white : Colors.black,
                  onPressed: () {
                    //Save
                    if (!_formGeneralKey.currentState.validate()) {
                      showSnackBar(scaffoldKey: _scaffoldKey, text: "Please fill in all th requried fields.");
                      return;
                    }



                  },
                ),
              )
            ],
          ),
        ),
    );
  }





}
