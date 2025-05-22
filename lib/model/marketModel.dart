class MarketModel {
  String? id;
  String? name;
  String? imgpath;
  String? oOtime;
  String? oCtime;
  String? cOtime;
  String? cCtime;
  String? deleted;
  String? dt;
  String? highlight;
  String? type;
  String? status;
  String? charturl;
  String? result;
  String? marketCloseStatus;
  String? marketOpenStatus;
  String? marketStatus;
  String? openCloseTime;
  String? closeCloseTime;
  String? cTime;

  MarketModel(
      {this.id,
      this.name,
      this.imgpath,
      this.oOtime,
      this.oCtime,
      this.cOtime,
      this.cCtime,
      this.deleted,
      this.dt,
      this.highlight,
      this.type,
      this.status,
      this.charturl,
      this.result,
      this.marketCloseStatus,
      this.marketOpenStatus,
      this.marketStatus,this.openCloseTime,this.closeCloseTime,required this.cTime});

  MarketModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imgpath = json['imgpath'];
    oOtime = json['o_otime'];
    oCtime = json['o_ctime'];
    cOtime = json['c_otime'];
    cCtime = json['c_ctime'];
    deleted = json['deleted'];
    dt = json['dt'];
    highlight = json['highlight'];
    type = json['type'];
    status = json['status'];
    charturl = json['charturl'];
    result = json['result'];
    openCloseTime=json["open_close_time"];
    closeCloseTime=json["close_close_time"];
    marketCloseStatus = json['market_close_status'];
    marketOpenStatus = json['market_open_status'];
    marketStatus = json['market_status'];
    cTime=json['ctime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['imgpath'] = this.imgpath;
    data['o_otime'] = this.oOtime;
    data['o_ctime'] = this.oCtime;
    data['c_otime'] = this.cOtime;
    data['c_ctime'] = this.cCtime;
    data['deleted'] = this.deleted;
    data['dt'] = this.dt;
    data['highlight'] = this.highlight;
    data['type'] = this.type;
    data['status'] = this.status;
    data['charturl'] = this.charturl;
    data['result'] = this.result;
    data['market_close_status'] = this.marketCloseStatus;
    data['market_open_status'] = this.marketOpenStatus;
    data['market_status'] = this.marketStatus;
    data["open_close_time"]=this.openCloseTime;
    data["close_close_time"]=this.closeCloseTime;
    data['ctime']=this.cTime;
    return data;
  }
}
