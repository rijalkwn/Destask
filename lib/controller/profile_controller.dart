import 'dart:convert';

import 'package:destask/utils/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

const url = '$baseURL/api/user';

Future getToken() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");
  return token;
}

class ProfileController {
  Future<Map<String, dynamic>> getProfileById(String idUser) async {
    try {
      var token = await getToken();
      var response = await http.get(
        Uri.parse('$url/$idUser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> profileList =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        Map<String, dynamic> profile = profileList.first;
        return profile;
      } else {
        throw Exception(
            'Failed to load profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting profile: $e');
    }
  }

  Future editProfil(
    String iduser,
    String nama,
    String email,
    String username,
  ) async {
    try {
      var token = await getToken();
      var response = await http.put(
        Uri.parse('$url/$iduser'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'nama': nama,
          'email': email,
          'username': username,
        },
      );
      if (response.statusCode == 200) {
        Get.offAllNamed('/bottomnav');
        return true;
      } else {
        print('Failed to edit profile. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      throw Exception('Error editing profile: $e');
    }
  }
}
