import 'package:flutter/material.dart';
import '../models/chat_user.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 22.0,
              child: ClipOval(
                child: Image.network(
                  widget.user.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  widget.user.lastActive,
                  style: const TextStyle(fontSize: 14),
                )
              ],
            ),
          ],
        ),
        leading: const BackButton(),
        elevation: 1,
        // bottom: PreferredSize(
        //   preferredSize:
        //       const Size.fromHeight(1), // Adjust the border height as needed
        //   child: Container(
        //     color:
        //         const Color.fromARGB(255, 205, 205, 205), // Color of the border
        //     height: .5, // Height of the border
        //   ),
        // ),
      ),
    );
  }
}
