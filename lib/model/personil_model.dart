class PersonilModel {
  final String? id_personil;
  final String? id_user_pm;
  final String? desainer1;
  final String? desainer2;
  final String? be_web1;
  final String? be_web2;
  final String? be_web3;
  final String? be_mobile1;
  final String? be_mobile2;
  final String? be_mobile3;
  final String? fe_web1;
  final String? fe_mobile1;

  PersonilModel({
    this.id_personil,
    this.id_user_pm,
    this.desainer1,
    this.desainer2,
    this.be_web1,
    this.be_web2,
    this.be_web3,
    this.be_mobile1,
    this.be_mobile2,
    this.be_mobile3,
    this.fe_web1,
    this.fe_mobile1,
  });

  factory PersonilModel.fromJson(Map<String, dynamic> json) {
    return PersonilModel(
      id_personil: json['id_personil'],
      id_user_pm: json['id_user_pm'],
      desainer1: json['desainer1'],
      desainer2: json['desainer2'],
      be_web1: json['be_web1'],
      be_web2: json['be_web2'],
      be_web3: json['be_web3'],
      be_mobile1: json['be_mobile1'],
      be_mobile2: json['be_mobile2'],
      be_mobile3: json['be_mobile3'],
      fe_web1: json['fe_web1'],
      fe_mobile1: json['fe_mobile1'],
    );
  }
}
