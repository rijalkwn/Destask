import 'package:destask/controller/lupa_password_controller.dart';
import 'package:quickalert/quickalert.dart';

import '../../controller/auth_controller.dart';
import '../../utils/global_colors.dart';
import 'package:destask/view/Auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class VerifikasiToken extends StatefulWidget {
  const VerifikasiToken({super.key});

  @override
  State<VerifikasiToken> createState() => _VerifikasiTokenState();
}

class _VerifikasiTokenState extends State<VerifikasiToken> {
  final formkey = GlobalKey<FormState>();
  final tokenController = TextEditingController();
  final AuthController authController = AuthController();
  final LupaPasswordController lupaPasswordController =
      LupaPasswordController();
  bool isLoading = false;
  List user = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.backgroundColor,
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
                      key: formkey,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.08,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.1),
                            child: Image.asset(
                              'assets/img/logo.png',
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Verifikasi Token",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: tokenController,
                            decoration: InputDecoration(
                              labelText: 'Token',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.email),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Masukan Token!";
                              } else {
                                return null;
                              }
                            },
                          ),

                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              if (formkey.currentState!.validate()) {
                                bool success = await lupaPasswordController
                                    .verifikasiToken(tokenController.text);
                                if (success) {
                                  Get.toNamed('/reset_password');
                                  QuickAlert.show(
                                    context: context,
                                    title: "Token Valid",
                                    type: QuickAlertType.success,
                                  );
                                  setState(() {
                                    isLoading = false;
                                  });
                                } else {
                                  QuickAlert.show(
                                    context: context,
                                    title: "Token Tidak Valid",
                                    type: QuickAlertType.error,
                                  );
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  )
                                : Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Kirim',
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
                              Get.toNamed('/login');
                            },
                            child: const Text(
                              'Kembali ke Menu Login',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
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
      ),
    );
  }
}
