import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:windchat/models/chat_user.dart';

class API {
  // Used for firebase authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // Used for Accessing Firebase Cloud
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Get the current user
  static User get user {
    return auth.currentUser!;
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
        about: "Hi There !",
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
}
