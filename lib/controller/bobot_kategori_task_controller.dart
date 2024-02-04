import 'dart:convert';

import '../model/bobot_kategori_task_model.dart';
import '../utils/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const url = '$baseURL/api/bobotkategoritask';

getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString('token');
  return token;
}

class BobotKategoriTaskController {
  Future getAllBobotKategoriTask() async {
    try {
      var token = await getToken();
      var response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<BobotKategoriTaskModel> bobotKategori =
            List<BobotKategoriTaskModel>.from(
                it.map((e) => BobotKategoriTaskModel.fromJson(e)));
        return bobotKategori;
      } else {
        // Handle error
        print('Error getAllBobotKategoriTask: ${response.body}');
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  //get bobot kategori task by id
  Future getBobotKategoriTaskById(String idBobotKategoriTask) async {
    try {
      var token = await getToken();
      var response = await http.get(
        Uri.parse('$url/$idBobotKategoriTask'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<BobotKategoriTaskModel> bobotKategori =
            List<BobotKategoriTaskModel>.from(
                it.map((e) => BobotKategoriTaskModel.fromJson(e)));
        return bobotKategori;
      } else {
        return {}; // Mengembalikan map kosong jika tidak ada data
      }
    } catch (e) {
      return {}; // Mengembalikan map kosong jika terjadi exception
    }
  }
}
