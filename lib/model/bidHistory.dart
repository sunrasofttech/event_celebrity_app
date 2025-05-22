class BidHistoryModel {
  String? userid;
  String? digit;
  String? type;
  String? market;
  String? marketName;
  String? mtype;
  String? winAmt;
  String? dt;
  String? win;
  String? points;
  String? gameType;
  String? message;
  String? userbalance;
  String? toAc;
  String? transactionType;
  String? pana;

  BidHistoryModel(
      {this.userid,
      this.digit,
      this.type,
      this.market,
      this.marketName,
      this.mtype,
      this.winAmt,
      this.dt,
      this.win,
      this.points,
      this.gameType,
      this.message,
      this.userbalance,
      this.toAc,
      this.transactionType,
      this.pana});

  BidHistoryModel.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    digit = json['digit'];
    type = json['type'];
    market = json['market'];
    marketName = json['marketName'];
    mtype = json['mtype'];
    winAmt = json['winAmt'];
    dt = json['dt'];
    win = json['win'];
    points = json['points'];
    gameType = json['game_type'];
    message = json['message'];
    userbalance = json['userbalance'];
    toAc = json['to_ac'];
    transactionType = json['transaction_type'];
    pana = json['pana'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['digit'] = this.digit;
    data['type'] = this.type;
    data['market'] = this.market;
    data['marketName'] = this.marketName;
    data['mtype'] = this.mtype;
    data['winAmt'] = this.winAmt;
    data['dt'] = this.dt;
    data['win'] = this.win;
    data['points'] = this.points;
    data['game_type'] = this.gameType;
    data['message'] = this.message;
    data['userbalance'] = this.userbalance;
    data['to_ac'] = this.toAc;
    data['transaction_type'] = this.transactionType;
    data['pana'] = this.pana;
    return data;
  }
}
