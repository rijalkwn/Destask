class PekerjaanModel {
  final String? id_pekerjaan;
  final String? id_status_pekerjaan;
  final String? id_kategori_pekerjaan;
  final String? id_personil;
  final String? nama_pekerjaan;
  final String? pelanggan;
  final String? jenis_layanan;
  final String? nominal_harga;
  final String? deskripsi_pekerjaan;
  final String? target_waktu_selesai;
  final String? persentase_selesai;
  final String? waktu_selesai;

  PekerjaanModel({
    this.id_pekerjaan,
    this.id_status_pekerjaan,
    this.id_kategori_pekerjaan,
    this.id_personil,
    this.nama_pekerjaan,
    this.pelanggan,
    this.jenis_layanan,
    this.nominal_harga,
    this.deskripsi_pekerjaan,
    this.target_waktu_selesai,
    this.persentase_selesai,
    this.waktu_selesai,
  });

  factory PekerjaanModel.fromJson(Map<String, dynamic> json) {
    return PekerjaanModel(
      id_pekerjaan: json['id_pekerjaan'],
      id_status_pekerjaan: json['id_status_pekerjaan'],
      id_kategori_pekerjaan: json['id_kategori_pekerjaan'],
      id_personil: json['id_personil'],
      nama_pekerjaan: json['nama_pekerjaan'],
      pelanggan: json['pelanggan'],
      jenis_layanan: json['jenis_layanan'],
      nominal_harga: json['nominal_harga'],
      deskripsi_pekerjaan: json['deskripsi_pekerjaan'],
      target_waktu_selesai: json['target_waktu_selesai'],
      persentase_selesai: json['persentase_selesai'],
      waktu_selesai: json['waktu_selesai'],
    );
  }
}
