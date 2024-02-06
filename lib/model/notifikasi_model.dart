class NotifikasiModel {
  String? id_notifikasi;
  String? id_user;
  String? id_task;
  String? id_pekerjaan;
  String? id_kinerja;
  String? judul_notifikasi;
  String? pesan_notifikasi;
  String? status_terbaca;
  DateTime created_at;

  NotifikasiModel({
    this.id_notifikasi,
    this.id_user,
    this.id_task,
    this.id_pekerjaan,
    this.id_kinerja,
    this.judul_notifikasi,
    this.pesan_notifikasi,
    this.status_terbaca,
    required this.created_at,
  });

  factory NotifikasiModel.fromJson(Map<String, dynamic> json) {
    return NotifikasiModel(
      id_notifikasi: json['id_notifikasi']?.toString(),
      id_user: json['id_user']?.toString(),
      id_task: json['id_task']?.toString(),
      id_pekerjaan: json['id_pekerjaan']?.toString(),
      id_kinerja: json['id_kinerja']?.toString(),
      judul_notifikasi: json['judul_notifikasi']?.toString(),
      pesan_notifikasi: json['pesan_notifikasi']?.toString(),
      status_terbaca: json['status_terbaca']?.toString(),
      created_at: DateTime.parse(json['created_at']),
    );
  }
}
