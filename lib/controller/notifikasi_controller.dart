import 'dart:convert';

import '../model/notifikasi_model.dart';
import '../utils/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const url = '$baseURL/api/notifikasi';

getToken() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");
  return token;
}

getUser() async {
  final prefs = await SharedPreferences.getInstance();
  var iduser = prefs.getString("id_user");
  return iduser;
}

class NotifikasiController {
  Future getNotifikasi() async {
    try {
      var token = await getToken();
      var iduser = await getUser();
      var response = await http.get(
        Uri.parse(url + 'touser/' + iduser),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<NotifikasiModel> notifikasi = List<NotifikasiModel>.from(
            it.map((e) => NotifikasiModel.fromJson(e)));
        return notifikasi;
      } else {
        // Handle error
        return [];
      }
    } catch (e) {
      print(e);
      // Returning an empty list in case of an exception
      return [];
    }
  }

  //update notifikasi
  Future updateNotifikasi(String idNotifikasi) async {
    try {
      var token = await getToken();
      var response = await http.put(
        Uri.parse('$url/$idNotifikasi'),
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'id_notifikasi': idNotifikasi,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // print(e);
      return false;
    }
  }
}
