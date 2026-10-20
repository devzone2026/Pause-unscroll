class GetTodayEventModel {
  GetTodayEventModel({
    this.responseCode,
    this.responseMessage,
    this.data,
  });

  final int? responseCode;
  final String? responseMessage;
  final TodayEventBody? data;

  factory GetTodayEventModel.fromJson(Map<String, dynamic> json){
    return GetTodayEventModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? null : TodayEventBody.fromJson(json["data"]),
    );
  }

}

class TodayEventBody {
  TodayEventBody({
    required this.mealsWorkouts,
  });

  final List<MealsWorkout> mealsWorkouts;

  factory TodayEventBody.fromJson(Map<String, dynamic> json){
    return TodayEventBody(
      mealsWorkouts: json["mealsWorkouts"] == null ? [] : List<MealsWorkout>.from(json["mealsWorkouts"]!.map((x) => MealsWorkout.fromJson(x))),
    );
  }

}

class MealsWorkout {
  MealsWorkout({
    required this.id,
    required this.userId,
    required this.date,
    required this.type,
    required this.mealType,
    required this.title,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? userId;
  final DateTime? date;
  final String? type;
  final String? mealType;
  final String? title;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory MealsWorkout.fromJson(Map<String, dynamic> json){
    return MealsWorkout(
      id: json["_id"],
      userId: json["userId"],
      date: DateTime.tryParse(json["date"] ?? ""),
      type: json["type"],
      mealType: json["mealType"],
      title: json["title"],
      isDeleted: json["isDeleted"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

}
