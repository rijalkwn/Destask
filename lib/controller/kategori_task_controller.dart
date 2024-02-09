import 'dart:convert';

import '../model/kategori_task_model.dart';
import '../utils/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const url = '$baseURL/api/kategoritask';

getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString('token');
  return token;
}

class KategoriTaskController {
  //fungsi mendapatkan semua kategori task
  Future getAllKategoriTask() async {
    try {
      var token = await getToken();
      var response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<KategoriTaskModel> kategoriTask = List<KategoriTaskModel>.from(
            it.map((e) => KategoriTaskModel.fromJson(e)));
        return kategoriTask;
      } else {
        // Handle error
        return [];
      }
    } catch (e) {
      // Handle exception
      return [];
    }
  }

  //fungsi menampilkan semua kategori task
  Future<List<KategoriTaskModel>> showAll() async {
    List<KategoriTaskModel> data = await getAllKategoriTask();
    return data;
  }

  //fungsi mendapatkan kategori task berdasarkan id
  Future getKategoriTaskById(String idKategoriTask) async {
    try {
      var token = await getToken();
      var response = await http.get(
        Uri.parse('$url/$idKategoriTask'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<KategoriTaskModel> kategori = List<KategoriTaskModel>.from(
            it.map((e) => KategoriTaskModel.fromJson(e)));
        return kategori;
      } else {
        return {}; // Mengembalikan map kosong jika tidak ada data
      }
    } catch (e) {
      return {}; // Mengembalikan map kosong jika terjadi exception
    }
  }

  //fungsi menampilkan kategori task berdasarkan id
  Future<KategoriTaskModel> showById(String idKategoriTask) async {
    KategoriTaskModel data = await getKategoriTaskById(idKategoriTask);
    return data;
  }
}
