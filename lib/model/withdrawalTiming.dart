class WithdrwalTiming {
  String? withdrawOpenTime;
  String? withdrawCloseTime;

  WithdrwalTiming({this.withdrawOpenTime, this.withdrawCloseTime});

  WithdrwalTiming.fromJson(Map<String, dynamic> json) {
    withdrawOpenTime = json['withdraw_open_time'];
    withdrawCloseTime = json['withdraw_close_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['withdraw_open_time'] = this.withdrawOpenTime;
    data['withdraw_close_time'] = this.withdrawCloseTime;
    return data;
  }
}
