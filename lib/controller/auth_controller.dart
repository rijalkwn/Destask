import 'dart:convert';
import 'package:destask/utils/constant_api.dart';
import 'package:destask/view/Menu/bottom_nav.dart';
import 'package:destask/view/Auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  Future login(
    TextEditingController identitasController,
    TextEditingController passwordController,
  ) async {
    const String url = "$baseURL/authAPI";
    final prefs = await SharedPreferences.getInstance();
    var params =
        "?identitas=${identitasController.text}&password=${passwordController.text}";

    try {
      var res = await http.post(Uri.parse(url + params));
      print(res.body);
      if (res.statusCode == 200) {
        var response = json.decode(res.body);
        prefs.setString("id_user", response['data']['id_user']);
        prefs.setString("username", response['data']['username']);
        prefs.setString("nama", response['data']['nama']);
        prefs.setString("email", response['data']['email']);
        prefs.setString("token", response['token']);
        Get.offAll(() => BottomNav());
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
