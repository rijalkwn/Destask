class KategoriPekerjaanModel {
  String id_kategori_pekerjaan;
  String nama_kategori_pekerjaan;
  String deskripsi_kategori_pekerjaan;

  KategoriPekerjaanModel({
    required this.id_kategori_pekerjaan,
    required this.nama_kategori_pekerjaan,
    required this.deskripsi_kategori_pekerjaan,
  });

  factory KategoriPekerjaanModel.fromJson(Map<String, dynamic> json) {
    return KategoriPekerjaanModel(
      id_kategori_pekerjaan: json['id_kategori_pekerjaan'],
      nama_kategori_pekerjaan: json['nama_kategori_pekerjaan'],
      deskripsi_kategori_pekerjaan: json['deskripsi_kategori_pekerjaan'],
    );
  }
}
