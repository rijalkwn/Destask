import 'dart:convert';

import 'package:destask/model/target_poin_harian_model.dart';
import 'package:destask/utils/constant_api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const url = '$baseURL/targetpoinharian';

getToken() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");
  return token;
}

getData() async {
  final prefs = await SharedPreferences.getInstance();
  var idUserGroup = prefs.getString("id_usergroup");
  return idUserGroup;
}

class TargetPoinHarianController {
  Future getTargetPoinHarian() async {
    try {
      var token = await getToken();
      var idUserGroup = await getData();
      DateTime now = DateTime.now();
      String tahun = now.year.toString();
      String bulan = now.month.toString();
      print(tahun);
      print(bulan);
      print(idUserGroup);
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization ': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        print(response.body);
        Iterable it = json.decode(response.body);
        List<TargetPoinHarianModel> targetPoinHarian =
            List<TargetPoinHarianModel>.from(it
                // .where((e) =>
                //     e['id_usergroup'] == idUserGroup &&
                //     e['tahun'] == tahun &&
                //     e['bulan'] == bulan)
                .map((e) => TargetPoinHarianModel.fromJson(e)));
        return targetPoinHarian;
      } else {
        print("ini respon" + response.body);
        return [];
      }
    } catch (e) {
      return <TargetPoinHarianModel>[];
    }
  }

  Future<List<TargetPoinHarianModel>> showAll() async {
    List<TargetPoinHarianModel> data = await getTargetPoinHarian();
    return data;
  }
}
