import 'package:about/about.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:windchat/api/api.dart';
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
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: Pref.isOnlineEnabled
                        ? Colors.green.shade500
                        : Colors.red,
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(
                      color: Pref.isOnlineEnabled
                          ? Colors.green.shade500
                          : Colors.red,
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    Pref.isOnlineEnabled ? "Online" : "Offline",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )),
            SettingsGroup(
              items: [
                // Chat Screen Theme Specifier
                SettingsItem(
                  onTap: () {
                    chooseMsgColor();
                  },
                  icons: CupertinoIcons.pencil_outline,
                  iconStyle: IconStyle(
                    backgroundColor: Colors.red,
                  ),
                  title: 'Chat Theme',
                  subtitle: "Select message style",
                  subtitleStyle:
                      TextStyle(color: Theme.of(context).primaryColorDark),
                ),

                // Message Theme Specifier
                SettingsItem(
                  onTap: () {
                    chooseChatColor();
                  },
                  icons: CupertinoIcons.wand_stars,
                  iconStyle: IconStyle(
                    backgroundColor: Colors.blue,
                  ),
                  title: 'Chat Background',
                  subtitle: "Select background style for chats",
                  subtitleStyle:
                      TextStyle(color: Theme.of(context).primaryColorDark),
                ),

                // Dark Mode Toggle
                SettingsItem(
                  onTap: () {
                    Get.changeTheme(Pref.isDarkMode
                        ? CustomTheme.lighttheme
                        : CustomTheme.darkTheme);
                    Pref.isDarkMode = !Pref.isDarkMode;
                    logger.e("Dark Mode : ${!Get.isDarkMode}");
                  },
                  icons: Icons.dark_mode_rounded,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: const Color.fromARGB(255, 86, 86, 86),
                  ),
                  title: 'Dark mode',
                  subtitle: "Reduces eye strain at night",
                  subtitleStyle:
                      TextStyle(color: Theme.of(context).primaryColorDark),
                  trailing: Switch(
                    value: Pref.isDarkMode,
                    onChanged: (value) async {
                      Get.changeTheme(Pref.isDarkMode
                          ? CustomTheme.lighttheme
                          : CustomTheme.darkTheme);
                      Pref.isDarkMode = !Pref.isDarkMode;
                      logger.e("Dark Mode : ${!Get.isDarkMode}");
                    },
                  ),
                ),

                // Active Status Toggle
                SettingsItem(
                  onTap: () {},
                  icons: Icons.online_prediction,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.green,
                  ),
                  title: 'Active Status',
                  subtitle: "Turn it off to go offline",
                  subtitleStyle:
                      TextStyle(color: Theme.of(context).primaryColorDark),
                  trailing: Switch(
                    value: Pref.isOnlineEnabled,
                    onChanged: (value) async {
                      setState(() {
                        Pref.isOnlineEnabled = !Pref.isOnlineEnabled;
                      });
                      API.updateOnlineStatus(Pref.isOnlineEnabled);
                      logger.e(Pref.isOnlineEnabled);
                    },
                  ),
                ),
              ],
            ),

            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () {
                    showAboutDialog();
                  },
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

  // Dialog box to choose chat background
  void chooseChatColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 5),
        title: Row(
          children: [
            Icon(
              CupertinoIcons.wand_stars,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
            Text(
              "   Choose Chat Theme",
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).primaryColorDark),
            )
          ],
        ),
        content: SizedBox(
          height: mq.height * .08,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: CustomTheme.chatThemeGradient.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  // Handle color selection here
                  logger.e(index);
                  Pref.gradientIndex = index;
                  Navigator.pop(context);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    gradient: CustomTheme.chatThemeGradient[index],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                            0.2), // Color and opacity of the shadow
                        spreadRadius: 2, // Spread radius
                        blurRadius: 4, // Blur radius
                        offset: const Offset(0, 5), // Offset from the container
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Dialog box to choose Message background
  void chooseMsgColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 5),
        title: Row(
          children: [
            Icon(
              CupertinoIcons.pencil_outline,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
            Text(
              "   Choose Chat Theme",
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).primaryColorDark),
            )
          ],
        ),
        content: SizedBox(
          height: mq.height * .08,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: CustomTheme.msgThemeGradient.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  // Handle color selection here
                  logger.e(index);
                  Pref.gradientIndexForMsg = index;
                  Navigator.pop(context);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    gradient: CustomTheme.msgThemeGradient[index],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                            0.2), // Color and opacity of the shadow
                        spreadRadius: 2, // Spread radius
                        blurRadius: 4, // Blur radius
                        offset: const Offset(0, 5), // Offset from the container
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // About Dialog
  void showAboutDialog() {
    showAboutPage(
      dialog: true,
      context: context,
      title: Text(
        "About",
        style: TextStyle(color: Theme.of(context).primaryColorDark),
      ),
      values: {
        'version': '1.0',
        'year': DateTime.now().year.toString(),
      },
      applicationLegalese: 'Copyright © Sayak, {{ year }}',
      applicationDescription: Text(
          'WindChat is your gateway to effortless and secure communication. Powered by Flutter and Firebase, WindChat offers real-time messaging, chat requests, and user-friendly profiles. Take control of your chat experience with our approval system. Enjoy status indicators, personalized profiles, and timely push notifications.',
          style: TextStyle(color: Theme.of(context).primaryColorDark),
          textAlign: TextAlign.justify),
      children: const <Widget>[
        LicensesPageListTile(
          icon: Icon(CupertinoIcons.doc_text),
        ),
      ],
      applicationIcon: const SizedBox(
        width: 100,
        height: 100,
        child: Image(
          image: AssetImage('assets/images/logo.png'),
        ),
      ),
    );
  }
}
