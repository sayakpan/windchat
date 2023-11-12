import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:windchat/helper/custom_chat_theme.dart';
import 'package:windchat/helper/mydateutility.dart';
import 'package:windchat/main.dart';
import 'package:windchat/models/messages.dart';
import 'package:windchat/screens/auth/pref.dart';
import 'package:windchat/screens/contactprofilescreen.dart';
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
  bool _showEmoji = false;
  bool _isImageUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_showEmoji) {
            setState(() {
              _showEmoji = !_showEmoji;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                ContactProfileScreen(user: widget.user))));
                  },
                  child: StreamBuilder(
                    stream: API.getChatUserInfo(widget.user),
                    builder: (context, snapshot) {
                      final chatUserInfo = snapshot.data?.docs;
                      final chatUserlist = chatUserInfo
                              ?.map((element) =>
                                  ChatUser.fromJson(element.data()))
                              .toList() ??
                          [];

                      return Row(
                        children: [
                          //User Profile Image
                          CircleAvatar(
                            radius: 22.0,
                            child: ClipOval(
                              child: Image.network(
                                chatUserlist.isNotEmpty
                                    ? chatUserlist[0].image
                                    : widget.user.image,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
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
                                chatUserlist.isNotEmpty
                                    ? chatUserlist[0].name
                                    : widget.user.name,
                                style: const TextStyle(fontSize: 18),
                              ),

                              // Last Seen of User
                              Text(
                                chatUserlist.isNotEmpty
                                    ? chatUserlist[0].isOnline
                                        ? "Online"
                                        : MyDateUtility.getLastActiveTime(
                                            context: context,
                                            lastActive:
                                                chatUserlist[0].lastActive)
                                    : MyDateUtility.getLastActiveTime(
                                        context: context,
                                        lastActive: widget.user.lastActive),
                                style: const TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                        ],
                      );
                    },
                  )),
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
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient:
                    CustomTheme.customChatBGTheme(Pref.gradientIndex, context),
              ),
              child: Column(
                children: [
                  _chatContent(),
                  if (_isImageUploading)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: mq.width * .03, right: mq.width * .03),
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(50),
                            backgroundColor:
                                const Color.fromARGB(255, 255, 175, 36),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 255, 116, 41)),
                          )),
                    ),
                  _chatSendBox(),
                  if (_showEmoji)
                    SizedBox(
                      height: mq.height * .35,
                      child: EmojiPicker(
                          textEditingController: _textController,
                          config: Config(
                            columns: 8,
                            emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : .8),
                          )),
                    )
                ],
              ),
            )),
      ),
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
                  // to show latest at the bottom everytime a new message is received
                  final reversedMessages = msglist.reversed.toList();

                  if (msglist.isNotEmpty) {
                    return ListView.builder(
                        reverse: true,
                        itemCount: reversedMessages.length,
                        padding: EdgeInsets.only(top: mq.height * 0.02),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: ((context, index) {
                          return MessageCard(message: reversedMessages[index]);
                        }));
                  } else {
                    return Center(
                        child: Text(
                      "Say 'Hello' 👋",
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColorDark),
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
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                // Emoji Button
                IconButton(
                  onPressed: () {
                    setState(() {
                      FocusScope.of(context).unfocus();
                      _showEmoji = !_showEmoji;
                    });
                  },
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
                  onTap: () {
                    setState(() {
                      _showEmoji = false;
                    });
                  },
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 3,
                  style: TextStyle(color: Theme.of(context).primaryColorDark),
                  decoration: const InputDecoration(
                    hintText: "type here...",
                    border: InputBorder.none,
                  ),
                )),

                // Gallery Button
                IconButton(
                  onPressed: () async {
                    // Pick Multiple images from gallery
                    final ImagePicker picker = ImagePicker();
                    final List<XFile> galleryimages =
                        await picker.pickMultiImage(imageQuality: 18);
                    setState(() => _isImageUploading = true); // Starting Upload
                    for (var image in galleryimages) {
                      await API.sendImages(widget.user, File(image.path));
                    }
                    setState(() {
                      _isImageUploading = false;
                    }); // Finished Upload
                  },
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
                    onPressed: () async {
                      // Capture a photo.
                      final ImagePicker picker = ImagePicker();
                      final XFile? cameraphoto = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 18);
                      setState(
                          () => _isImageUploading = true); // Starting Upload

                      await API.sendImages(
                          widget.user, File(cameraphoto!.path));
                      setState(() {
                        _isImageUploading = false;
                      }); // Finished Upload
                    },
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
                API.sendMessage(widget.user, _textController.text, "text");
                _textController.text = '';
              }
            },
            shape: const CircleBorder(),
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 8),
            color: Colors.green,
            elevation: 5,
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
