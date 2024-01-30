class StatusPekerjaanModel {
  final String? id_status_pekerjaan;
  final String? nama_status_pekerjaan;
  final String? deskripsi_status_pekerjaan;

  StatusPekerjaanModel({
    this.id_status_pekerjaan,
    this.nama_status_pekerjaan,
    this.deskripsi_status_pekerjaan,
  });

  factory StatusPekerjaanModel.fromJson(Map<String, dynamic> json) {
    return StatusPekerjaanModel(
      id_status_pekerjaan: json['id_status_pekerjaan'],
      nama_status_pekerjaan: json['nama_status_pekerjaan'],
      deskripsi_status_pekerjaan: json['deskripsi_status_pekerjaan'],
    );
  }
}
