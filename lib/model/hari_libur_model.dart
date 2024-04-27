class HariLiburModel {
  String id_hari_libur;
  DateTime tanggal_libur;
  String keterangan;

  HariLiburModel(
      {required this.id_hari_libur,
      required this.tanggal_libur,
      required this.keterangan});

  factory HariLiburModel.fromJson(Map<String, dynamic> json) {
    return HariLiburModel(
      id_hari_libur: json['id_hari_libur'],
      tanggal_libur: DateTime.parse(json['tanggal_libur']),
      keterangan: json['keterangan'],
    );
  }
}
