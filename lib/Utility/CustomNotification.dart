import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomNotification {
  init() async {
    //'resource://drawable/icon_notification'
    //'resource://drawable/ic_launcher'
    await AwesomeNotifications().initialize(null, [
      //[
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: "Hi",
        playSound: true,
        channelShowBadge: true,
        enableVibration: true,
        defaultColor: Color(0xFF1E1E1E),
        groupAlertBehavior: GroupAlertBehavior.All,
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

  Map<String, String> parseNotificationBody(String body) {
    if (body.contains("Market Result")) {
      final match = RegExp(r'Market Result[:-]?\s*(.+)', caseSensitive: false).firstMatch(body);
      if (match != null) {
        final code = match.group(1)?.trim() ?? "";
        return {"title": "Market Result", "code": "<b><i>$code</i></b>"};
      }
    }
    return {"title": "", "code": body};
  }

  Future<void> createNotification(String title, String body) async {
    final prefs = await SharedPreferences.getInstance();
    final showNotification = prefs.getBool("show_notification") ?? true;

    if (!showNotification) {
      print("Notifications are OFF. Skipping notification.");
      return; // ❌ Skip creating notification
    }

    log("Firebase Messaging Coming Soon");
    var timeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    final parsed = parseNotificationBody(body);
    final isMarketResult = parsed['title'] == "Market Result";
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: '<b>$title</b>',
        body: isMarketResult ? '${parsed['title']}: <b><i>${parsed['code']}</i></b>' : parsed['code'],
        notificationLayout: NotificationLayout.BigPicture,
        bigPicture:
            title.contains("Deposit Reminder")
                ? "${Constants.baseUrl}/low-balance.png"
                : title.contains("Congratulations")
                ? '${Constants.baseUrl}/WINNER.png'
                : null,
        largeIcon: "asset://asset/icons/logo.png",
        backgroundColor: Color(0xFF16172B),
        color: Colors.white,
        summary: title.contains("Congratulations") ? 'You Won This Bet! Congrats ...!' : "Click, to check",
        wakeUpScreen: true,
        displayOnForeground: true,
        displayOnBackground: true,
      ),
    );
  }
}
