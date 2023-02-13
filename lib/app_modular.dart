import 'package:flutter_modular/flutter_modular.dart';
import 'package:mfadhel/src/screens/home/home_page.dart';
import 'package:mfadhel/src/screens/profile/profile_page.dart';
import 'package:mfadhel/src/screens/signin/sign_in_page.dart';
import 'package:mfadhel/src/screens/signup/sign_up_page.dart';
import 'src/screens/splash/splash_page.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/',
            child: (context, args) => const SplashPage(),
            transition: TransitionType.noTransition),
        ChildRoute('/sign_up',
            child: (context, args) => const SignUpPage(),
            transition: TransitionType.noTransition),
        ChildRoute('/sign_in',
            child: (context, args) => const SignInPage(),
            transition: TransitionType.noTransition),
        ChildRoute('/home',
            child: (context, args) => const HomePage(),
            transition: TransitionType.noTransition),
        ChildRoute('/profile',
            child: (context, args) => const ProfilePage(),
            transition: TransitionType.noTransition),
      ];
}
