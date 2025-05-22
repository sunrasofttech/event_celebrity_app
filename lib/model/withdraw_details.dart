class WithdrawDetails {
  String? withdrawQueryNo;
  String? withdrawText;

  WithdrawDetails({this.withdrawQueryNo, this.withdrawText});

  WithdrawDetails.fromJson(Map<String, dynamic> json) {
    withdrawQueryNo = json['withdraw_query_no'];
    withdrawText = json['withdraw_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['withdraw_query_no'] = this.withdrawQueryNo;
    data['withdraw_text'] = this.withdrawText;
    return data;
  }
}
