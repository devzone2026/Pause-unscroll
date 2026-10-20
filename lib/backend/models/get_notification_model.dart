class GetNotificationModel {
  GetNotificationModel({
    this.responseCode,
    this.responseMessage,
    this.data,
    this.totalRecord,
  });

  final int? responseCode;
  final String? responseMessage;
  final List<NotificationBody>? data;
  final int? totalRecord;

  factory GetNotificationModel.fromJson(Map<String, dynamic> json){
    return GetNotificationModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? [] : List<NotificationBody>.from(json["data"]!.map((x) => NotificationBody.fromJson(x))),
      totalRecord: json["totalRecord"],
    );
  }

}

class NotificationBody {
  NotificationBody({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? userId;
  final String? type;
  final String? title;
  final String? body;
  final Data? data;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  factory NotificationBody.fromJson(Map<String, dynamic> json){
    return NotificationBody(
      id: json["_id"],
      userId: json["userId"],
      type: json["type"],
      title: json["title"],
      body: json["body"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
      isDeleted: json["isDeleted"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      v: json["__v"],
    );
  }

}

class Data {
  Data({
    required this.todoId,
    required this.todoTitle,
  });

  final String? todoId;
  final String? todoTitle;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      todoId: json["todoId"],
      todoTitle: json["todoTitle"],
    );
  }

}
