import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:windchat/helper/custom_chat_theme.dart';
import 'package:windchat/helper/dialogs.dart';
import 'package:windchat/main.dart';
import 'package:windchat/models/chat_user.dart';
import 'package:windchat/screens/auth/loginscreen.dart';
import 'package:windchat/screens/auth/pref.dart';
import 'package:windchat/screens/profilescreen.dart';

class SettingsScreen extends StatefulWidget {
  final ChatUser user;
  const SettingsScreen({super.key, required this.user});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Settings',
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Hamburger menu icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            // User card
            BigUserCard(
                backgroundColor: Theme.of(context).primaryColor,
                userName: widget.user.name,
                userProfilePic: NetworkImage(widget.user.image),
                cardActionWidget: SettingsItem(
                  icons: Icons.edit,
                  iconStyle: IconStyle(
                    withBackground: true,
                    borderRadius: 50,
                    backgroundColor: Colors.yellow[600],
                  ),
                  title: "See Details",
                  subtitle: "Tap to see profile details",
                  subtitleStyle:
                      TextStyle(color: Theme.of(context).primaryColorDark),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(user: widget.user)));
                  },
                ),
                userMoreInfo: Container(
                  margin: const EdgeInsets.only(top: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(
                      color: widget.user.isOnline
                          ? Colors.green.shade300
                          : Colors.red,
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    widget.user.isOnline ? "Online" : "Offline",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.user.isOnline
                          ? Colors.green.shade300
                          : Colors.red,
                    ),
                  ),
                )),
            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () {},
                  icons: CupertinoIcons.pencil_outline,
                  iconStyle: IconStyle(
                    backgroundColor: Colors.red,
                  ),
                  title: 'Appearance',
                  subtitle: "Set the chat appearance",
                  subtitleStyle:
                      TextStyle(color: Theme.of(context).primaryColorDark),
                ),
                SettingsItem(
                  onTap: () {},
                  icons: Icons.dark_mode_rounded,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: const Color.fromARGB(255, 86, 86, 86),
                  ),
                  title: 'Dark mode',
                  subtitle: "Automatic",
                  subtitleStyle:
                      TextStyle(color: Theme.of(context).primaryColorDark),
                  trailing: Switch(
                    value: Get.isDarkMode,
                    onChanged: (value) async {
                      Get.changeTheme(Get.isDarkMode
                          ? CustomTheme.lighttheme
                          : CustomTheme.darkTheme);
                      Pref.isDarkMode = !Pref.isDarkMode;
                      logger.e("Dark Mode : ${!Get.isDarkMode}");
                    },
                  ),
                ),
              ],
            ),
            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () {},
                  icons: Icons.info_rounded,
                  iconStyle: IconStyle(
                    backgroundColor: Colors.purple,
                  ),
                  title: 'About',
                  subtitle: "Learn more about WindChat",
                  subtitleStyle:
                      TextStyle(color: Theme.of(context).primaryColorDark),
                ),
              ],
            ),
            // You can add a settings title
            SettingsGroup(
              settingsGroupTitle: "  Account",
              settingsGroupTitleStyle: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              items: [
                SettingsItem(
                  onTap: () async {
                    Dialogs.showProgressBar(context);
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
                        logger.w('Successfully Signed Out');
                      });
                    });
                  },
                  icons: Icons.exit_to_app_rounded,
                  title: "Sign Out",
                ),
                SettingsItem(
                  onTap: () {},
                  icons: CupertinoIcons.delete_solid,
                  title: "Delete account",
                  subtitle: "All your chats will be deleted",
                  subtitleStyle: const TextStyle(color: Colors.red),
                  titleStyle: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
