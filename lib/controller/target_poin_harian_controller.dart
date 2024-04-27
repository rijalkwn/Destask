import 'dart:convert';

import 'package:destask/model/target_poin_harian_model.dart';
import 'package:destask/utils/constant_api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

const url = '$baseURL/targetpoinharianbyuser';

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
  Future getTargetPoinHarianbyUser() async {
    try {
      var token = await getToken();
      var iduser = await getIdUser();
      var response = await http.get(
        Uri.parse('$url/$iduser'),
        headers: {'Authorization ': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        print(response.body);
        Iterable it = json.decode(response.body);
        List<TargetPoinHarianModel> targetPoinHarian =
            List<TargetPoinHarianModel>.from(
                it.map((e) => TargetPoinHarianModel.fromJson(e)));
        return targetPoinHarian;
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
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
