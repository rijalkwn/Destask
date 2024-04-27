class TargetPoinHarianModel {
  String id_target_poin_harian;
  String id_usergroup;
  String tahun;
  String bulan;
  String jumlah_target_poin_harian;
  String jumlah_hari_kerja;
  String jumlah_hari_libur;
  String jumlah_target_poin_sebulan;

  TargetPoinHarianModel({
    required this.id_target_poin_harian,
    required this.id_usergroup,
    required this.tahun,
    required this.bulan,
    required this.jumlah_target_poin_harian,
    required this.jumlah_hari_kerja,
    required this.jumlah_hari_libur,
    required this.jumlah_target_poin_sebulan,
  });

  factory TargetPoinHarianModel.fromJson(Map<String, dynamic> json) {
    return TargetPoinHarianModel(
        id_target_poin_harian: json['id_target_poin_harian'],
        id_usergroup: json['id_usergroup'],
        tahun: json['tahun'],
        bulan: json['bulan'],
        jumlah_target_poin_harian: json['jumlah_target_poin_harian'],
        jumlah_hari_kerja: json['jumlah_hari_kerja'],
        jumlah_hari_libur: json['jumlah_hari_libur'],
        jumlah_target_poin_sebulan: json['jumlah_target_poin_sebulan']);
  }
}
