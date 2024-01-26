import 'package:destask/utils/global_colors.dart';
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
  final _FormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  //Mengirim email ke untuk mendapatkan link ganti password
  Future<void> sendMail(String recipientEmail) async {
    String email = 'newstar23135@gmail.com';
    String password = 'hmwjllvbbdnepdpd';
    //recipent addressnya masih dump karena belum ada data user aktual!!!!
    final smtpServer = gmail(email, password);
    final equivalentMessage = Message()
      ..from = Address(email, 'DESARMADA Reset Password')
      ..recipients.add(Address(recipientEmail))
      ..subject = 'Reset Password'
      ..html =
          "<p>Klik link ini untuk reset password anda : <a href=\"http://localhost:8080/lupa_password/reset_password/c4ca4238a0b923820dcc509a6f75849b\">Reset Password</a></p><p><b>Noted:</b> Jika anda tidak merasa melakukan reset password, abaikan email ini!.</p> ";
    setState(() {
      isLoading = true;
    });
    await send(equivalentMessage, smtpServer);
    setState(() {
      isLoading = false;
    });
    if (smtpServer != null) {
      AlertDialog alert = AlertDialog(
        title: Text("Email Berhasil Dikirim"),
        content: Text("Silahkan cek inbox email anda"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const Login()));
              },
              child: Text("Kembali ke halaman login"))
        ],
      );
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    } else {
      AlertDialog alert = AlertDialog(
        title: Text("Email gagal dikirim "),
        content: Text("Silahkan cek koneksi internet anda"),
        actions: [TextButton(onPressed: () {}, child: Text("OK"))],
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
                      key: _FormKey,
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
                          SizedBox(height: 20),
                          Text(
                            "Lupa Password",
                            style: TextStyle(
                              color: GlobalColors.textColor,
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: Icon(Icons.email),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              if (_FormKey.currentState!.validate()) {
                                sendMail(emailController.text);
                              }
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
                                    // margin: const EdgeInsets.symmetric(horizontal: 20),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .blue, // Ganti warna sesuai kebutuhan
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
                              Get.toNamed('/lo');
                            },
                            child: Text(
                              'Kembali ke Menu Login',
                              style: TextStyle(
                                color: GlobalColors.textColor,
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
