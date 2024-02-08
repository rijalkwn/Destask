import 'package:destask/utils/constant_api.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// API link
const url = '$baseURL/api/task';

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

class TaskSubmitController {
  Future<bool> submitTask(
    String idTask,
    String idPekerjaan,
    String idStatusTask,
    String idKategoriTask,
    DateTime tglPlaning,
    String deskripsiTask,
    String tautanTask,
    String persentaseSelesai,
    String fileName,
    String filePath,
  ) async {
    try {
      var token = await getToken();
      var idUser = await getIdUser();
      var formattedDate =
          "${tglPlaning.year}-${tglPlaning.month.toString().padLeft(2, '0')}-${tglPlaning.day.toString().padLeft(2, '0')}";

      FormData formData = FormData.fromMap({
        "id_task": idTask.toString(),
        "id_pekerjaan": idPekerjaan.toString(),
        "id_user": idUser.toString(),
        "id_status_task": idStatusTask.toString(),
        "id_kategori_task": idKategoriTask.toString(),
        "tgl_planing": formattedDate,
        "persentase_selesai": persentaseSelesai.toString(),
        "deskripsi_task": deskripsiTask.toString(),
        "tautan_task": tautanTask.toString(),
        "bukti_selesai": await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
      });

      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.headers['Content-Type'] = 'multipart/form-data';

      var response = await dio.put(
        '$url/$idTask',
        data: formData,
      );

      print(response.data);
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error submitting task: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception submitting task: $e');
      return false;
    }
  }
}
