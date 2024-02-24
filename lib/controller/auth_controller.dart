import 'dart:convert';
import '../model/user_model.dart';
import '../utils/constant_api.dart';
import '../view/Auth/login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String url = "$baseURL/authlogin";

class AuthController {
  //Fungsi Login
  Future login(String identitasController, String passwordController) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var res = await http.post(Uri.parse(url), body: {
        "identitas": identitasController,
        "password": passwordController
      });
      if (res.statusCode == 200) {
        var response = json.decode(res.body);
        prefs.setString("id_user", response['data']['id_user']);
        prefs.setString("username", response['data']['username']);
        prefs.setString("nama", response['data']['nama']);
        prefs.setString("email", response['data']['email']);
        prefs.setString("id_usergroup", response['data']['id_usergroup']);
        prefs.setString("user_level", response['data']['user_level']);
        prefs.setString("token", response['token']);
        return true;
      } else {
        print(res.statusCode);
        print(res.body);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  //Fungsi Logout
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

  //fungsi cek email pada lupa password
  Future checkEmailExist(String email) async {
    try {
      final String url = "$baseURL/authcekuser";
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
