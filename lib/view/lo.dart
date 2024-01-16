import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Lo extends StatefulWidget {
  const Lo({super.key});

  @override
  State<Lo> createState() => _LoState();
}

class _LoState extends State<Lo> {
  bool _obsecuretext = true;

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
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.08,
                              bottom: MediaQuery.of(context).size.height * 0.1),
                          child: Image.asset(
                            'assets/img/logo.png',
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          // controller: usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(Icons.person),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          // controller: passwordController,
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
                        ),
                        SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Get.toNamed('/bottomnav');
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            // margin: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:
                                  Colors.blue, // Ganti warna sesuai kebutuhan
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
