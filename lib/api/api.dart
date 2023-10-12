import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:windchat/models/chat_user.dart';
import 'package:windchat/models/messages.dart';

class API {
  // Used for firebase authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // Used for Accessing Firebase Cloud
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

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

    await reference.doc(time).set(message.toJson());
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
}
