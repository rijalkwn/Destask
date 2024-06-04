import 'dart:convert';

import 'package:destask/model/target_poin_harian_model.dart';
import 'package:destask/utils/constant_api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

const url = '$baseURL/api/targetpoinharianbyuser';
const urlcek = '$baseURL/api/cektargetpoinharian';

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
        print(response.body);
        var data = json.decode(response.body);
        return data;
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

  Future<bool> cekTarget() async {
    try {
      var token = await getToken();
      var response = await http.get(
        Uri.parse('$urlcek'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        List<dynamic> data = responseBody['data'];
        int jumlahData = responseBody['jumlah_data'];
        int jumlahUserGroup = responseBody['jumlah_usergroup'];

        if (jumlahData == jumlahUserGroup) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
