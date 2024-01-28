import 'dart:convert';
import 'package:destask/utils/constant_api.dart';
import 'package:destask/view/Menu/bottom_nav.dart';
import 'package:destask/view/Auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String url = "$baseURL/authAPI";

class AuthController {
  Future login(String identitasController, String passwordController,
      bool isCaptcha) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      var res = await http.post(Uri.parse(url), body: {
        'identitas': identitasController,
        'password': passwordController,
      });
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
        Iterable list = json.decode(res.body);
        List<dynamic> users = List<dynamic>.from(list.map((e) => e));
        bool emailExists = users.any((user) => user['email'] == email);
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
