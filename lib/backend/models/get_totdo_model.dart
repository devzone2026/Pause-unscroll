class GetTodoModel {
  GetTodoModel({
    this.responseCode,
    this.responseMessage,
    this.data,
    this.totalRecord,
  });

  final int? responseCode;
  final String? responseMessage;
  final List<TodoBody>? data;
  final int? totalRecord;

  factory GetTodoModel.fromJson(Map<String, dynamic> json){
    return GetTodoModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? [] : List<TodoBody>.from(json["data"]!.map((x) => TodoBody.fromJson(x))),
      totalRecord: json["totalRecord"],
    );
  }

}

class TodoBody {
  TodoBody({
    required this.id,
    required this.userId,
    required this.title,
    required this.frequency,
    required this.daysOfWeek,
    required this.isCompleted,
    required this.completedAt,
    required this.notification,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? userId;
  final String? title;
  final String? frequency;
  final List<int> daysOfWeek;
  final bool? isCompleted;
  final dynamic completedAt;
  final bool? notification;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory TodoBody.fromJson(Map<String, dynamic> json){
    return TodoBody(
      id: json["_id"],
      userId: json["userId"],
      title: json["title"],
      frequency: json["frequency"],
      daysOfWeek: json["daysOfWeek"] == null ? [] : List<int>.from(json["daysOfWeek"]!.map((x) => x)),
      isCompleted: json["isCompleted"],
      completedAt: json["completedAt"],
      notification: json["notification"],
      isDeleted: json["isDeleted"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

}
