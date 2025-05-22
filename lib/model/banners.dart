class BannersModel {
  String? id;
  String? imgpath;
  String? description;
  String? deleted;
  String? link;
  String? dt;

  BannersModel(
      {this.id, this.imgpath, this.description, this.deleted, this.dt,this.link});

  BannersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imgpath = json['imgpath'];
    description = json['description'];
    deleted = json['deleted'];
    link=json["link"];
    dt = json['dt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imgpath'] = this.imgpath;
    data['description'] = this.description;
    data['deleted'] = this.deleted;
    data["link"]=this.link;
    data['dt'] = this.dt;
    return data;
  }
}
