import 'package:dio/dio.dart';
import 'package:mfadhel/src/constants/base_url.dart';

import '../constants/end_points.dart';
import '../models/sign_in_model.dart';

var dio = Dio();

Future<List<Object>> signIntoTraccar(SignInModel data) async {
  Response? response;

  try {
    response = await dio.post(BASEURL + SIGNIN,
        data: {'email': data.username, "password": data.password},
        options: Options(
          validateStatus: (_) => true,
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.json,
        ));
    return [true, response];
  } on DioError catch (e) {
    return [false, e.message];
  }
}
