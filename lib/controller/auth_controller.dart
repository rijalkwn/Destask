import 'dart:convert';
import 'package:destask/utils/constant_api.dart';
import 'package:destask/view/Menu/bottom_nav.dart';
import 'package:destask/view/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  Future login(
    TextEditingController _usernameController,
    TextEditingController _passwordController,
  ) async {
    final String url = "$baseURL/api/UserAuthentication";
    final prefs = await SharedPreferences.getInstance();
    var params =
        "?username=${_usernameController.text}&password=${_passwordController.text}";

    try {
      var res = await http.post(Uri.parse(url + params));
      print(res.body);
      if (res.statusCode == 200) {
        var response = json.decode(res.body);
        prefs.setString("id_user", response['data']['id_user']);
        prefs.setString("username", response['data']['username']);
        prefs.setString("level", response['data']['level']);
        prefs.setString("token", response['token']);

        if (response['data']['level'] == "supervisor") {
          Get.offAll(() => const BottomNav());
        } else if (response['data']['level'] == "staff") {
          Get.offAll(() => const BottomNav());
        }
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
}
