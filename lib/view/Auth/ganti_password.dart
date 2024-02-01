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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ganti Password", style: TextStyle(color: Colors.white)),
        backgroundColor: GlobalColors.mainColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20, left: 10, right: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    return null;
                  },
                ),
                SizedBox(height: 16),
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
                      return 'Kolom konfirmasi password baru harus diisi';
                    } else if (value != _newPasswordController.text) {
                      return 'Konfirmasi password baru tidak sama dengan password baru';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      GantiPasswordController gantiPasswordController =
                          Get.put(GantiPasswordController());
                      bool success =
                          await gantiPasswordController.gantiPassword(
                              _oldPasswordController.text,
                              _newPasswordController.text);
                      if (success) {
                        Get.back();
                        Get.snackbar(
                          'Berhasil',
                          'Password berhasil diganti',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        Get.snackbar(
                          'Gagal',
                          'Password gagal diganti',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: GlobalColors.mainColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
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

  TextFormField buildFormField(
      TextEditingController controller, String label, Icon icon) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: icon,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Kolom $label harus diisi';
        }
        return null;
      },
    );
  }
}
