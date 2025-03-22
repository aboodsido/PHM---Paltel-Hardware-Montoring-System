import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _initLocalNotifications();
    await _requestIOSPermissions();

    FirebaseMessaging.onMessage.listen(_handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint("Refreshed token: $newToken");
    });
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        String? payload = response.payload;
      },
    );
  }

  Future<void> _requestIOSPermissions() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );
    }
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    debugPrint("Received message: ${message.messageId}");
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      final int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'fcm_channel_id',
            'FCM Notifications',
            channelDescription: 'Channel for FCM notifications',
            importance: Importance.max,
            priority: Priority.high,
          );
      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      );

      await _localNotificationsPlugin.show(
        id,
        notification.title,
        notification.body,
        notificationDetails,
        payload: message.data.isNotEmpty ? message.data.toString() : null,
      );
    }
  }

  Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    debugPrint('Notification caused app to open: ${message.messageId}');
    Get.toNamed(AppRoutes.DASHBOARD);
  }
}
