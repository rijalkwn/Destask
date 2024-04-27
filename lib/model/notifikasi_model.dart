class NotifikasiModel {
  String id_notifikasi;
  String id_user;
  String id_task;
  String id_pekerjaan;
  String id_kinerja;
  String judul_notifikasi;
  String pesan_notifikasi;
  String status_terbaca;
  DateTime created_at;

  NotifikasiModel({
    required this.id_notifikasi,
    required this.id_user,
    required this.id_task,
    required this.id_pekerjaan,
    required this.id_kinerja,
    required this.judul_notifikasi,
    required this.pesan_notifikasi,
    required this.status_terbaca,
    required this.created_at,
  });

  factory NotifikasiModel.fromJson(Map<String, dynamic> json) {
    return NotifikasiModel(
      id_notifikasi: json['id_notifikasi'],
      id_user: json['id_user'],
      id_task: json['id_task'],
      id_pekerjaan: json['id_pekerjaan'],
      id_kinerja: json['id_kinerja'],
      judul_notifikasi: json['judul_notifikasi'],
      pesan_notifikasi: json['pesan_notifikasi'],
      status_terbaca: json['status_terbaca'],
      created_at: DateTime.parse(json['created_at']),
    );
  }
}
