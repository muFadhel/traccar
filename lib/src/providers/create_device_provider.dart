import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mfadhel/src/controllers/create_device_controller.dart';
import 'package:mfadhel/src/models/create_device_model.dart';

class CreateDeviceProvider extends ChangeNotifier {
  bool loading = false;
  late Map data;

  Future<void> postData(CreateDeviceModel body) async {
    loading = true;
    notifyListeners();
    List<Object> response = (await createDeviceInTraccar(body));

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
