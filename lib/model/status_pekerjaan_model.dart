class StatusPekerjaanModel {
  String id_status_pekerjaan;
  String nama_status_pekerjaan;
  String deskripsi_status_pekerjaan;

  StatusPekerjaanModel({
    required this.id_status_pekerjaan,
    required this.nama_status_pekerjaan,
    required this.deskripsi_status_pekerjaan,
  });

  factory StatusPekerjaanModel.fromJson(Map<String, dynamic> json) {
    return StatusPekerjaanModel(
      id_status_pekerjaan: json['id_status_pekerjaan'].toString(),
      nama_status_pekerjaan: json['nama_status_pekerjaan'].toString(),
      deskripsi_status_pekerjaan: json['deskripsi_status_pekerjaan'].toString(),
    );
  }
}
