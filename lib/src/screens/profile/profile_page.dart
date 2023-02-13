import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mfadhel/src/constants/custom_colors.dart';
import 'package:mfadhel/src/constants/perferences.dart';
import 'package:mfadhel/src/utils/navigation.dart';
import 'package:mfadhel/src/widgets/custom_message.dart';

import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map userData = {};

  @override
  void initState() {
    super.initState();

    /// get user data
    var prefUserData = Prefs.getUserData();
    prefUserData.then((value) => {
          setState(() {
            userData = jsonDecode(value);
          })
        });
  }

  /// item list
  renderItemList(icon, title, onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: CustomColors.mainColor.withOpacity(0.05),
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: CustomColors.mainColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(title)
              ],
            ),
            const Icon(
              Icons.chevron_right,
              color: CustomColors.mainColor,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.profileAppbar(context, "Profile", true),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(right: 20, left: 20, bottom: 35),
              child: userData.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Container(
                              padding: const EdgeInsets.all(1),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(75),
                                  border: Border.all(
                                      color: Colors.blueAccent, width: 2)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(75),
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          userData['name'],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          userData['phone'],
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomWidgets.generalButton("EDIT PROFILE", () {
                          CustomMessage.snackMessage(
                              "Something cool is coming soon!",
                              "info",
                              context);
                        }),
                        const SizedBox(
                          height: 30,
                        ),

                        /// profile list
                        renderItemList(
                            Icons.policy_outlined, "Terms & Conditions", () {
                          CustomMessage.snackMessage(
                              "Something cool is coming soon!",
                              "info",
                              context);
                        }),
                        renderItemList(Icons.logout, "Sign Out", () async {
                          Prefs.clearAllPrefs();
                          CustomMessage.snackMessage(
                              "You have successfully logout",
                              "success",
                              context);
                          CustomNavigation.navigateTo("/sign_in");
                        }),
                      ],
                    )
                  : Container(),
            ),
          ),
        ),
      ),
    );
  }
}
