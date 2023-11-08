import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:windchat/main.dart';
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

  // Get All Users from Firebase
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsersByIdList(
      List<String> idlist) {
    return firestore
        .collection("users")
        .where('id', whereIn: idlist)
        .snapshots();
  }

  // Get My Contacts only from Firebase
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyContactUsers() {
    return firestore
        .collection("users")
        .doc(user.uid)
        .collection("contacts")
        .where("status",
            whereNotIn: ["requested", "rejected", "newrequest"]).snapshots();
  }

  // Get My Contacts only from Firebase
  static Stream<QuerySnapshot<Map<String, dynamic>>> getPendingRequestUsers() {
    return firestore
        .collection("users")
        .doc(user.uid)
        .collection("contacts")
        .where("status", whereIn: ["newrequest"]).snapshots();
  }

  // Add Friend User
  static Future<String> addNewContact(String email) async {
    // trim email for space and small letters
    email = email.trim().toLowerCase();

    var userdata = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    var existingContact = await firestore
        .collection('users')
        .doc(user.uid)
        .collection("contacts")
        .doc(userdata.docs.first.id)
        .get();

    if (existingContact.exists) {
      if (existingContact['status'] == "requested") {
        return "requested";
      } else if (existingContact['status'] == "newrequest") {
        return "newrequest";
      } else {
        return "existing";
      }
    } else {
      if (userdata.docs.isNotEmpty && userdata.docs.first.id != user.uid) {
        firestore
            .collection('users')
            .doc(user.uid)
            .collection("contacts")
            .doc(userdata.docs.first.id)
            .set({"email": email, "status": "requested"});
        firestore
            .collection('users')
            .doc(userdata.docs.first.id)
            .collection("contacts")
            .doc(user.uid)
            .set({"email": user.email, "status": "newrequest"});
        return "added";
      } else {
        return "nouser";
      }
    }
  }

  // Accept a Friend User
  static Future<void> acceptOrRejectNewContact(
      ChatUser requestedUser, String status) async {
    firestore
        .collection('users')
        .doc(user.uid)
        .collection("contacts")
        .doc(requestedUser.id)
        .update({"status": status});
    firestore
        .collection('users')
        .doc(requestedUser.id)
        .collection("contacts")
        .doc(user.uid)
        .update({"status": status});
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

  //************************ ChatBox API ************************

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
  static Future<void> sendMessage(
      ChatUser sendtoUser, String msg, String type) async {
    // Taking sending time as message document id in firebase
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final message = Messages(
        msg: msg,
        toID: sendtoUser.id,
        read: '',
        type: type,
        sent: time,
        fromID: user.uid);

    final reference = firestore
        .collection('chats/${getConversationID(sendtoUser.id)}/messages');

    await reference
        .doc(time)
        .set(message.toJson())
        .then((value) => {sendPushNotification(sendtoUser, msg, type)});
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

  // Last seen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getChatUserInfo(
      ChatUser chatuser) {
    return firestore
        .collection('users')
        .where("id", isEqualTo: chatuser.id)
        .snapshots();
  }

  // Online status update
  static Future<void> updateOnlineStatus(bool isonline) async {
    firestore.collection('users').doc(user.uid).update({
      "is_online": isonline,
      "last_active": DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  //*************************  Push Notification  *************************

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
        log("getPushToken() : PushToken - ${ownuser.pushToken}");
      }
    });
  }

  static Map<String, Object> buildNotificationBody(
      ChatUser toUser, String msg, String type) {
    if (type == "image") {
      return {
        "to": toUser.pushToken,
        "notification": {
          "title": ownuser.name,
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
          "title": ownuser.name,
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

  //************************* Additional Features *************************

  // Update Profile Image
  static Future<void> updateProfileImage(File imagefile) async {
    // Get the extension of image
    final extension = imagefile.path.split('.').last;
    // set the user id as image name
    final reference =
        storage.ref().child('profileimages/${user.uid}.$extension');

    await reference.putFile(File(imagefile.path)).then((p0) => {
          logger.w(
              'Compressed Profile Image Size : ${p0.bytesTransferred / 1000} kb')
        });
    ownuser.image = await reference.getDownloadURL();
    logger.w(
        '${ownuser.name} - Profile Image Updated\nImage URL : ${ownuser.image}');

    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': ownuser.image});
  }

  // Send Images
  static Future<void> sendImages(ChatUser toUser, File imagefile) async {
    final extension = imagefile.path.split('.').last;
    final reference = storage.ref().child(
        'images/${getConversationID(toUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$extension');

    logger.w('Image Size : ${imagefile.lengthSync() / 1000} kb');

    await reference.putFile(File(imagefile.path)).then((p0) =>
        {logger.w('Uploaded Image Size : ${p0.bytesTransferred / 1000} kb')});

    final imageURL = await reference.getDownloadURL();
    await sendMessage(toUser, imageURL, "image");
  }

  //************************* Some Other Useful Methods *************************

  static bool validateEmail(String email) {
    email = email.trim().toLowerCase();
    if (EmailValidator.validate(email)) {
      return true;
    }
    return false;
  }
}
