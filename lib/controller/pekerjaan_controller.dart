import '../model/pekerjaan_model.dart';
import '../utils/constant_api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// API link
const url = '$baseURL/api/pekerjaan';
const urluser = '$baseURL/api/pekerjaanbyuser';

Future getToken() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");
  return token;
}

class PekerjaanController {
  //fungsi mendapatkan semua pekerjaan
  Future getPekerjaanById(String idPekerjaan) async {
    try {
      var token = await getToken();
      var response = await http.get(
        Uri.parse('$url/$idPekerjaan'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        List<PekerjaanModel> pekerjaan = List<PekerjaanModel>.from(
            list.map((e) => PekerjaanModel.fromJson(e)).toList());
        return pekerjaan;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  //fungsi menampilkan pekerjaan berdasarkan id
  Future<List<PekerjaanModel>> showById(String idPekerjaan) async {
    List<PekerjaanModel> data = await getPekerjaanById(idPekerjaan);
    return data;
  }

  //fungsi mendapatkan pekerjaan yang dikerjakan oleh user
  Future getAllPekerjaanUser() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var iduser = pref.getString('id_user');
      var token = await getToken();
      var response = await http.get(
        Uri.parse('$urluser/$iduser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<PekerjaanModel> pekerjaan = List<PekerjaanModel>.from(
            it.map((e) => PekerjaanModel.fromJson(e)));
        return pekerjaan;
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

  //fungsi menampilkan pekerjaan yang dikerjakan oleh user
  Future<List<PekerjaanModel>> showAllByUser() async {
    List<PekerjaanModel> data = await getAllPekerjaanUser();
    return data;
  }

  //fungsi menampilkan pekerjaan dengan status 1 berdasarkan id user
  Future<List<PekerjaanModel>> showAllByUserOnProgress() async {
    List<PekerjaanModel> data = await getAllPekerjaanUser();
    //list pekerjaan yang statusnya 1
    List<PekerjaanModel> pekerjaanOnProgress = [];
    for (var i = 0; i < data.length; i++) {
      if (data[i].id_status_pekerjaan == '1') {
        pekerjaanOnProgress.add(data[i]);
      }
    }
    return pekerjaanOnProgress;
  }

  //fungsi update status pekerjaan
  Future updateStatusPekerjaan(String idPekerjaan, String idStatus) async {
    try {
      var token = await getToken();
      final data = {
        'id_status_pekerjaan': idStatus,
      };
      var response = await http.put(
        Uri.parse('$url/$idPekerjaan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: json.encode(data),
      );
      print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
