import 'dart:convert';

import '../model/status_task_model.dart';
import '../utils/constant_api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const url = '$baseURL/api/statustask';

Future getToken() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");
  return token;
}

class StatusTaskController {
  //fungsi mendapatkan semua status task
  Future getAllStatusTask() async {
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
  }

  //fungsi menampilkan semua status task
  Future<List<StatusTaskModel>> showAllTask() async {
    List<StatusTaskModel> data = await getAllStatusTask();
    return data;
  }
}
