import 'dart:convert';

import '../model/personil_model.dart';
import '../utils/constant_api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const url = '$baseURL/api/personil';

Future getToken() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");
  return token;
}

class PersonilController {
  //fungsi mendapatkan semua personil
  Future getAllPersonil() async {
    try {
      var token = await getToken();
      var response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        Iterable it = jsonDecode(response.body);
        List<PersonilModel> personil =
            List<PersonilModel>.from(it.map((e) => e).toList());
        return personil;
      } else {
        // Handle error
        return [];
      }
    } catch (e) {
      // Handle exception
      return [];
    }
  }

  //fungsi menampilkan semua personil
  Future<List<PersonilModel>> showAll() async {
    List<PersonilModel> data = await getAllPersonil();
    return data;
  }

  //fungsi mendapatkan personil berdasarkan id
  Future getPersonilById(String idPersonil) async {
    var token = await getToken();
    var response = await http.get(Uri.parse('$url/$idPersonil'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body);
      List<PersonilModel> user = List<PersonilModel>.from(
          it.map((e) => PersonilModel.fromJson(e)).toList());
      return user;
    } else {
      // Handle error
      return [];
    }
  }

  //fungsi menampilkan personil berdasarkan id
  Future<List<PersonilModel>> showById(String idPersonil) async {
    List<PersonilModel> data = await getPersonilById(idPersonil);
    return data;
  }
}
