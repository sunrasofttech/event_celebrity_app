class UserAppContentModel {
  bool? status;
  UserAppContentData? data;

  UserAppContentModel({this.status, this.data});

  UserAppContentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? UserAppContentData.fromJson(json['data']) : null;
  }
}

class UserAppContentData {
  List<Faq>? faq;
  String? adminId;
  String? termsAndCond;
  String? privacyPolicy;
  String? aboutUs;

  UserAppContentData({this.faq, this.termsAndCond, this.adminId, this.privacyPolicy, this.aboutUs});

  UserAppContentData.fromJson(Map<String, dynamic> json) {
    faq = json['FAQ'] != null ? List<Faq>.from(json['FAQ'].map((x) => Faq.fromJson(x))) : [];

    adminId = json['adminId'];
    termsAndCond = json['TermsAndCond'];
    privacyPolicy = json['PrivacyPolicy'];
    aboutUs = json['AboutUs'];
  }
}

class Faq {
  String? id;
  String? question;
  String? answer;

  Faq({this.id, this.question, this.answer});

  Faq.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
  }
}
