import 'package:quickalert/quickalert.dart';

import '../../controller/ganti_password_controller.dart';
import '../../utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GantiPassword extends StatefulWidget {
  const GantiPassword({Key? key}) : super(key: key);

  @override
  State<GantiPassword> createState() => _GantiPasswordState();
}

class _GantiPasswordState extends State<GantiPassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final gantiPasswordController = Get.put(GantiPasswordController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Ganti Password", style: TextStyle(color: Colors.white)),
        backgroundColor: GlobalColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //password lama
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password Lama',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kolom password lama harus diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                //password baru
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password Baru',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.vpn_key_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kolom password baru harus diisi';
                    }
                    //minimal 6 karakter
                    else if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                //konfirmasi password baru
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password Baru',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.key_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kolom password lama harus diisi';
                    }
                    //cek password lama benar atau tidak
                    else if (value != _newPasswordController.text) {
                      return 'Password baru tidak sama dengan konfirmasi password baru';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GestureDetector(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            bool cekPassword = await gantiPasswordController
                                .cekPassword(_oldPasswordController.text);
                            print(cekPassword);
                            if (cekPassword) {
                              bool gantiPassword =
                                  await gantiPasswordController.gantiPassword(
                                      _oldPasswordController.text,
                                      _newPasswordController.text);
                              if (gantiPassword) {
                                QuickAlert.show(
                                    context: context,
                                    title: "Password Berhasil Diganti",
                                    type: QuickAlertType.success);
                                _oldPasswordController.clear();
                                _newPasswordController.clear();
                                _confirmPasswordController.clear();
                                setState(() {
                                  isLoading = false;
                                });
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                QuickAlert.show(
                                    context: context,
                                    title: "Gagal Ganti Password",
                                    type: QuickAlertType.error);
                              }
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              QuickAlert.show(
                                  context: context,
                                  title: "Password Lama Salah",
                                  type: QuickAlertType.error);
                            }
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: GlobalColors.mainColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'Ganti Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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
