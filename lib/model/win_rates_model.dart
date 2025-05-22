class WinRatesModel {
  String? game_type;
  String? rate;

  WinRatesModel({
    this.game_type,
    this.rate,
  });

  WinRatesModel.fromJson(Map<String, dynamic> json) {
    game_type = json['game_type'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['game_type'] = this.game_type;
    data['rate'] = this.rate;

    return data;
  }
}
