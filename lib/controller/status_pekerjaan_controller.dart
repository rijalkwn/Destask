import 'dart:convert';

import '../model/status_pekerjaan_model.dart';
import '../utils/constant_api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const url = '$baseURL/api/statuspekerjaan';

Future getToken() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");
  return token;
}

class StatusPekerjaanController {
  //fungsi mendapatkan semua status pekerjaan
  Future getAllStatusPekerjaan() async {
    var token = await getToken();
    var response = await http
        .get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      Iterable it = json.decode(response.body);
      List<StatusPekerjaanModel> user = List<StatusPekerjaanModel>.from(
          it.map((e) => StatusPekerjaanModel.fromJson(e)).toList());
      return user;
    } else {
      // Handle error
      return [];
    }
  }
}
