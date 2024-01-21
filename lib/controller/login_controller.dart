import 'dart:convert';
import 'package:destask/utils/constant_api.dart';
import 'package:destask/view/Menu/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
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

        Get.snackbar(
          "Success",
          "Login Success",
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        );

        if (response['data']['level'] == "admin") {
          Get.offAll(() => const BottomNav());
        } else if (response['data']['level'] == "user") {
          Get.offAll(() => const BottomNav());
        }
      } else {
        Get.snackbar(
          "Error",
          "Failed to login!! Please try again",
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      // tampilkan snackbar
      Get.snackbar(
        "Error",
        "Exception occurred",
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
