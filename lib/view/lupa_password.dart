import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LupaPassword extends StatefulWidget {
  const LupaPassword({super.key});

  @override
  State<LupaPassword> createState() => _LupaPasswordState();
}

class _LupaPasswordState extends State<LupaPassword> {
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
                LupaPasswordForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LupaPasswordForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
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
              // controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Email',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
                Get.toNamed('');
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
    );
  }
}
