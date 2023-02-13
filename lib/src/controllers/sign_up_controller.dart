import 'package:dio/dio.dart';
import 'package:mfadhel/src/constants/base_url.dart';
import 'package:mfadhel/src/models/sign_up_model.dart';

import '../constants/end_points.dart';

var dio = Dio();

Future<List<Object>> signUpInToTraccar(SignUpModel data) async {
  Response? response;

  try {
    response = await dio.post(BASEURL + SIGNUP,
        data: {
          'name': data.name,
          "email": data.email,
          "phone": data.phone,
          "password": data.password
        },
        options: Options(
            validateStatus: (_) => true, contentType: Headers.jsonContentType));
    return [true, response];
  } on DioError catch (e) {
    return [false, e.message];
  }
}
