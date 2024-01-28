import 'package:destask/controller/auth_controller.dart';
import 'package:destask/utils/global_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.secondColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.04,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.04),
                            child: Image.asset(
                              'assets/img/logo.png',
                            ),
                          ),
                          Text(
                            'Login In Here',
                            style: TextStyle(
                              color: GlobalColors.textColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _identitasController,
                            decoration: InputDecoration(
                              labelText: 'Username or Email',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: Icon(Icons.person),
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
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obsecuretext,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: Icon(Icons.lock),
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
                          SizedBox(height: 5),
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
                            padding: EdgeInsets.symmetric(
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
                                                margin:
                                                    const EdgeInsets.all(30),
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
                                                    titleStyle: TextStyle(
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
                                    child: _iscaptcha
                                        ? Icon(
                                            Icons.check_box_outlined,
                                            color: Colors.green,
                                            size: 30,
                                          )
                                        : Icon(
                                            Icons.crop_square_sharp,
                                            color: Colors.grey,
                                          )),
                                SizedBox(width: 20),
                                Text(
                                  "Saya bukan robot",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
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
                                    _passwordController.text,
                                    _iscaptcha);
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
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  )
                                : Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
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
                            child: Text(
                              'Lupa Password?',
                              style: TextStyle(
                                  color: GlobalColors.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                          SizedBox(height: 20),
                          //versi aplikasi
                          Text(
                            'Versi 1.0.0',
                            style: TextStyle(
                              color: GlobalColors.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
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
      ),
    );
  }
}
