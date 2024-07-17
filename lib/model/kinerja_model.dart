class KinerjaModel {
  final String id_kinerja;
  final String id_user;
  final String tahun;
  final String bulan;
  final String jumlah_hari_kerja;
  final String jumlah_kehadiran;
  final String jumlah_izin;
  final String jumlah_sakit_tnp_ket_dokter;
  final String jumlah_mangkir;
  final String jumlah_terlambat;
  final String kebersihan_diri;
  final String kerapihan_penampilan;
  final String integritas_a;
  final String integritas_b;
  final String integritas_c;
  final String kerjasama_a;
  final String kerjasama_b;
  final String kerjasama_c;
  final String kerjasama_d;
  final String orientasi_thd_konsumen_a;
  final String orientasi_thd_konsumen_b;
  final String orientasi_thd_konsumen_c;
  final String orientasi_thd_konsumen_d;
  final String orientasi_thd_target_a;
  final String orientasi_thd_target_b;
  final String orientasi_thd_target_c;
  final String orientasi_thd_target_d;
  final String inisiatif_inovasi_a;
  final String inisiatif_inovasi_b;
  final String inisiatif_inovasi_c;
  final String inisiatif_inovasi_d;
  final String professionalisme_a;
  final String professionalisme_b;
  final String professionalisme_c;
  final String professionalisme_d;
  final String organizational_awareness_a;
  final String organizational_awareness_b;
  final String organizational_awareness_c;
  final String score_kpi;

  KinerjaModel({
    required this.id_kinerja,
    required this.id_user,
    required this.tahun,
    required this.bulan,
    required this.jumlah_hari_kerja,
    required this.jumlah_kehadiran,
    required this.jumlah_izin,
    required this.jumlah_sakit_tnp_ket_dokter,
    required this.jumlah_mangkir,
    required this.jumlah_terlambat,
    required this.kebersihan_diri,
    required this.kerapihan_penampilan,
    required this.integritas_a,
    required this.integritas_b,
    required this.integritas_c,
    required this.kerjasama_a,
    required this.kerjasama_b,
    required this.kerjasama_c,
    required this.kerjasama_d,
    required this.orientasi_thd_konsumen_a,
    required this.orientasi_thd_konsumen_b,
    required this.orientasi_thd_konsumen_c,
    required this.orientasi_thd_konsumen_d,
    required this.orientasi_thd_target_a,
    required this.orientasi_thd_target_b,
    required this.orientasi_thd_target_c,
    required this.orientasi_thd_target_d,
    required this.inisiatif_inovasi_a,
    required this.inisiatif_inovasi_b,
    required this.inisiatif_inovasi_c,
    required this.inisiatif_inovasi_d,
    required this.professionalisme_a,
    required this.professionalisme_b,
    required this.professionalisme_c,
    required this.professionalisme_d,
    required this.organizational_awareness_a,
    required this.organizational_awareness_b,
    required this.organizational_awareness_c,
    required this.score_kpi,
  });

  factory KinerjaModel.fromJson(Map<String, dynamic> json) {
    return KinerjaModel(
      id_kinerja: json['id_kinerja'],
      id_user: json['id_user'].toString(),
      tahun: json['tahun'],
      bulan: json['bulan'],
      jumlah_hari_kerja: json['jumlah_hari_kerja'],
      jumlah_kehadiran: json['jumlah_kehadiran'],
      jumlah_izin: json['jumlah_izin'],
      jumlah_sakit_tnp_ket_dokter: json['jumlah_sakit_tnp_ket_dokter'],
      jumlah_mangkir: json['jumlah_mangkir'],
      jumlah_terlambat: json['jumlah_terlambat'],
      kebersihan_diri: json['kebersihan_diri'],
      kerapihan_penampilan: json['kerapihan_penampilan'],
      integritas_a: json['integritas_a'],
      integritas_b: json['integritas_b'],
      integritas_c: json['integritas_c'],
      kerjasama_a: json['kerjasama_a'],
      kerjasama_b: json['kerjasama_b'],
      kerjasama_c: json['kerjasama_c'],
      kerjasama_d: json['kerjasama_d'],
      orientasi_thd_konsumen_a: json['orientasi_thd_konsumen_a'],
      orientasi_thd_konsumen_b: json['orientasi_thd_konsumen_b'],
      orientasi_thd_konsumen_c: json['orientasi_thd_konsumen_c'],
      orientasi_thd_konsumen_d: json['orientasi_thd_konsumen_d'],
      orientasi_thd_target_a: json['orientasi_thd_target_a'],
      orientasi_thd_target_b: json['orientasi_thd_target_b'],
      orientasi_thd_target_c: json['orientasi_thd_target_c'],
      orientasi_thd_target_d: json['orientasi_thd_target_d'],
      inisiatif_inovasi_a: json['inisiatif_inovasi_a'],
      inisiatif_inovasi_b: json['inisiatif_inovasi_b'],
      inisiatif_inovasi_c: json['inisiatif_inovasi_c'],
      inisiatif_inovasi_d: json['inisiatif_inovasi_d'],
      professionalisme_a: json['professionalisme_a'],
      professionalisme_b: json['professionalisme_b'],
      professionalisme_c: json['professionalisme_c'],
      professionalisme_d: json['professionalisme_d'],
      organizational_awareness_a: json['organizational_awareness_a'],
      organizational_awareness_b: json['organizational_awareness_b'],
      organizational_awareness_c: json['organizational_awareness_c'],
      score_kpi: json['score_kpi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_kinerja': id_kinerja,
      'id_user': id_user,
      'tahun': tahun,
      'bulan': bulan,
      'jumlah_hari_kerja': jumlah_hari_kerja,
      'jumlah_kehadiran': jumlah_kehadiran,
      'jumlah_izin': jumlah_izin,
      'jumlah_sakit_tnp_ket_dokter': jumlah_sakit_tnp_ket_dokter,
      'jumlah_mangkir': jumlah_mangkir,
      'jumlah_terlambat': jumlah_terlambat,
      'kebersihan_diri': kebersihan_diri,
      'kerapihan_penampilan': kerapihan_penampilan,
      'integritas_a': integritas_a,
      'integritas_b': integritas_b,
      'integritas_c': integritas_c,
      'kerjasama_a': kerjasama_a,
      'kerjasama_b': kerjasama_b,
      'kerjasama_c': kerjasama_c,
      'kerjasama_d': kerjasama_d,
      'orientasi_thd_konsumen_a': orientasi_thd_konsumen_a,
      'orientasi_thd_konsumen_b': orientasi_thd_konsumen_b,
      'orientasi_thd_konsumen_c': orientasi_thd_konsumen_c,
      'orientasi_thd_konsumen_d': orientasi_thd_konsumen_d,
      'orientasi_thd_target_a': orientasi_thd_target_a,
      'orientasi_thd_target_b': orientasi_thd_target_b,
      'orientasi_thd_target_c': orientasi_thd_target_c,
      'orientasi_thd_target_d': orientasi_thd_target_d,
      'inisiatif_inovasi_a': inisiatif_inovasi_a,
      'inisiatif_inovasi_b': inisiatif_inovasi_b,
      'inisiatif_inovasi_c': inisiatif_inovasi_c,
      'inisiatif_inovasi_d': inisiatif_inovasi_d,
      'professionalisme_a': professionalisme_a,
      'professionalisme_b': professionalisme_b,
      'professionalisme_c': professionalisme_c,
      'professionalisme_d': professionalisme_d,
      'organizational_awareness_a': organizational_awareness_a,
      'organizational_awareness_b': organizational_awareness_b,
      'organizational_awareness_c': organizational_awareness_c,
      'score_kpi': score_kpi,
    };
  }
}
