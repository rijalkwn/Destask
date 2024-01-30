import 'dart:convert';

import 'package:destask/model/status_task_model.dart';
import 'package:destask/utils/constant_api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const url = '$baseURL/api/statustask';

Future getToken() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");
  return token;
}

class StatusTaskController {
  Future getAllStatusTask() async {
    try {
      var token = await getToken();
      var response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<StatusTaskModel> statusTask = List<StatusTaskModel>.from(
            it.map((e) => StatusTaskModel.fromJson(e)));
        return statusTask;
      } else {
        // Handle error
        return [];
      }
    } catch (e) {
      // Handle exception
      return [];
    }
  }

  Future getStatusById(String idStatusPekerjaan) async {
    var token = await getToken();
    var response = await http.get(Uri.parse('$url/$idStatusPekerjaan'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      Iterable it = json.decode(response.body);
      List<StatusTaskModel> statustask = List<StatusTaskModel>.from(
          it.map((e) => StatusTaskModel.fromJson(e)).toList());
      return statustask;
    } else {
      // Handle error
      return [];
    }
  }
}
