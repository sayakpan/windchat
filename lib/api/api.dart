import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:windchat/api/encrypt_decrypt.dart';
import 'package:windchat/api/notification_api.dart';
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
      NotificationAPI.getPushToken();
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

  // // Function to Send a message
  // static Future<void> sendMessage(
  //     ChatUser sendtoUser, String msg, String type) async {
  //   // Taking sending time as message document id in firebase
  //   final time = DateTime.now().millisecondsSinceEpoch.toString();

  //   final message = Messages(
  //       msg: msg,
  //       toID: sendtoUser.id,
  //       read: '',
  //       type: type,
  //       sent: time,
  //       fromID: user.uid);

  //   final reference = firestore
  //       .collection('chats/${getConversationID(sendtoUser.id)}/messages');

  //   await reference.doc(time).set(message.toJson()).then((value) =>
  //       {NotificationAPI.sendPushNotification(sendtoUser, msg, type)});
  // }

  // Function to Send a message
  static Future<void> sendMessage(
      ChatUser sendtoUser, String msg, String type) async {
    // Taking sending time as message document id in firebase
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // Encrypt the message before sending
    String encryptedMsg;
    if(type=='text'){
     encryptedMsg = EncryptDecrypt.encryptAES(msg);
    }else{
      encryptedMsg=msg;
    }

    
    final message = Messages(
        msg: encryptedMsg,
        toID: sendtoUser.id,
        read: '',
        type: type,
        sent: time,
        fromID: user.uid);

    final reference = firestore
        .collection('chats/${getConversationID(sendtoUser.id)}/messages');

    await reference.doc(time).set(message.toJson()).then((value) =>
        {NotificationAPI.sendPushNotification(sendtoUser, msg, type)});
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

  // Delete messages
  static Future<void> deleteMessage(Messages message) async {
    await firestore
        .collection('chats/${getConversationID(message.toID)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == "image") {
      await storage.refFromURL(message.msg).delete();
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

  //************************* Contact Managing *****************************

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

    if (existingContact.exists && existingContact['status'] != "rejected") {
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

        ChatUser touser = ChatUser.fromJson(userdata.docs.first.data());
        NotificationAPI.sendConnectionRequestNotification(touser);
        return "added";
      } else {
        return "nouser";
      }
    }
  }

  // Get connection status
  static Future<String> getConnectionStatus(ChatUser checkuser) async {
    var checkuserdata = await firestore
        .collection('users')
        .where('email', isEqualTo: checkuser.email)
        .get();

    var existingContact = await firestore
        .collection('users')
        .doc(user.uid)
        .collection("contacts")
        .doc(checkuserdata.docs.first.id)
        .get();

    if (existingContact.exists) {
      return existingContact['status'];
    } else {
      return "nocontact";
    }
  }

  // Remove Contact
  static Future<void> removeContact(ChatUser otheruser) async {
    var otheruserdata = await firestore
        .collection('users')
        .where('email', isEqualTo: otheruser.email)
        .get();

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection("contacts")
        .doc(otheruserdata.docs.first.id)
        .delete();

    await firestore
        .collection('users')
        .doc(otheruserdata.docs.first.id)
        .collection("contacts")
        .doc(user.uid)
        .delete();
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

  //************************* Some Other Useful Methods *************************

  static bool validateEmail(String email) {
    email = email.trim().toLowerCase();
    if (EmailValidator.validate(email)) {
      return true;
    }
    return false;
  }
}
