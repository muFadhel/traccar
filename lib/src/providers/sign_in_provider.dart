import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../controllers/sign_in_controller.dart';
import '../models/sign_in_model.dart';

class SignInProvider extends ChangeNotifier {
  bool loading = false;
  late Map data;

  Future<void> postData(SignInModel body) async {
    loading = true;
    notifyListeners();
    List<Object> response = (await signIntoTraccar(body));

    if (response[0] == true) {
      Response lastRes = response[1] as Response;
      if (lastRes.statusCode == 200) {
        data = lastRes.data;
      } else {
        data = {
          "message": "Please verify the data entered and try again",
          "error": lastRes.statusCode
        };
      }
    } else {
      data = {"message": "unauthorized", "error": 401};
    }

    loading = false;
    notifyListeners();
  }
}
