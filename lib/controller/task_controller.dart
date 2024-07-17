import 'dart:io';

import 'package:destask/controller/bobot_kategori_task_controller.dart';
import 'package:destask/model/bobot_kategori_task_model.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

import '../model/task_model.dart';
import '../utils/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

// API link
const url = '$baseURL/api/task';
const urluser = '$baseURL/api/taskbyuser';
const urlpekerjaan = '$baseURL/api/taskbypekerjaan';

Future getToken() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");
  return token;
}

Future getUserLevel() async {
  final prefs = await SharedPreferences.getInstance();
  var userlevel = prefs.getString("user_level");
  return userlevel;
}

Future getIdUser() async {
  final prefs = await SharedPreferences.getInstance();
  var idUser = prefs.getString("id_user");
  return idUser;
}

class TaskController {
  //fungsi mendapatkan task berdasarkan id
  Future getTaskById(String idTask) async {
    try {
      var token = await getToken();
      var response = await http.get(Uri.parse('$url/$idTask'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<TaskModel> user =
            List<TaskModel>.from(it.map((e) => TaskModel.fromJson(e)).toList());
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
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  //fungsi menampilkan task berdasarkan id
  Future<List<TaskModel>> showById(String idTask) async {
    List<TaskModel> data = await getTaskById(idTask);
    return data;
  }

  //fungsi mendapatkan task berdasarkan id pekerjaan dan tanggal
  Future getTasksByPekerjaanId(String idPekerjaan) async {
    var token = await getToken();
    var response = await http.get(Uri.parse('$urlpekerjaan/$idPekerjaan'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      Iterable it = json.decode(response.body);
      List<TaskModel> task =
          List<TaskModel>.from(it.map((e) => TaskModel.fromJson(e)).toList());
      return task;
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
      print(response.statusCode);
      return [];
    }
  }

  //fungsi menampilkan task berdasarkan id pekerjaan
  Future<List<TaskModel>> showByPekerjaanId(
      String idPekerjaan, DateTime selectedDate) async {
    List<TaskModel> data = await getTasksByPekerjaanId(idPekerjaan);
    return data;
  }

  //fungsi mendapatkan task berdasarkan id user dan id pekerjaan
  Future getTasksByUserPekerjaan(String idPekerjaan) async {
    try {
      var token = await getToken();
      var idUser = await getIdUser();
      var response = await http.get(Uri.parse('$urluser/$idUser'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<TaskModel> tasks = List<TaskModel>.from(it
            .where((element) => element['id_pekerjaan'] == idPekerjaan)
            .map((e) => TaskModel.fromJson(e))
            .toList());
        return tasks;
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
        print(response.statusCode);
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //fungsi menampilkan task berdasarkan id user dan id pekerjaan
  Future<List<TaskModel>> showByUserPekerjaan(String idPekerjaan) async {
    List<TaskModel> data = await getTasksByUserPekerjaan(idPekerjaan);
    return data;
  }

  //fungsi add task
  Future addTask(
    String idPekerjaan,
    String idanggotauser,
    String idKategoriTask,
    DateTime tglPlaning,
    String deskripsiTask,
  ) async {
    try {
      var token = await getToken();
      var idUser = await getIdUser();
      var response = await http.post(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'id_pekerjaan': idPekerjaan,
          'id_user': idanggotauser,
          'creator': idUser,
          'id_status_task': "1", //default on progress
          'id_kategori_task': idKategoriTask,
          'tgl_planing': tglPlaning.toIso8601String(),
          'deskripsi_task': deskripsiTask,
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

  //fungsi edit task
  Future editTask(
    String idTask,
    String idPekerjaan,
    String idKategoriTask,
    DateTime tglPlaning,
    String deskripsiTask,
    String persentaseSelesai,
  ) async {
    try {
      var token = await getToken();
      var idUser = await getIdUser();
      final data = {
        "id_task": idTask,
        "id_pekerjaan": idPekerjaan,
        "id_user": idUser,
        "id_kategori_task": idKategoriTask,
        "tgl_planing": tglPlaning.toIso8601String(),
        "persentase_selesai": persentaseSelesai,
        "deskripsi_task": deskripsiTask,
      };
      print(jsonEncode(data));
      var response = await http.put(
        Uri.parse('$url/$idTask'),
        headers: {
          'Content-Type': 'application/json', // Add Content-Type header
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );
      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print(response.statusCode);
        print(response.body);
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
        print('$url/$idTask');
        print('Error editing task: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception editing task: $e');
      return false;
    }
  }

  Future submit(
    String idTask,
    String tautanTask,
    File imageFile,
  ) async {
    var idUser = await getIdUser();
    var userlevel = await getUserLevel();
    var stream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var uri = Uri.parse('$url/submit');
    var token = await getToken();

    var request = http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = 'Bearer $token';

    var MultiPartFile = http.MultipartFile('bukti_selesai', stream, length,
        filename: basename(imageFile.path));

    Map<String, String> body = {
      'id_task': idTask,
      'tautan_task': tautanTask,
      'user_level': userlevel,
      'verifikator': idUser,
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

  //delete task
  Future deleteTask(
    String idTask,
  ) async {
    try {
      var token = await getToken();
      var response = await http.delete(Uri.parse('$url/$idTask'),
          headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        print(response.body);
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
        print('Error deleting task: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception deleting task: $e');
      return false;
    }
  }

  Future getTaskBulanIni() async {
    try {
      final now = DateTime.now();
      final month = now.month.toString().padLeft(2, '0');
      final year = now.year.toString();
      var token = await getToken();
      var idUser = await getIdUser();
      var response = await http.get(Uri.parse('$urluser/$idUser'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<TaskModel> tasks =
            List<TaskModel>.from(it.map((e) => TaskModel.fromJson(e)).toList());
        final List<TaskModel> filteredTasks = [];
        for (var i = 0; i < tasks.length; i++) {
          final task = tasks[i];
          if (task.tgl_selesai != null) {
            final taskDate = task.tgl_selesai!;
            if (taskDate.month.toString().padLeft(2, '0') == month &&
                taskDate.year.toString() == year) {
              filteredTasks.add(task);
            }
          }
        }
        return filteredTasks;
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
        print(response.statusCode);
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<int> TotalBobotPoinTaskBulanIni() async {
    try {
      final List<TaskModel> tasks =
          await getTaskBulanIni(); // Dapatkan semua task untuk bulan ini
      final BobotKategoriTaskController bobotKategoriTaskController =
          BobotKategoriTaskController();
      int totalBobotPoin = 0;

      // Iterasi semua task
      for (var task in tasks) {
        // Dapatkan bobot poin dari tabel bobot kategori untuk setiap task
        final BobotKategoriTaskModel bobotKategoriTask =
            await bobotKategoriTaskController
                .getBobotKategoriTaskById(task.id_kategori_task.toString());
        if (bobotKategoriTask != null) {
          totalBobotPoin += bobotKategoriTask.bobot_poin as int;
        }
      }

      return totalBobotPoin;
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }

  //fungsi mendapatkan task berdasarkan id user
  Future getTaskByUser() async {
    var token = await getToken();
    var iduser = await getIdUser();
    var response = await http.get(Uri.parse('$urluser/$iduser'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      Iterable it = json.decode(response.body);
      List<TaskModel> task =
          List<TaskModel>.from(it.map((e) => TaskModel.fromJson(e)).toList());
      return task;
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
      print(response.statusCode);
      print(response.body);
      return [];
    }
  }

  Future getTaskVerifikasi(idPekerjaan) async {
    var token = await getToken();
    var iduser = await getIdUser();
    var response = await http.get(Uri.parse('$url/verifikasi/$iduser'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      // print(response.body);
      Iterable it = json.decode(response.body);
      List<TaskModel> task = List<TaskModel>.from(it
          .where((element) => element['id_pekerjaan'] == idPekerjaan)
          .map((e) => TaskModel.fromJson(e))
          .toList());
      return task;
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
      print(response.statusCode);
      print(response.body);
      return [];
    }
  }

  Future editTaskVerikasiTolak(
    String idTask,
    String alasanVerifikasi,
  ) async {
    try {
      var idUser = await getIdUser();
      var token = await getToken();
      final datatolak = {
        'id_task': idTask,
        "alasan_verifikasi": alasanVerifikasi,
        'verifikator': idUser,
      };
      var response = await http.put(
        Uri.parse('$url/verifikasi/tolak/$idTask'),
        headers: {
          'Content-Type': 'application/json', // Add Content-Type header
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(datatolak),
      );

      if (response.statusCode == 200) {
        print(response.statusCode);
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
        print('$url/$idTask');
        print('Error editing task: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception editing task: $e');
      return false;
    }
  }

  Future editTaskVerikasiDiterima(
    String idTask,
  ) async {
    try {
      var idUser = await getIdUser();
      var token = await getToken();
      final data = {
        'id_task': idTask,
        'verifikator': idUser,
      };
      var response = await http.put(
        Uri.parse('$url/verifikasi/terima/$idTask'),
        headers: {
          'Content-Type': 'application/json', // Add Content-Type header
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print(response.statusCode);
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
        print('$url/$idTask');
        print('Error editing task: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception editing task: $e');
      return false;
    }
  }

  //rekap point
  Future<List> getRekapPoint() async {
    var token = await getToken();
    var iduser = await getIdUser();
    var response =
        await http.get(Uri.parse('$url/rekappoint/$iduser'), headers: {
      "Authorization": "Bearer $token",
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      return [];
    }
  }

  Future getTaskVerifikator(idPekerjaan) async {
    var token = await getToken();
    var iduser = await getIdUser();
    var response = await http.get(Uri.parse('$url/verifikator/$iduser'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      // print(response.body);
      Iterable it = json.decode(response.body);
      List<TaskModel> task = List<TaskModel>.from(it
          .where((element) => element['id_pekerjaan'] == idPekerjaan)
          .map((e) => TaskModel.fromJson(e))
          .toList());
      return task;
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
      print(response.statusCode);
      print(response.body);
      return [];
    }
  }
}
