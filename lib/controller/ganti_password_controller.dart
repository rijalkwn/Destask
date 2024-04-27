import 'dart:convert';

import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

import '../utils/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const url = '$baseURL/api/gantipassword';

Future getToken() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");
  return token;
}

Future getIdUser() async {
  final prefs = await SharedPreferences.getInstance();
  var id_user = prefs.getString("id_user");
  return id_user;
}

class GantiPasswordController {
  //fungsi ganti password
  Future gantiPassword(String oldPassword, String newPassword) async {
    try {
      var token = await getToken();
      var iduser = await getIdUser();
      final data = json.encode({
        'id_user': iduser,
        'old_password': oldPassword,
        'new_password': newPassword,
      });
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: data,
      );
      print(response.body);
      if (response.statusCode == 200) {
        return true;
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
        return false;
      }
    } catch (e) {
      print(e);
    }
  }
}
