import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:mobi_user/Utility/MainColor.dart';

class CustomNotification {
  init() async {
    await AwesomeNotifications().initialize('resource://drawable/icon_notification', [
      //[
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: "Hi",
        playSound: true,
        channelShowBadge: true,
        enableVibration: true,
        defaultColor: Color(0xFFFFFFFF),
        ledColor: Colors.red,
        importance: NotificationImportance.High,
        defaultRingtoneType: DefaultRingtoneType.Notification,
      ),
    ]);
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  Future<void> createNotification(String title, String body) async {
    log("Firebase Messaging Coming Soon");
    var timeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        color: redColor,
        backgroundColor: whiteColor,
        wakeUpScreen: true,
        notificationLayout: NotificationLayout.BigText,
        displayOnBackground: true,
        displayOnForeground: true,
      ),
      schedule: NotificationInterval(interval: Duration(seconds: 1), timeZone: timeZone, repeats: true),
    );
  }
}
