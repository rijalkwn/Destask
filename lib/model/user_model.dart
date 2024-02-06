class UserModel {
  final String id_user;
  String id_usergroup;
  String username;
  String email;
  String password;
  String user_role;
  String user_level;
  String nama;
  String status_keaktifan;
  String foto_profil;

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
      id_user: json['id_user'],
      id_usergroup: json['id_usergroup'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      user_role: json['user_role'],
      user_level: json['user_level'],
      nama: json['nama'],
      status_keaktifan: json['status_keaktifan'],
      foto_profil: json['foto_profil'],
    );
  }
}
