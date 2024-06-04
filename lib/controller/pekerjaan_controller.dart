import 'package:destask/controller/ganti_password_controller.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

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

Future getIdUser() async {
  final prefs = await SharedPreferences.getInstance();
  var idUser = prefs.getString("id_user");
  return idUser;
}

class PekerjaanController {
  //get pekerjaan by id
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
      } else if (response.statusCode == 401) {
        QuickAlert.show(
          context: Get.context!,
          title: 'Token Expired, Login Ulang',
          type: QuickAlertType.error,
        );
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.clear();
        Get.offAllNamed('/login');
      } else {
        return {}; // Mengembalikan map kosong jika tidak ada data
      }
    } catch (e) {
      return {}; // Mengembalikan map kosong jika terjadi exception
    }
  }

  //menampilkan list pekerjaan progres di beranda
  Future getOnProgressUser() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var iduser = pref.getString('id_user');
      var token = await getToken();
      var response = await http.get(
        Uri.parse('$urluser/$iduser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        // print(response.body);
        Iterable list = json.decode(response.body);
        List<PekerjaanModel> pekerjaan = List<PekerjaanModel>.from(list
            .where((element) => element['id_status_pekerjaan'] == "2")
            .map((e) => PekerjaanModel.fromJson(e)));
        return pekerjaan;
      } else if (response.statusCode == 401) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.clear();
        Get.offAllNamed('/login');
        QuickAlert.show(
          context: Get.context!,
          title: 'Token Expired, Login Ulang',
          type: QuickAlertType.error,
        );
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

//menampilakn list pekerjaan di menu pekerjaan
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
        // print(response.body);
        Iterable it = json.decode(response.body);
        List<PekerjaanModel> pekerjaan = List<PekerjaanModel>.from(
            it.map((e) => PekerjaanModel.fromJson(e)));
        return pekerjaan;
      } else if (response.statusCode == 401) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.clear();
        Get.offAllNamed('/login');
        QuickAlert.show(
          context: Get.context!,
          title: 'Token Expired, Login Ulang',
          type: QuickAlertType.error,
        );
      } else {
        // Handle error
        return [];
      }
    } catch (e) {
      print('Error decoding JSON: $e');
      return [];
    }
  }

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
      // print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.clear();
        Get.offAllNamed('/login');
        QuickAlert.show(
          context: Get.context!,
          title: 'Token Expired, Login Ulang',
          type: QuickAlertType.error,
        );
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future getPekerjaanVerifikasi() async {
    try {
      var token = await getToken();
      var idUser = await getIdUser();
      var response = await http.get(
        Uri.parse('$url/verifikasi/$idUser'),
        headers: {'Authorization ': 'Bearer $token'},
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        List<PekerjaanModel> pekerjaan = List<PekerjaanModel>.from(
            list.map((e) => PekerjaanModel.fromJson(e)).toList());
        return pekerjaan;
      } else if (response.statusCode == 401) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.clear();
        Get.offAllNamed('/login');
        QuickAlert.show(
          context: Get.context!,
          title: 'Token Expired, Login Ulang',
          type: QuickAlertType.error,
        );
      } else {
        return {}; // Mengembalikan map kosong jika tidak ada data
      }
    } catch (e) {
      return {}; // Mengembalikan map kosong jika terjadi exception
    }
  }
}
