import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:windchat/api/api.dart';
import 'package:windchat/models/chat_user.dart';

class NotificationAPI {
  static FirebaseMessaging firemsg = FirebaseMessaging.instance;

  static get firestore => null;

  static Future<void> getPushToken() async {
    await firemsg.requestPermission();

    firemsg.getToken().then((token) async {
      if (token != null) {
        API.ownuser.pushToken = token;
        await firestore
            .collection('users')
            .doc(API.user.uid)
            .update({"push_token": API.ownuser.pushToken});
        log("getPushToken() : PushToken - ${API.ownuser.pushToken}");
      }
    });
  }

  static Map<String, Object> buildNotificationBody(
      ChatUser toUser, String msg, String type) {
    if (type == "image") {
      return {
        "to": toUser.pushToken,
        "notification": {
          "title": API.ownuser.name,
          "body": "📸 Image",
          "image": msg,
          "android_channel_id": "chats"
        },
      };
    } else {
      // Truncate msg if msg is too long
      if (msg.length > 100) {
        msg = msg.substring(0, 100);
        msg += '...';
      }
      return {
        "to": toUser.pushToken,
        "notification": {
          "title": API.ownuser.name,
          "body": msg,
          "android_channel_id": "chats"
        },
      };
    }
  }

  static Future<void> sendPushNotification(
      ChatUser toUser, String msg, String type) async {
    try {
      var serverkey =
          "AAAAQOw8RD4:APA91bGGiZP9iQ6Vjt6092i0tTllJh3Z39Ny-kQV2Qbf6bheN3dZdTZJRm5lZ9bHScqcxs8qttbl2njmcCoL527AInpKlZlnd2jMFzE8LjrL-621ggOyu0beoRkbd22Ah1fIyaD3rv6p";
      var body = buildNotificationBody(toUser, msg, type);

      var response = await post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(body),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "key=$serverkey"
          });
      log('sendPushNotification : Response status: ${response.statusCode}');
      log('sendPushNotification : Response body: ${response.body}');
    } catch (e) {
      log('sendPushNotification : ERROR - $e');
    }
  }

  static Future<void> sendConnectionRequestNotification(ChatUser toUser) async {
    try {
      var serverkey =
          "AAAAQOw8RD4:APA91bGGiZP9iQ6Vjt6092i0tTllJh3Z39Ny-kQV2Qbf6bheN3dZdTZJRm5lZ9bHScqcxs8qttbl2njmcCoL527AInpKlZlnd2jMFzE8LjrL-621ggOyu0beoRkbd22Ah1fIyaD3rv6p";
      var body = {
        "to": toUser.pushToken,
        "notification": {
          "title": "${API.ownuser.name} wants to connect",
          "body": "Tap to see the full profile",
          "android_channel_id": "chats"
        },
      };

      var response = await post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(body),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "key=$serverkey"
          });
      log('sendPushNotification : Response status: ${response.statusCode}');
      log('sendPushNotification : Response body: ${response.body}');
    } catch (e) {
      log('sendPushNotification : ERROR - $e');
    }
  }

  static Future<void> acceptedConnectionRequestNotification(
      ChatUser toUser) async {
    try {
      var serverkey =
          "AAAAQOw8RD4:APA91bGGiZP9iQ6Vjt6092i0tTllJh3Z39Ny-kQV2Qbf6bheN3dZdTZJRm5lZ9bHScqcxs8qttbl2njmcCoL527AInpKlZlnd2jMFzE8LjrL-621ggOyu0beoRkbd22Ah1fIyaD3rv6p";
      var body = {
        "to": toUser.pushToken,
        "notification": {
          "title": API.ownuser.name,
          "body": "accepted your connection request",
          "android_channel_id": "chats"
        },
      };

      var response = await post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(body),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "key=$serverkey"
          });
      log('sendPushNotification : Response status: ${response.statusCode}');
      log('sendPushNotification : Response body: ${response.body}');
    } catch (e) {
      log('sendPushNotification : ERROR - $e');
    }
  }
}
