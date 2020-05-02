import 'package:flutter/material.dart';
import 'package:hts/main.dart';
import 'package:hts/services/auth.dart';
import 'package:hts/widgets/appbar.dart';
import 'package:hts/widgets/dialogboxes.dart';

import 'navigate_to_screen.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //TODO: the screens.Notifications list does not update after returning back to this screen
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar:
          getAppBar(scaffoldKey: scaffoldKey, context: context, strAppBarTitle: "Notifications", showBackButton: true),
      body: userNotifications.length > 0
          ? Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    //Mark all notifications as read
                    IconButton(
                      icon: Icon(Icons.done_all),
                      onPressed: () async {
                        //clear all the notifications
                        showSnackBar(scaffoldKey: scaffoldKey, text: "Marking all the notifications as read...");
                        //Mark all as read
                        userNotifications.forEach((key, value) {
                          Map mapValue = value;
                          mapValue["read"] = true;
                        });
                        //update the database
                        await authService.setData();

                        setState(() {});
                      },
                    ),

                    //Delete all notifications
                    IconButton(
                      icon: Icon(Icons.clear_all),
                      onPressed: () async {
                        //clear all the notifications
                        showSnackBar(scaffoldKey: scaffoldKey, text: "Clearing all the notifications...");
                        //Mark all as read
                        userNotifications.forEach((key, value) {
                          Map mapValue = value;
                          mapValue["read"] = true;
                        });
                        userNotifications.clear();

                        //update the database
                        await authService.setData();

                        setState(() {});
                      },
                    ),
                  ],
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                      itemCount: userNotifications.length,
                      itemBuilder: (context, index) {
                        //Get the Notification receiving datetime
                        DateTime _dtDate;
                        try {
                          _dtDate = userNotifications.keys.elementAt(index).toDate();
                        } catch (e) {
                          _dtDate = DateTime.parse(userNotifications.keys.elementAt(index).toString());
                        }

                        //Get the Notification Data
                        Map mapNotif = userNotifications.values.elementAt(index)["notification"];
                        Map mapData = userNotifications.values.elementAt(index)["data"];
                        bool read = false;
                        if (userNotifications.values.elementAt(index)["read"] == true) read = true;

                        if (mapData == null) return Container();

                        return Container(
                          color: read ? Colors.white : Colors.grey,
                          child: ListTile(
                            title: Text(
                              mapNotif["title"].toString(),
                              style: myAppTheme.textTheme.caption,
                            ),
                            subtitle: Text(
                              mapNotif["body"].toString(),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                //Time
                                Text(
                                  _dtDate.hour.toString() + ":" + _dtDate.minute.toString(),
                                ),
                                //Date
                                Text(
                                  _dtDate.day.toString() +
                                      "/" +
                                      _dtDate.month.toString() +
                                      "/" +
                                      _dtDate.year.toString().substring(2),
                                ),
                              ],
                            ),
                            dense: true,
                            onTap: () async {
                              showLoading(context);

                              //First, mark the notification as read
                              userNotifications.values.elementAt(index)["read"] = true;
                              //Update the database
                              await authService.setData();

                              Navigator.of(context, rootNavigator: true).pop();

                              //Navigate to the appropriate screen
                              NavigateToScreen(userNotifications.values.elementAt(index));
                            },
                            onLongPress: () async {
                              //Mark the Notification as read/unread
                              if ((await showDialog(
                                    context: context,
                                    builder: (context) => new AlertDialog(
                                      title: Text("Notification"),
                                      content: Text("Mark the notification as " + (read ? " unread ?" : "read ?")),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: new Text('No'),
                                        ),
                                        FlatButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: new Text('Yes'),
                                        ),
                                      ],
                                    ),
                                  )) ??
                                  false) {
                                //First, mark the notification as read/unread
                                userNotifications.values.elementAt(index)["read"] = !read;
                                //Update the database
                                await authService.setData();

                                setState(() {});
                              }
                            },
                          ),
                        );
                      },
                    )),
              ],
            )
          : Center(
              child: Text(
                "No screens.Notifications",
                style: myAppTheme.textTheme.caption.copyWith(color: Colors.grey),
              ),
            ),
    );
  }
}
