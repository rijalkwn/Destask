class KategoriPekerjaanModel {
  final String? id_kategori_pekerjaan;
  final String? nama_kategori_pekerjaan;
  final String? deskripsi_kategori_pekerjaan;

  KategoriPekerjaanModel({
    this.id_kategori_pekerjaan,
    this.nama_kategori_pekerjaan,
    this.deskripsi_kategori_pekerjaan,
  });

  factory KategoriPekerjaanModel.fromJson(Map<String, dynamic> json) {
    return KategoriPekerjaanModel(
      id_kategori_pekerjaan: json['id_kategori_pekerjaan'],
      nama_kategori_pekerjaan: json['nama_kategori_pekerjaan'],
      deskripsi_kategori_pekerjaan: json['deskripsi_kategori_pekerjaan'],
    );
  }
}
