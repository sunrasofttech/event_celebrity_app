class VideoModel {
  String? videoId;
  String? title;
  String? totalLikes;
  String? description;
  String? id;
  bool? isLike;

  VideoModel(
      {this.videoId,
      this.title,
      this.totalLikes,
      this.description,
      this.id,
      this.isLike});

  VideoModel.fromJson(Map<String, dynamic> json) {
    videoId = json['videoId'];
    title = json['title'];
    totalLikes = json['total_likes'];
    description = json['description'];
    id = json['id'];
    isLike = json['is_like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['videoId'] = this.videoId;
    data['title'] = this.title;
    data['total_likes'] = this.totalLikes;
    data['description'] = this.description;
    data['id'] = this.id;
    data['is_like'] = this.isLike;
    return data;
  }
}
