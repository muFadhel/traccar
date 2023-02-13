import 'package:dio/dio.dart';
import 'package:mfadhel/src/constants/base_url.dart';
import 'package:mfadhel/src/models/create_device_model.dart';

import '../constants/end_points.dart';

var dio = Dio();

Future<List<Object>> createDeviceInTraccar(CreateDeviceModel data) async {
  Response? response;

  try {
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = data.token;

    response = await dio.post(BASEURL + DEVICES,
        data: {'name': data.deviceName, "uniqueId": data.deviceId},
        options: Options(
          validateStatus: (_) => true,
        ));
    return [true, response];
  } on DioError catch (e) {
    return [false, e.message];
  }
}
