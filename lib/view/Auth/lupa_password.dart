import '../../controller/auth_controller.dart';
import '../../utils/global_colors.dart';
import 'package:destask/view/Auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class LupaPassword extends StatefulWidget {
  const LupaPassword({super.key});

  @override
  State<LupaPassword> createState() => _LupaPasswordState();
}

class _LupaPasswordState extends State<LupaPassword> {
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final authController = Get.put(AuthController());
  bool isLoading = false;
  List user = [];

  //Mengirim email ke untuk mendapatkan link ganti password
  sendMail(String recipientEmail) async {
    String email = 'newstar23135@gmail.com';
    String password = 'hmwjllvbbdnepdpd';
    //recipent addressnya masih dump karena belum ada data user aktual!!!!
    final smtpServer = gmail(email, password);
    final equivalentMessage = Message()
      ..from = Address(email, 'DESTASK Reset Password')
      ..recipients.add(Address(recipientEmail))
      ..subject = 'Reset Password'
      ..html =
          "<p>Klik link ini untuk reset password anda : <a href=\"http://localhost:8080/lupa_password/reset_password/c4ca4238a0b923820dcc509a6f75849b\">Reset Password</a></p><p><b>Noted:</b> Jika anda tidak merasa melakukan reset password, abaikan email ini!.</p> ";
    setState(() {
      isLoading = true;
    });
    await send(equivalentMessage, smtpServer,
        timeout: const Duration(seconds: 10));
    setState(() {
      isLoading = false;
    });
    if (isLoading == false) {
      AlertDialog alert = AlertDialog(
        title: const Text("Email Berhasil Dikirim"),
        content: const Text("Silahkan cek inbox email anda"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const Login()));
              },
              child: const Text("Kembali ke halaman login"))
        ],
      );
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    } else {
      AlertDialog alert = AlertDialog(
        title: const Text("Email gagal dikirim "),
        content: const Text("Silahkan cek koneksi internet anda"),
        actions: [TextButton(onPressed: () {}, child: const Text("OK"))],
      );
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    }
  }

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
                            "Lupa Password",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
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
                                return "Masukan Email!";
                              } else {
                                return null;
                              }
                            },
                          ),

                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () async {
                              if (formkey.currentState!.validate()) {
                                bool isExist = await authController
                                    .checkEmailExist(emailController.text);
                                if (isExist) {
                                  sendMail(emailController.text);
                                } else {
                                  AlertDialog alert = AlertDialog(
                                    title: const Text("Email tidak terdaftar"),
                                    content: const Text(
                                        "Silahkan cek kembali email anda"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("OK"))
                                    ],
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
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
