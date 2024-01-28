import 'dart:convert';

import 'package:destask/utils/constant_api.dart';
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
  Future gantiPassword(String oldPassword, String newPassword) async {
    try {
      var token = await getToken();
      var iduser = await getIdUser();
      final response = await http.put(
        Uri.parse('$url/$iduser'),
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'id_user': iduser,
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      int status = jsonMap['status'];
      if (status == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }
}
