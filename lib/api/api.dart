import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:windchat/models/chat_user.dart';
import 'package:windchat/models/messages.dart';

class API {
  // Used for firebase authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // Used for Accessing Firebase Cloud
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Used for Accessing Firebase Storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // Get the current user from Firebase Auth
  static User get user {
    return auth.currentUser!;
  }

  // Get the current user from Firebase Database
  static late ChatUser ownuser;

  // ownuser will store the Own logged in user details fetched from firebase database
  static Future<void> getOwnUser() async {
    await firestore.collection("users").doc(user.uid).get().then((value) {
      ownuser = ChatUser.fromJson(value.data()!);
      getPushToken();
    });
  }

  // Get All Users from Firebase
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection("users")
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // Check existing User
  static Future<bool> userExists() async {
    var documentSnapshot =
        await firestore.collection('users').doc(auth.currentUser!.uid).get();
    return documentSnapshot.exists;
  }

  // Check existing User
  static Future<void> createUser() async {
    // Get the current time
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatuser = ChatUser(
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: "Hi, it's me. 🥰",
        createdAt: time,
        lastActive: time,
        id: user.uid,
        isOnline: false,
        email: user.email.toString(),
        pushToken: '');
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatuser.toJson());
  }

  // Update User Data
  static Future<void> updateUser() async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({"about": ownuser.about});
  }

// ************************ ChatBox API ************************

// Function to create unique conversation id between sender and receiver
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

// Function to get all messages of a specific conversation
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser chatuser) {
    return firestore
        .collection('chats/${getConversationID(chatuser.id)}/messages')
        .snapshots();
  }

// Function to Send a message
  static Future<void> sendMessage(ChatUser sendtoUser, String msg) async {
    // Taking sending time as message document id in firebase
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final message = Messages(
        msg: msg,
        toID: sendtoUser.id,
        read: '',
        type: 'text',
        sent: time,
        fromID: user.uid);

    final reference = firestore
        .collection('chats/${getConversationID(sendtoUser.id)}/messages');

    await reference
        .doc(time)
        .set(message.toJson())
        .then((value) => {sendPushNotification(sendtoUser, msg)});
  }

// Mark messages as Read when viewed - Set Read Value with Time
  static Future<void> setMessageReadStatus(Messages message) async {
    firestore
        .collection('chats/${getConversationID(message.fromID)}/messages')
        .doc(message.sent)
        .update({"read": DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // Get the last message
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      ChatUser chatuser) {
    return firestore
        .collection('chats/${getConversationID(chatuser.id)}/messages')
        .orderBy("sent", descending: true)
        .limit(1)
        .snapshots();
  }

  //***********************************************************************
  //*************************                     *************************
  //*************************  Push Notification  *************************
  //*************************                     *************************
  //***********************************************************************

  static FirebaseMessaging firemsg = FirebaseMessaging.instance;

  static Future<void> getPushToken() async {
    await firemsg.requestPermission();

    firemsg.getToken().then((token) async {
      if (token != null) {
        ownuser.pushToken = token;
        await firestore
            .collection('users')
            .doc(user.uid)
            .update({"push_token": ownuser.pushToken});
        log(ownuser.pushToken);
      }
    });
  }

  static Future<void> sendPushNotification(ChatUser toUser, String msg) async {
    try {
      // Truncate msg if msg is too long
      if (msg.length > 100) {
        msg = msg.substring(0, 100);
        msg += '...';
      }

      var serverkey =
          "AAAAQOw8RD4:APA91bGGiZP9iQ6Vjt6092i0tTllJh3Z39Ny-kQV2Qbf6bheN3dZdTZJRm5lZ9bHScqcxs8qttbl2njmcCoL527AInpKlZlnd2jMFzE8LjrL-621ggOyu0beoRkbd22Ah1fIyaD3rv6p";
      final body = {
        "to": toUser.pushToken,
        "notification": {
          "title": ownuser.name,
          "body": msg,
          "android_channel_id": "chats"
        },
      };

      log(jsonEncode(body));

      var response = await post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(body),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "key=$serverkey"
          });
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (e) {
      log('\nERROR : sendPushNotification - $e');
    }
  }

  //***********************************************************************
  //*************************                     *************************
  //************************* Additional Features *************************
  //*************************                     *************************
  //***********************************************************************

  // Update Profile Image

  static Future<void> updateProfileImage(File imagefile) async {
    // Get the extension of image
    final extension = imagefile.path.split('.').last;
    // set the user id as image name
    final reference =
        storage.ref().child('profileimages/${user.uid}.$extension');

    // Image Size before compression
    log('Image Size : ${imagefile.lengthSync() / 1000} kb');

    // Compress the image in a temporary directory
    var tempDir = await getTemporaryDirectory();
    var targetPath = "${tempDir.path}/${user.uid}.$extension";

    var result = await FlutterImageCompress.compressAndGetFile(
      imagefile.absolute.path,
      targetPath,
      quality: 60,
    );
    await reference.putFile(File(result!.path)).then((p0) =>
        {log('Compressed Image Size : ${p0.bytesTransferred / 1000} kb')});
    ownuser.image = await reference.getDownloadURL();
    log('${ownuser.name} - Profile Image Updated\nImage URL : ${ownuser.image}');

    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': ownuser.image});
  }
}
