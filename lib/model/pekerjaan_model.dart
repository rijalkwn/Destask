class PekerjaanModel {
  final String? idpekerjaan;
  final String? nama_pekerjaan;
  final String? detail_pekerjaan;
  final String? PM;
  final String? tanggal_mulai;
  final String? tanggal_selesai;
  final String? status;

  PekerjaanModel({
    this.idpekerjaan,
    this.nama_pekerjaan,
    this.detail_pekerjaan,
    this.PM,
    this.tanggal_mulai,
    this.tanggal_selesai,
    this.status,
  });

  factory PekerjaanModel.fromJson(Map<String, dynamic> json) {
    return PekerjaanModel(
      idpekerjaan: json['idpekerjaan'],
      nama_pekerjaan: json['nama_pekerjaan'],
      detail_pekerjaan: json['detail_pekerjaan'],
      PM: json['PM'],
      tanggal_mulai: json['tanggal_mulai'],
      tanggal_selesai: json['tanggal_selesai'],
      status: json['status'],
    );
  }
}
