import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mfadhel/src/controllers/send_position_controller.dart';
import 'package:mfadhel/src/models/send_position_model.dart';

class SendPositionProvider extends ChangeNotifier {
  bool loading = false;
  late Map data;

  Future<void> postData(SendPositionModel body) async {
    loading = true;
    notifyListeners();
    List<Object> response = (await sendCurrentPositionToTraccar(body));

    if (response[0] == true) {
      Response lastRes = response[1] as Response;
      if (lastRes.statusCode == 200) {
        data = {
          "message": "Your positions sent",
          "success": lastRes.statusCode
        };
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
