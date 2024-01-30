import 'dart:convert';
import 'package:destask/model/user_model.dart';
import 'package:destask/utils/constant_api.dart';
import 'package:destask/view/Auth/login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String url = "$baseURL/authAPI";

class AuthController {
  Future login(String identitasController, String passwordController,
      bool isCaptcha) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var params =
          "?identitas=$identitasController&password=$passwordController";
      var res = await http.post(Uri.parse(url + params));
      if (res.statusCode == 200) {
        var response = json.decode(res.body);
        prefs.setString("id_user", response['data']['id_user']);
        prefs.setString("username", response['data']['username']);
        prefs.setString("nama", response['data']['nama']);
        prefs.setString("email", response['data']['email']);
        prefs.setString("token", response['token']);
        return true;
      } else {
        print(res.statusCode);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Get.offAll(() => const Login());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future checkEmailExist(String email) async {
    try {
      final String url = "$baseURL/user";
      var res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        Iterable it = json.decode(res.body);
        List<UserModel> users = List<UserModel>.from(it.map((e) => e));
        bool emailExists = false;
        for (var i = 0; i < users.length; i++) {
          if (users[i].email == email) {
            emailExists = true;
            break;
          }
        }
        return emailExists;
      } else {
        print(res.statusCode);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
