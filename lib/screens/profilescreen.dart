import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:windchat/api/api.dart';
import 'package:windchat/helper/dialogs.dart';
import 'package:windchat/main.dart';
import 'package:windchat/models/chat_user.dart';
import 'package:windchat/screens/auth/loginscreen.dart';
import 'package:windchat/screens/settingsscreen.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // To be used in form
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // To Hide the Keyboard when click in the background
      onTap: () => FocusScope.of(context).unfocus(),

      // Scaffold From here
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff006df1),
          // toolbarHeight: mq.height * .09,
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '',
                  style: TextStyle(
                    fontSize: 25,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
              ],
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Colors.white), // Hamburger menu icon
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ), // Hamburger menu icon
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SettingsScreen(user: widget.user)));
              },
            ),
          ],
        ),
        body: Form(
          key: _formkey,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  child: Container(
                margin: EdgeInsets.only(bottom: mq.height * .72),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0xff0043ba), Color(0xff006df1)]),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    )),
              )),
              //Profile Picture and Edit Button
              Positioned(
                top: mq.height * .05,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 225, 225, 225),
                          width: 2.0,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 100.0,
                        backgroundImage: NetworkImage(widget.user.image),
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: MaterialButton(
                        onPressed: () {
                          _showModalBottom();
                        },
                        shape: const CircleBorder(),
                        color: Theme.of(context).primaryColorLight,
                        child: Icon(Icons.edit,
                            color: Theme.of(context).primaryColorDark),
                      ),
                    )
                  ],
                ),
              ),

              // Name
              Positioned(
                  top: mq.height * .31,
                  child: Text(
                    widget.user.name,
                    style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).primaryColorDark),
                  )),

              // Email
              Positioned(
                  top: mq.height * .38,
                  child: Text(
                    widget.user.email,
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColorDark),
                  )),

              //About Textform
              Positioned(
                top: mq.height * .45,
                height: mq.height * .15,
                width: mq.width * .7,
                child: TextFormField(
                  style: TextStyle(color: Theme.of(context).primaryColorDark),
                  initialValue: widget.user.about,
                  onSaved: (newValue) => API.ownuser.about = newValue!,
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : 'Write a cool about',
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.info,
                          color: Theme.of(context).primaryColor),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'eg. Hi, There !',
                      label: const Text(
                        'About',
                        style: TextStyle(fontSize: 22),
                      )),
                ),
              ),

              // Update Button
              Positioned(
                  top: mq.height * .55,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: Size(
                          mq.width * .3,
                          mq.height * .05,
                        )),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        log("Input Validated");
                        _formkey.currentState!.save();
                        API.updateUser().then((value) {
                          Dialogs.showSnackBar(
                              context, "Profile Updated", Colors.green);
                        });
                        log("User Data Updated");
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text(
                      "Update",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ))
            ],
          ),
        ),

        //Logout Button
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            Dialogs.showProgressBar(context);
            await API.updateOnlineStatus(false);
            await FirebaseAuth.instance.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value) {
                // To pop the dialog
                Navigator.pop(context);
                // To pop the homepage
                Navigator.pop(context);
                // To go to the Login page
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                log('Successfully Signed Out');
              });
            });
          },
          icon: const Icon(Icons.exit_to_app_rounded),
          label: const Text(
            "Logout",
            style: TextStyle(fontSize: 17),
          ),
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  _showModalBottom() {
    showModalBottomSheet(
        context: context,
        builder: ((context) {
          return SizedBox(
            height: mq.height * .35,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 20),
                  child: Text(
                    "Upload Profile Image",
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColorDark),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //From Gallery Upload Image button
                    ElevatedButton(
                        onPressed: () async {
                          // Pick an image.
                          final ImagePicker picker = ImagePicker();
                          final XFile? galleryphoto = await picker.pickImage(
                              source: ImageSource.gallery, imageQuality: 18);
                          logger.w('${galleryphoto?.path}');
                          API
                              .updateProfileImage(File(galleryphoto!.path))
                              .then((value) => {
                                    setState(() {
                                      // This will trigger a rebuild of the widget tree
                                    })
                                  });
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 3,
                            fixedSize: Size(mq.width * .3, mq.height * .135)),
                        child: Image.asset(
                          "assets/images/image-gallery.png",
                        )),

                    SizedBox(
                      width: mq.width * .12,
                    ),

                    //From Camera Upload Image button
                    ElevatedButton(
                        onPressed: () async {
                          // Capture a photo.
                          final ImagePicker picker = ImagePicker();
                          final XFile? cameraphoto = await picker.pickImage(
                              source: ImageSource.camera, imageQuality: 18);
                          logger.w('${cameraphoto?.path}');
                          API
                              .updateProfileImage(File(cameraphoto!.path))
                              .then((value) => {
                                    setState(() {
                                      // This will trigger a rebuild of the widget tree
                                    })
                                  });

                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 3,
                            fixedSize: Size(mq.width * .3, mq.height * .135)),
                        child: Image.asset(
                          "assets/images/camera.png",
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 35,
                  ),
                  child: Text(
                    "Don't worry, this will not change your gmail profile image.",
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).primaryColorDark),
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
