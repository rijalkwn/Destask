import 'dart:convert';
import 'dart:io';
import 'package:destask/utils/constant_api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

const url = '$baseURL/api/user/fotoprofil';

class Foto extends StatefulWidget {
  final String id_user;
  final String category;
  const Foto({required this.id_user, required this.category, super.key});

  @override
  State<Foto> createState() => _FotoState();
}

class _FotoState extends State<Foto> {
  File? _image;
  bool isUploading = false;
  bool isFailed = false;

  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    return token;
  }

  getIdUser() async {
    final prefs = await SharedPreferences.getInstance();
    var idUser = prefs.getString("id_user");
    return idUser;
  }

  //mengambil gambar dari gallery
  Future getImageGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
  }

  //mengambil gambar dari camera
  Future getImageCamera() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image!.path);
    });
  }

  //function upload image
  Future<String?> uploadImage(BuildContext context, File imageFile) async {
    var stream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var id_user = await getIdUser();
    var uri = Uri.parse(url);
    var token = await getToken();

    var request = http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = 'Bearer $token';

    var MultiPartFile = http.MultipartFile('foto_profil', stream, length,
        filename: basename(imageFile.path));

    Map<String, String> body = {'id_user': id_user};

    request.fields.addAll(body);
    request.files.add(MultiPartFile);

    try {
      var streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        print(streamedResponse.statusCode);
        print("Image Uploaded");
        var response = await http.Response.fromStream(streamedResponse);
        Map<String, dynamic> parsed = jsonDecode(response.body);
        return parsed['foto_profil'];
      } else {
        print(streamedResponse.statusCode);
        print(streamedResponse.reasonPhrase);
        var response = await http.Response.fromStream(streamedResponse);
        Map<String, dynamic> parsed = jsonDecode(response.body);
        print(parsed);
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Foto"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 250,
              child: Center(
                child: _image == null
                    ? Text("No image selected.")
                    : Image.file(_image!),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      getImageGallery();
                    },
                    child: Text("gallery")),
                ElevatedButton(
                    onPressed: () {
                      getImageCamera();
                    },
                    child: Text("camera")),
              ],
            ),
            isUploading == false
                ? ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isUploading = true;
                      });
                      var success = await uploadImage(context, _image!);
                      if (success != null) {
                        Navigator.pop(context, success);
                      } else {
                        setState(() {
                          isUploading = false;
                          isFailed = true;
                        });
                      }
                    },
                    child: Text("Upload"))
                : CircularProgressIndicator(),
            isFailed
                ? Text(
                    'Upload gagal',
                    style: TextStyle(color: Colors.redAccent),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
