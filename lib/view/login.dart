import 'dart:convert';

import 'package:destask/utils/constant_api.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:destask/view/Menu/bottom_nav.dart';
import 'package:destask/view/lupa_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool visible = false;
  bool isLoading = false;
  bool _obsecuretext = true;
  final String sUrl = "$baseURL/api/UserAuthentication";

  //fungsi cek login
  _cekLogin() async {
    setState(() {
      visible = true;
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();

    var params =
        "?username=${usernameController.text}&password=${passwordController.text}";
    try {
      var res = await http.post(Uri.parse(sUrl + params));
      if (res.statusCode == 200) {
        var response = json.decode(res.body);
        prefs.setString("id_user", response['data']['id_user']);
        prefs.setString("username", response['data']['username']);
        prefs.setString("level", response['data']['level']);
        //token
        prefs.setString("token", response['token']);
        // Saat login, simpan waktu kedaluwarsa dalam preferensi
        String expString = response['payload']['expired']; // Misalnya: "10"
        int expint = int.parse(expString);
        DateTime expTime = DateTime.now().add(Duration(seconds: expint));
        DateTime currentTime = DateTime.now();
        Duration tokenDuration = expTime.difference(currentTime);
        int expired = tokenDuration.inSeconds;
        prefs.setInt("expired", expired);

        setState(() {
          visible = false;
        });
        //tampilkan snackbar
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
        setState(() {
          visible = false;
        });
        //tamplikan snackbar
        Get.snackbar(
          "Error",
          "Failed to login!! Please try again",
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        );
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        visible = false;
      });
      //tampilkan snackbar
      Get.snackbar(
        "Error",
        "Exception occurred",
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.backColor,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(45.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Image.asset('assets/img/logo.png'),
              ),
              const SizedBox(
                height: 100,
              ),
              Text(
                'Login',
                style: TextStyle(
                  color: GlobalColors.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                        hintText: 'Masukan Username',
                        filled: true,
                        fillColor: GlobalColors.backColor,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Username tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: _obsecuretext,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obsecuretext = !_obsecuretext;
                                });
                              },
                              child: _obsecuretext
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility)),
                          hintText: "Masukan Password"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  _cekLogin();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  // margin: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue, // Ganti warna sesuai kebutuhan
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //lupa password
              GestureDetector(
                onTap: () {
                  Get.to(() => const LupaPassword());
                },
                child: const Text(
                  'Lupa Password?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
