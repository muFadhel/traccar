import 'package:dio/dio.dart';
import 'package:mfadhel/src/constants/base_url.dart';
import 'package:mfadhel/src/models/send_position_model.dart';

var dio = Dio();

Future<List<Object>> sendCurrentPositionToTraccar(
    SendPositionModel data) async {
  Response? response;

  try {
    dio.options.headers["authorization"] = data.token;

    response = await dio.post(POSITIONURL,
        queryParameters: {
          'id': data.deviceId,
          "lat": data.lat,
          "lon": data.lon
        },
        options: Options(
          validateStatus: (_) => true,
          responseType: ResponseType.json,
        ));
    return [true, response];
  } on DioError catch (e) {
    return [false, e.message];
  }
}
