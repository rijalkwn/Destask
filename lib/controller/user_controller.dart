import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

import '../model/user_model.dart';
import '../utils/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

const url = '$baseURL/api/user';

Future getToken() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");
  return token;
}

Future getIdUser() async {
  final prefs = await SharedPreferences.getInstance();
  var idUser = prefs.getString("id_user");
  return idUser;
}

Future getEmail() async {
  final prefs = await SharedPreferences.getInstance();
  var email = prefs.getString("email");
  return email;
}

class UserController {
  Future getAllUser() async {
    try {
      var token = await getToken();
      var response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<UserModel> user =
            List<UserModel>.from(it.map((e) => UserModel.fromJson(e)));
        return user;
      } else {
        // Handle error
        return [];
      }
    } catch (e) {
      // Handle exception
      return [];
    }
  }

  Future getUserById() async {
    try {
      var idUser = await getIdUser();
      var token = await getToken();
      var response = await http.get(
        Uri.parse('$url/$idUser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<UserModel> user =
            List<UserModel>.from(it.map((e) => UserModel.fromJson(e)).toList());
        return user;
      } else if (response.statusCode == 401) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.clear();
        Get.offAllNamed('/login');
        QuickAlert.show(
          context: Get.context!,
          title: 'Token Expired, Login Ulang',
          type: QuickAlertType.error,
        );
      } else {
        // Handle error
        return {};
      }
    } catch (e) {
      print(e);
    }
  }

  Future editProfile(
    String nama,
    String email,
  ) async {
    try {
      var token = await getToken();
      var user = await getIdUser();
      var uri = Uri.parse('$url/$user');
      final data = {
        'id_user': user,
        'nama': nama,
        'email': email,
      };
      var response = await http.put(uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data));

      if (response.statusCode == 200) {
        print(uri);
        //delete shared preferences
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('nama');
        prefs.remove('email');
        prefs.setString('nama', nama);
        prefs.setString('email', email);
        return true;
      } else if (response.statusCode == 401) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.clear();
        Get.offAllNamed('/login');
        QuickAlert.show(
          context: Get.context!,
          title: 'Token Expired, Login Ulang',
          type: QuickAlertType.error,
        );
      } else {
        print(uri);
        print('Failed to edit profile. Status code: ${response.statusCode}');
        print(response.body);
        return false;
      }
    } catch (e) {
      throw Exception('Error editing profile: $e');
    }
  }

  //update foto profil
  Future uploadImage(File imageFile) async {
    var stream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var id_user = await getIdUser();
    var uri = Uri.parse('$url/fotoprofil');
    var token = await getToken();

    var request = http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = 'Bearer $token';

    var MultiPartFile = http.MultipartFile('foto_profil', stream, length,
        filename: basename(imageFile.path));

    Map<String, String> body = {
      'id_user': id_user,
    };

    request.fields.addAll(body);
    request.files.add(MultiPartFile);

    try {
      var streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        var response = await http.Response.fromStream(streamedResponse);
        Map<String, dynamic> parsed = jsonDecode(response.body);
        print(parsed);
        return true;
      } else {
        print(streamedResponse.statusCode);
        print(streamedResponse.reasonPhrase);
        var response = await http.Response.fromStream(streamedResponse);
        Map<String, dynamic> parsed = jsonDecode(response.body);
        print(parsed);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  cekEmail(String emailbaru) async {
    try {
      var token = await getToken();
      var email = await getEmail();
      var response = await http.post(
        Uri.parse('$url/cekemail'),
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'emaillama': email,
          'emailbaru': emailbaru,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.clear();
        Get.offAllNamed('/login');
        QuickAlert.show(
          context: Get.context!,
          title: 'Token Expired, Login Ulang',
          type: QuickAlertType.error,
        );
      } else {
        print('Error adding task: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception adding task: $e');
      return false;
    }
  }
}
