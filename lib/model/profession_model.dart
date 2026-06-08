class ProfessionModel {
  int? idProfession;
  String? profession;

  ProfessionModel({this.idProfession, this.profession});

  ProfessionModel.fromJson(Map<String, dynamic> json) {
    idProfession = json['idProfession'];
    profession = json['profession'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idProfession'] = idProfession;
    data['profession'] = profession;
    return data;
  }
}
