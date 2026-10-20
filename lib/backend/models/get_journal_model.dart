class GetJournalModel {
  GetJournalModel({
    this.responseCode,
    this.responseMessage,
    this.data,
    this.totalRecord,
  });

  final int? responseCode;
  final String? responseMessage;
  final List<JournalBody>? data;
  final int? totalRecord;

  factory GetJournalModel.fromJson(Map<String, dynamic> json){
    return GetJournalModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? [] : List<JournalBody>.from(json["data"]!.map((x) => JournalBody.fromJson(x))),
      totalRecord: json["totalRecord"],
    );
  }

}

class JournalBody {
  JournalBody({
    required this.id,
    required this.userId,
    required this.content,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? userId;
  final String? content;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  bool isExpanded = false;

  factory JournalBody.fromJson(Map<String, dynamic> json){
    return JournalBody(
      id: json["_id"],
      userId: json["userId"],
      content: json["content"],
      isDeleted: json["isDeleted"],
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      v: json["__v"],
    );
  }

}
