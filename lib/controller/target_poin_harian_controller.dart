import 'dart:convert';

import 'package:destask/model/target_poin_harian_model.dart';
import 'package:destask/utils/constant_api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

const url = '$baseURL/api/targetpoinharian';

getToken() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");
  return token;
}

getIdUser() async {
  final prefs = await SharedPreferences.getInstance();
  var iduser = prefs.getString("id_user");
  return iduser;
}

getIdUserGroup() async {
  final prefs = await SharedPreferences.getInstance();
  var idusergroup = prefs.getString("id_usergroup");
  return idusergroup;
}

class TargetPoinHarianController {
  Future<List<TargetPoinHarianModel>> getTarget() async {
    try {
      var token = await getToken();
      var iduser = await getIdUser();
      var response = await http.get(
        Uri.parse('$url/$iduser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<TargetPoinHarianModel> targetpoin =
            List<TargetPoinHarianModel>.from(
                it.map((e) => TargetPoinHarianModel.fromJson(e)));
        return targetpoin;
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
        print(response.body);
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<bool> cekBobotPM() async {
    try {
      var token = await getToken();
      var response = await http.get(
        Uri.parse('$url/cek/pm'),
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
        Uri.parse('$url/cek/individu/$idusergroup'),
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
