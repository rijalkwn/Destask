import 'dart:convert';

import 'package:destask/utils/constant_api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const url = '$baseURL/api/personil';

Future getToken() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");
  return token;
}

class PersonilController {
  Future<List<dynamic>> getAllPersonil() async {
    var token = await getToken();
    var response = await http
        .get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      List<dynamic> personil = List<dynamic>.from(list.map((e) => e));
      return personil;
    } else {
      // Handle error
      return [];
    }
  }

  //get personil by id
  Future<Map<String, dynamic>> getPersonilById(String idPersonil) async {
    var token = await getToken();
    var response = await http.get(Uri.parse('$url/$idPersonil'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      Map<String, dynamic> personil = json.decode(response.body);
      return personil;
    } else {
      // Handle error
      return {};
    }
  }

  //get personil by pekerjaan id
  Future<List<dynamic>> getPersonilByPekerjaanId(String idPekerjaan) async {
    var token = await getToken();
    var response = await http.get(Uri.parse('$url?idpekerjaan=$idPekerjaan'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      List<dynamic> personil = List<dynamic>.from(list.map((e) => e));
      return personil;
    } else {
      // Handle error
      return [];
    }
  }
}
