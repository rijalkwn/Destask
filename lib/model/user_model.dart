class UserModel {
  String? id_user;
  String? id_usergroup;
  String? username;
  String? email;
  String? password;
  String? user_role;
  String? user_level;
  String? nama;
  String? status_keaktifan;
  String? foto_profil;

  UserModel({
    required this.id_user,
    required this.id_usergroup,
    required this.username,
    required this.email,
    required this.password,
    required this.user_role,
    required this.user_level,
    required this.nama,
    required this.status_keaktifan,
    required this.foto_profil,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id_user: json['id_user']?.toString(),
      id_usergroup: json['id_usergroup']?.toString(),
      username: json['username']?.toString(),
      email: json['email']?.toString(),
      password: json['password']?.toString(),
      user_role: json['user_role']?.toString(),
      user_level: json['user_level']?.toString(),
      nama: json['nama']?.toString(),
      status_keaktifan: json['status_keaktifan']?.toString(),
      foto_profil: json['foto_profil']?.toString(),
    );
  }
}
