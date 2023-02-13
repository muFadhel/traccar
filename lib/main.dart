import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mfadhel/src/constants/custom_colors.dart';
import 'package:mfadhel/src/providers/create_device_provider.dart';
import 'package:mfadhel/src/providers/send_position_provider.dart';
import 'package:mfadhel/src/providers/sign_in_provider.dart';
import 'package:mfadhel/src/providers/sign_up_provider.dart';
import 'package:provider/provider.dart';
import 'app_modular.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(ModularApp(module: AppModule(), child: const MyApp()));
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SignInProvider>(
          create: (context) => SignInProvider(),
        ),
        ChangeNotifierProvider<SignUpProvider>(
          create: (context) => SignUpProvider(),
        ),
        ChangeNotifierProvider<CreateDeviceProvider>(
          create: (context) => CreateDeviceProvider(),
        ),
        ChangeNotifierProvider<SendPositionProvider>(
          create: (context) => SendPositionProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Purean App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Cairo",
          primarySwatch: CustomColors.mainColorToMaterialColor,
        ),

        /// for app modular ///
        routeInformationParser: Modular.routeInformationParser,
        routerDelegate: Modular.routerDelegate,

        /// for localization ///
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
        ],
      ),
    );
  }
}
