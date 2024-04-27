import 'dart:convert';

import 'package:destask/utils/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const url = "$baseURL/api/rekappoint";

getToken() async {
  var prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");
  return token;
}

getIdUser() async {
  var prefs = await SharedPreferences.getInstance();
  var iduser = prefs.getString("id_user");
  return iduser;
}

class RekapPointController {
  Future<List> getRekapPoint() async {
    var token = await getToken();
    var iduser = await getIdUser();
    var url = Uri.parse("$baseURL/api/rekappoint/$iduser");
    var response = await http.get(url, headers: {
      "Authorization": "Bearer $token",
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      return [];
    }
  }
}
