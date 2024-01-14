import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Lo extends StatefulWidget {
  const Lo({super.key});

  @override
  State<Lo> createState() => _LoState();
}

class _LoState extends State<Lo> {
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
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1),
                  height: 120,
                  child: Image.asset(
                    'assets/img/logo.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Selamat Datang di Destask",
              style: TextStyle(
                color: GlobalColors.textColor,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              "Silakan Login Terlebih Dahulu",
              style: TextStyle(
                color: GlobalColors.textColor,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            TextFormField(
              // controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.person),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Username tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              // controller: passwordController,
              // obscureText: _obsecuretext,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.lock),
                // suffixIcon: GestureDetector(),
                // onTap: () {
                //   setState(() {
                //     _obsecuretext = !_obsecuretext;
                //   });
                // },
                // child: _obsecuretext
                //     ? const Icon(Icons.remove_red_eye)
                //     : const Icon(Icons.remove_red_eye_outlined)),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                return null;
              },
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
                  color: Colors.blue, // Ganti warna sesuai kebutuhan
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
    );
  }
}
