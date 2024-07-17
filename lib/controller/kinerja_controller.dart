import 'dart:convert';

import 'package:destask/model/kinerja_model.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

import '../utils/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const url = '$baseURL/api/kinerja';
const urluser = '$baseURL/api/kinerjauser';

getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString('token');
  return token;
}

getIdUser() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var idUser = pref.getString('id_user');
  return idUser;
}

class KinerjaController {
  Future getKinerjaUser() async {
    try {
      var token = await getToken();
      var idUser = await getIdUser();
      var response = await http.get(
        Uri.parse('$urluser/$idUser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        Iterable it = jsonDecode(response.body);
        print(response.body);
        List<KinerjaModel> kinerja = List<KinerjaModel>.from(
            it.map((e) => KinerjaModel.fromJson(e)).toList());
        return kinerja;
      } else if (response.statusCode == 401) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.clear();
        Get.offAllNamed('/login');
        QuickAlert.show(
          context: Get.context!,
          title: 'Token Expired, Login Ulang',
          type: QuickAlertType.error,
        );
        return [];
      } else {
        // Handle error
        print('Error getKinerja: ${response.body}');
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  //fungsi menampilkan semua kategori task
  Future<List<KinerjaModel>> showKinerjaUser() async {
    List<KinerjaModel> data = await getKinerjaUser();
    return data;
  }

  Future getKinerjaById(String idkinerja) async {
    try {
      var token = await getToken();
      var response = await http.get(
        Uri.parse('$url/$idkinerja'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        Iterable it = jsonDecode(response.body);
        List<KinerjaModel> kinerja = List<KinerjaModel>.from(
            it.map((e) => KinerjaModel.fromJson(e)).toList());
        return kinerja;
      } else if (response.statusCode == 401) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.clear();
        Get.offAllNamed('/login');
        QuickAlert.show(
          context: Get.context!,
          title: 'Token Expired, Login Ulang',
          type: QuickAlertType.error,
        );
        return [];
      } else {
        // Handle error
        print('Error getKinerjaById: ${response.body}');
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<KinerjaModel>> showKinerjaById(idkinerja) async {
    List<KinerjaModel> data = await getKinerjaById(idkinerja);
    return data;
  }
}
