import 'package:flutter/material.dart';
import 'package:windchat/main.dart';
import 'package:windchat/models/messages.dart';
import 'package:windchat/widgets/message_card.dart';
import '../api/api.dart';
import '../models/chat_user.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // For handling text field
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.blue.shade50,
          appBar: AppBar(
            title: InkWell(
              child: Row(
                children: [
                  //User Profile Image
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
                      //Username
                      Text(
                        widget.user.name,
                        style: const TextStyle(fontSize: 18),
                      ),

                      // Last Seen of User
                      const Text(
                        "last seen today at 2:23 pm",
                        // widget.user.lastActive,
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ],
              ),
            ),
            leading: const BackButton(),
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                color: Colors.grey,
                height: 0.5,
              ),
            ),
          ),
          body: Column(
            children: [
              _chatContent(),
              _chatSendBox(),
            ],
          )),
    );
  }

  Widget _chatContent() {
    return Expanded(
        child: StreamBuilder(
            stream: API.getAllMessages(widget.user),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  final msglist = data!
                      .map((element) => Messages.fromJson(element.data()))
                      .toList();

                  if (msglist.isNotEmpty) {
                    return ListView.builder(
                        itemCount: msglist.length,
                        padding: EdgeInsets.only(top: mq.height * 0.02),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: ((context, index) {
                          return MessageCard(message: msglist[index]);
                        }));
                  } else {
                    return const Center(
                        child: Text(
                      "Say 'Hello' 👋",
                      style: TextStyle(fontSize: 20),
                    ));
                  }
              }
            }));
  }

  Widget _chatSendBox() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mq.width * .02, vertical: mq.height * .01),
      child: Row(
        children: [
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                // Emoji Button
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.emoji_emotions,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                ),

                // Input Field
                Expanded(
                    child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: "type here...",
                    border: InputBorder.none,
                  ),
                )),

                // Gallery Button
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.image,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                ),

                // Camera Button
                Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  ),
                ),
              ]),
            ),
          ),

          // Send Button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                API.sendMessage(widget.user, _textController.text);
                _textController.text = '';
              }
            },
            shape: const CircleBorder(),
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 8),
            color: Colors.green,
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
