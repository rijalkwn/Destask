import 'dart:io';

import 'package:destask/controller/bobot_kategori_task_controller.dart';
import 'package:destask/model/bobot_kategori_task_model.dart';

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

Future getIdUser() async {
  final prefs = await SharedPreferences.getInstance();
  var idUser = prefs.getString("id_user");
  return idUser;
}

class TaskController {
  //fungsi mendapatkan semua task
  Future getAllTask() async {
    var token = await getToken();
    var response = await http
        .get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      Iterable it = json.decode(response.body);
      List<TaskModel> task =
          List<TaskModel>.from(it.map((e) => TaskModel.fromJson(e)).toList());
      return task;
    } else {
      // Handle error
      return [];
    }
  }

  //fungsi menampilkan semua task
  Future<List<TaskModel>> showAll() async {
    List<TaskModel> data = await getAllTask();
    return data;
  }

  //fungsi mendapatkan task berdasarkan id
  Future<List<TaskModel>> getTaskById(String idTask) async {
    try {
      var token = await getToken();
      var response = await http.get(Uri.parse('$url/$idTask'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<TaskModel> user =
            List<TaskModel>.from(it.map((e) => TaskModel.fromJson(e)).toList());
        return user;
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

  //boolean cek apakah task ada di tanggal yang dipilih
  bool isTaskOnSelectedDate(Map<String, dynamic> task, DateTime selectedDate) {
    DateTime createdTask = DateTime.parse(task['created_at']);
    DateTime? taskSelesai = task['tgl_selesai'] != null
        ? DateTime.parse(task['tgl_selesai'])
        : null;
    return selectedDate
            .isAfter(createdTask.subtract(const Duration(days: 1))) &&
        (taskSelesai == null ||
            selectedDate.isBefore(taskSelesai.add(const Duration(days: 1))));
  }

  //fungsi mendapatkan task berdasarkan id pekerjaan dan tanggal
  Future<List<TaskModel>> getTasksByPekerjaanId(
      String idPekerjaan, DateTime selectedDate) async {
    var token = await getToken();
    var response = await http.get(Uri.parse('$urlpekerjaan/$idPekerjaan'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      Iterable it = json.decode(response.body);
      List<TaskModel> task = List<TaskModel>.from(it
          .where((element) => isTaskOnSelectedDate(element, selectedDate))
          .map((e) => TaskModel.fromJson(e))
          .toList());
      return task;
    } else {
      print(response.statusCode);
      return [];
    }
  }

  //fungsi menampilkan task berdasarkan id pekerjaan
  Future<List<TaskModel>> showByPekerjaanId(
      String idPekerjaan, DateTime selectedDate) async {
    List<TaskModel> data =
        await getTasksByPekerjaanId(idPekerjaan, selectedDate);
    return data;
  }

  //fungsi mendapatkan task berdasarkan id user dan id pekerjaan dan tanggal
  Future<List<TaskModel>> getTasksByUserPekerjaanDate(
      String idPekerjaan, DateTime selectedDate) async {
    try {
      var token = await getToken();
      var idUser = await getIdUser();
      var response = await http.get(Uri.parse('$urluser/$idUser'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<TaskModel> tasks = List<TaskModel>.from(it
            .where((element) =>
                element['id_pekerjaan'] == idPekerjaan &&
                isTaskOnSelectedDate(element, selectedDate))
            .map((e) => TaskModel.fromJson(e))
            .toList());
        return tasks;
      } else {
        print(response.statusCode);
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  //fungsi menampilkan task berdasarkan id user dan id pekerjaan dan tanggal
  Future<List<TaskModel>> showByUserPekerjaanDate(
      String idPekerjaan, DateTime selectedDate) async {
    List<TaskModel> data =
        await getTasksByUserPekerjaanDate(idPekerjaan, selectedDate);
    return data;
  }

  //fungsi mendapatkan task berdasarkan id user dan id pekerjaan
  Future<List<TaskModel>> getTasksByUserPekerjaan(String idPekerjaan) async {
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
    String idStatusTask,
    String idKategoriTask,
    DateTime tglPlaning,
    String deskripsiTask,
    String tautanTask,
  ) async {
    try {
      var token = await getToken();
      var idUser = await getIdUser();
      var response = await http.post(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'id_pekerjaan': idPekerjaan,
          'id_user': idUser,
          'id_status_task': idStatusTask,
          'id_kategori_task': idKategoriTask,
          'tgl_planing':
              tglPlaning.toIso8601String(), // Convert DateTime to string
          'deskripsi_task': deskripsiTask,
          'tautan_task': tautanTask,
        },
      );

      if (response.statusCode == 200) {
        return true;
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
    String idStatusTask,
    String idKategoriTask,
    DateTime tglPlaning,
    String deskripsiTask,
    String tautanTask,
    String persentaseSelesai,
  ) async {
    try {
      var token = await getToken();
      var idUser = await getIdUser();
      var formattedDate =
          "${tglPlaning.year}-${tglPlaning.month.toString().padLeft(2, '0')}-${tglPlaning.day.toString().padLeft(2, '0')}";
      final data = {
        "id_task": idTask.toString(),
        "id_pekerjaan": idPekerjaan.toString(),
        "id_user": idUser.toString(),
        "id_status_task": idStatusTask.toString(),
        "id_kategori_task": idKategoriTask.toString(),
        "tgl_planing": formattedDate,
        "persentase_selesai": persentaseSelesai.toString(),
        "deskripsi_task": deskripsiTask.toString(),
        "tautan_task": tautanTask.toString()
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

  //update foto profil
  Future<bool> uploadImage(File imageFile, String idTask) async {
    var stream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var uri = Uri.parse('$url/submit');
    var token = await getToken();

    var request = http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = 'Bearer $token';

    var MultiPartFile = http.MultipartFile('bukti_selesai', stream, length,
        filename: basename(imageFile.path));

    Map<String, String> body = {'id_task': idTask};

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
            final taskDate = DateTime.parse(task.tgl_selesai!);
            if (taskDate.month.toString().padLeft(2, '0') == month &&
                taskDate.year.toString() == year) {
              filteredTasks.add(task);
            }
          }
        }

        return filteredTasks;
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
          totalBobotPoin += bobotKategoriTask.bobot_poin! as int;
        }
      }

      return totalBobotPoin;
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }

  getTaskVerifikasi() async {
    var token = await getToken();
    var iduser = await getIdUser();
    var response = await http.get(Uri.parse('$url/verifikasi/$iduser'),
        headers: {'Authorization': 'Bearer' + token});
    if (response.statusCode == 200) {
      Iterable it = json.decode(response.body);
      List<TaskModel> task =
          List<TaskModel>.from(it.map((e) => TaskModel.fromJson(e)).toList());
      return task;
    } else {
      return [];
    }
  }
}
