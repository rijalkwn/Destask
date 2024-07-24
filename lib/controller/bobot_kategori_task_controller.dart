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

getIdUserGroup() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var idUserGroup = pref.getString('id_usergroup');
  return idUserGroup;
}

class BobotKategoriTaskController {
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
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<bool> cekBobotPM() async {
    try {
      var token = await getToken();
      var response = await http.get(
        Uri.parse('$url/cekbobot/pm'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 200 && !data['error']) {
          print('cekBobotPMBobot: ${data['messages']}');
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> cekBobotIndividu() async {
    try {
      var token = await getToken();
      var idusergroup = await getIdUserGroup();
      var response = await http.get(
        Uri.parse('$url/cekbobot/individu/$idusergroup'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 200 && !data['error']) {
          print('cekBobotPMBobot: ${data['messages']}');
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
