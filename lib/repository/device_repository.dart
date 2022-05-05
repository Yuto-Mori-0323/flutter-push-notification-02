import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
// import 'package:cookie_jar/cookie_jar.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'dart:convert' as convert;
import '../setting.dart';

class DeviceRepository {
  final dio = new Dio();
  final url = Setting().domain + "api/device";

  postDeviceToken(token, cookies) async {
    var payload = {
      "device_token": token
    };
    var data = await dio.post(
      url,
      data: new FormData.fromMap(
          payload
      ),
      options: Options(
          headers: {
            // 'Cookie': '_ga=GA1.1.164609423.1616221655; user.id=MzAwMDE%3D--63f53069813f58d3bf5a9b7aa937acda4432e85f; remember_user_token=W1szMDAwMV0sIiQyYSQxMCR4dVJueldkNlVka0p3VWFHbElUQ0l1IiwiMTY0OTU4NTc0Ni42OTQ0MzEiXQ%3D%3D--a5f3ac45fa1067a9ef5ab0f43379078b5325adf0; _session_id=ebe4b9d4efb3279b8d052aa95285886d'
            'Cookie': cookies
          }

      ),
    ).then((response) {
      print("成功");
      print(response.data);
    }).catchError((err){
      print("失敗");
      print(err);
    });

  }
}





