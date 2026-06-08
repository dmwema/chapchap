class RelationModel {
  int? idRelation;
  String? relation;

  RelationModel({this.idRelation, this.relation});

  RelationModel.fromJson(Map<String, dynamic> json) {
    idRelation = json['idRelation'];
    relation = json['relation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idRelation'] = idRelation;
    data['relation'] = relation;
    return data;
  }
}
