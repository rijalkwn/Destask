import 'dart:convert';

import 'package:destask/model/hari_libur_model.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

import '../utils/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const url = '$baseURL/api/harilibur';

getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString('token');
  return token;
}

class HariLiburController {
  //fungsi mendapatkan semua hari libur
  Future getAllHariLibur() async {
    try {
      var token = await getToken();
      var response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<HariLiburModel> hariLibur = List<HariLiburModel>.from(
            it.map((e) => HariLiburModel.fromJson(e)));
        return hariLibur;
      } else if (response.statusCode == 401) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.clear();
        Get.offAllNamed('/login');
        QuickAlert.show(
          context: Get.context!,
          title: 'Token Expired, Login Ulang',
          type: QuickAlertType.error,
        );
      } else {
        // Handle error
        print('Error getAllHariLibur: ${response.body}');
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
