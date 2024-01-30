class KategoriPekerjaanModel {
  final String? id_kategori_task;
  final String? nama_kategori_task;
  final String? deskripsi_kategori_task;

  KategoriPekerjaanModel({
    this.id_kategori_task,
    this.nama_kategori_task,
    this.deskripsi_kategori_task,
  });

  factory KategoriPekerjaanModel.fromJson(Map<String, dynamic> json) {
    return KategoriPekerjaanModel(
      id_kategori_task: json['id_kategori_task'],
      nama_kategori_task: json['nama_kategori_task'],
      deskripsi_kategori_task: json['deskripsi_kategori_task'],
    );
  }
}
