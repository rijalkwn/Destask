class PersonilModel {
  String id_personil;
  String id_pekerjaan;
  String id_user;
  String role_personil;

  PersonilModel({
    required this.id_personil,
    required this.id_pekerjaan,
    required this.id_user,
    required this.role_personil,
  });

  factory PersonilModel.fromJson(Map<String, dynamic> json) {
    return PersonilModel(
      id_personil: json['id_personil'],
      id_pekerjaan: json['id_pekerjaan'],
      id_user: json['id_user'],
      role_personil: json['role_personil'],
    );
  }
}
