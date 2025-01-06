class ConversionRule {
  int? id;
  int? pointsRequired;
  String? cashValue;

  ConversionRule({this.id, this.pointsRequired, this.cashValue});

  ConversionRule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pointsRequired = json['points_required'];
    cashValue = json['cash_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['points_required'] = this.pointsRequired;
    data['cash_value'] = this.cashValue;
    return data;
  }
}
