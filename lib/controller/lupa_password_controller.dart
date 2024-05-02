import 'dart:convert';

import '../utils/constant_api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const url = '$baseURL/lupapassword';

Future getTokenVerifikasi() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("tokenverifikasi");
  return token;
}

Future getIdUser() async {
  final prefs = await SharedPreferences.getInstance();
  var idUser = prefs.getString("id_user");
  return idUser;
}

class LupaPasswordController {
  Future lupaPassword(String email) async {
    try {
      print(url);
      final data = {"email": email};
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      print(data);
      print(url);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("emailverifikiasi", email);
        return true;
      } else {
        print(response.statusCode);
        print(email);
        print(url);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  getEmailVerifikasi() async {
    final prefs = await SharedPreferences.getInstance();
    var email = prefs.getString("emailverifikiasi");
    return email;
  }

  Future verifikasiToken(String token) async {
    try {
      var email = await getEmailVerifikasi();
      var res = await http.post(
        Uri.parse('$url/verifikasitoken'),
        body: {
          "email": email,
          "token": token,
        },
      );

      if (res.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("tokenverifikasi", token);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  //reset password
  Future resetPassword(String password) async {
    try {
      var tokenverifikasi = await getTokenVerifikasi();
      var urlini = '$url/resetpassword';
      print(urlini);
      var res = await http.post(
        Uri.parse(urlini),
        body: {
          "token": tokenverifikasi,
          "password": password,
        },
      );

      if (res.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        prefs.remove("tokenverifikasi");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
