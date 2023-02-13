import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:mfadhel/src/constants/custom_colors.dart';
import '../../constants/perferences.dart';
import '../../utils/navigation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Prefs.clearAllPrefs();
    Future.delayed(const Duration(milliseconds: 2000), () {
      var currentPage = Prefs.getInitPage();
      currentPage.then((value) => {
            navigateTo(value),
          });
    });
  }

  navigateTo(value) {
    if (value.runtimeType == Null) {
      /// login page
      debugPrint('login page');
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        // navigation bar color
        systemNavigationBarDividerColor: Colors.white,
        /// Navigation bar divider color
        systemNavigationBarIconBrightness: Brightness.dark, //navigation bar icon
      ));
      CustomNavigation.navigateTo("/sign_in");
    } else {
      /// home
      debugPrint("home");
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        // navigation bar color
        systemNavigationBarDividerColor: Colors.white,
        //Navigation bar divider color
        systemNavigationBarIconBrightness: Brightness.dark, //navigation bar icon
      ));
      CustomNavigation.navigateTo("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: CustomColors.mainColor,
            // <-- SEE HERE
            statusBarIconBrightness: Brightness.light,
            //<-- For Android SEE HERE (dark icons)
            statusBarBrightness: Brightness.dark,
            //<-- For iOS SEE HERE (dark icons)
          ),
          backgroundColor: CustomColors.mainColor,
          elevation: 0,
          toolbarHeight: 70,
        ),
        backgroundColor: CustomColors.mainColor,
        body: AnnotatedRegion(
          value: const SystemUiOverlayStyle(
            systemNavigationBarColor: CustomColors.mainColor,
            // navigation bar color
            systemNavigationBarDividerColor: CustomColors.mainColor,
            //Navigation bar divider color
            systemNavigationBarIconBrightness: Brightness.light, //n
          ),
          child: Center(
            child: SizedBox(
              width: 190,
              height: 190,
              child: Lottie.asset('assets/files/splash.json'),
            ),
          ),
        ));
  }
}
