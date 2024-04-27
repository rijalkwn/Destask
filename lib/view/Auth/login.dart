import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/auth_controller.dart';
import '../../utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:slider_captcha/slider_captcha.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _identitasController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SliderController _recaptchaController = SliderController();
  bool isLoading = false;
  bool _obsecuretext = true;
  bool _iscaptcha = false;

  //fungsi captcha
  _onCaptcha() {
    setState(() {
      _iscaptcha = true;
    });
  }

  // cek login with token
  startLaunching() async {
    final prefs = await SharedPreferences.getInstance();
    //cek expired token
    var token = prefs.getString("token");
    if (token != null) {
      var jwt = token.split(".");
      var payload = json.decode(ascii
          .decode(base64.decode(base64.normalize(jwt[1])))); //decode payload
      var exp = payload['exp'];
      var now = DateTime.now().millisecondsSinceEpoch / 1000;
      if (exp > now) {
        Get.offAllNamed('/bottom_nav');
      } else {
        prefs.clear();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    startLaunching();
  }

  @override
  void dispose() {
    super.dispose();
    _identitasController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.05,
                              bottom: MediaQuery.of(context).size.height * 0.04,
                              left: MediaQuery.of(context).size.width * 0.1,
                              right: MediaQuery.of(context).size.width * 0.1),
                          child: Image.asset(
                            'assets/img/logo.png',
                          ),
                        ),

                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _identitasController,
                          decoration: InputDecoration(
                            labelText: 'Username atau Email',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.person),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username or Email harus diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obsecuretext,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obsecuretext = !_obsecuretext;
                                });
                              },
                              child: _obsecuretext
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password harus diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 5),
                        // Add the reCAPTCHA widget
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                            child: Container(
                                              margin: const EdgeInsets.all(30),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: SliderCaptcha(
                                                  title:
                                                      "Geser untuk verifikasi",
                                                  titleStyle: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  controller:
                                                      _recaptchaController,
                                                  image: Image.asset(
                                                    'assets/img/captcha.jpg',
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                  onConfirm: (value) async {
                                                    if (value == true) {
                                                      _onCaptcha();
                                                      Navigator.pop(context);
                                                    } else {
                                                      _iscaptcha = false;
                                                      Navigator.pop(context);
                                                      QuickAlert.show(
                                                          context: context,
                                                          title:
                                                              "Captcha Salah, Coba Lagi",
                                                          type: QuickAlertType
                                                              .error);
                                                    }
                                                  },
                                                  colorBar: Colors.white,
                                                  colorCaptChar: Colors.blue,
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Row(
                                    children: [
                                      _iscaptcha
                                          ? const Icon(
                                              Icons.check_box_outlined,
                                              color: Colors.green,
                                              size: 30,
                                            )
                                          : const Icon(
                                              Icons.crop_square_sharp,
                                              color: Colors.grey,
                                            ),
                                      const SizedBox(width: 20),
                                      const Text(
                                        "I'm not a robot",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        //tombo login
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              if (_iscaptcha == false) {
                                QuickAlert.show(
                                    context: context,
                                    title: "Captcha Salah, Coba Lagi",
                                    type: QuickAlertType.error);
                              }
                              AuthController authController =
                                  Get.put(AuthController());
                              bool login = await authController.login(
                                  _identitasController.text,
                                  _passwordController.text);
                              if (login == true && _iscaptcha == true) {
                                Get.offAllNamed('/bottom_nav');
                                QuickAlert.show(
                                    context: context,
                                    title: "Login Berhasil",
                                    type: QuickAlertType.success);
                              } else {
                                if (_iscaptcha == true && login == false) {
                                  QuickAlert.show(
                                      context: context,
                                      title: "Login Gagal",
                                      type: QuickAlertType.error);
                                }
                              }
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                            }
                            setState(() {
                              isLoading = false;
                            });
                          },
                          child: isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                )
                              : Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .blue, // Ganti warna sesuai kebutuhan
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                        //lupa password
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/lupa_password');
                          },
                          child: const Text(
                            'Lupa Password?',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        const SizedBox(height: 20),
                        //versi aplikasi
                        const Center(
                          child: Text(
                            'Versi 1.0.0',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
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
