import 'dart:convert';

import 'package:destask/model/user_model.dart';
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

class UserController {
  Future getAllUser() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var iduser = pref.getString('id_user');
      var token = await getToken();
      var response = await http.get(
        Uri.parse('$url/$iduser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<UserModel> user =
            List<UserModel>.from(it.map((e) => UserModel.fromJson(e)));
        return user;
      } else {
        // Handle error
        return [];
      }
    } catch (e) {
      // Handle exception
      return [];
    }
  }

  Future getUserById(String idUser) async {
    try {
      var token = await getToken();
      var response = await http.get(
        Uri.parse('$url/$idUser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<UserModel> user =
            List<UserModel>.from(it.map((e) => UserModel.fromJson(e)).toList());
        return user;
      } else {
        // Handle error
        return {};
      }
    } catch (e) {
      print(e);
    }
  }

  Future editProfile(
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
