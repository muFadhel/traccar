import 'package:flutter_modular/flutter_modular.dart';

class CustomNavigation {
  static navigateTo(path) {
    Modular.to.navigate(path);
  }

  static pushTo(path) {
    Modular.to.pushNamed(path);
  }

  static goBack() {
    Modular.to.pop();
  }
}
