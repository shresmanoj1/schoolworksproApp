import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:schoolworkspro_app/helper/navigation_handler.dart';
import 'package:schoolworkspro_app/response/notification_response.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static BuildContext? context;
  // static
  static void initialize() {

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/launcher_icon"),
        iOS: IOSInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        ));

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? route) async {
          if (route != null) {
            // Navigator.of(context).pushNamed('/');

            try{
              notificationClickHandler(context!,  Notificationss(
                path: route.toString()
              ));
            }catch(e){print("ERR NOTIFICATION :: " + e.toString());}
          }

        });
  }

  static void display(RemoteMessage message, BuildContext _context) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      context = _context;
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
              "schoolworkspro", "schoolworkspro channel",
              channelDescription: "this is our channel",
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              enableVibration: true),
          iOS: IOSNotificationDetails(
            presentBadge: true,
            presentSound: true,
            presentAlert: true,
          ));

      await _notificationsPlugin.show(id, message.notification!.title,
          message.notification!.body, notificationDetails,
          payload: message.data["path"]);
    } on Exception catch (e) {
      print(e);
      // TODO
    }
  }
}