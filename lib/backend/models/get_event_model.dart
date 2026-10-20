class GetEventModel {
  GetEventModel({
    this.responseCode,
    this.responseMessage,
    this.data,
  });

  final int? responseCode;
  final String? responseMessage;
  final Data? data;

  factory GetEventModel.fromJson(Map<String, dynamic> json){
    return GetEventModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.summary,
    required this.mindActivities,
    required this.meals,
    required this.workouts,
    required this.journal,
  });

  final Summary? summary;
  final List<Journal> mindActivities;
  final List<Journal> meals;
  final List<Journal> workouts;
  final List<Journal> journal;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
      mindActivities: json["mindActivities"] == null ? [] : List<Journal>.from(json["mindActivities"]!.map((x) => Journal.fromJson(x))),
      meals: json["meals"] == null ? [] : List<Journal>.from(json["meals"]!.map((x) => Journal.fromJson(x))),
      workouts: json["workouts"] == null ? [] : List<Journal>.from(json["workouts"]!.map((x) => Journal.fromJson(x))),
      journal: json["journal"] == null ? [] : List<Journal>.from(json["journal"]!.map((x) => Journal.fromJson(x))),
    );
  }

}

class Journal {
  Journal({
    required this.label,
    required this.value,
  });

  final String? label;
  final String? value;

  factory Journal.fromJson(Map<String, dynamic> json){
    return Journal(
      label: json["label"],
      value: json["value"],
    );
  }

}

class Summary {
  Summary({
    required this.meditationMinutes,
    required this.breathingSessions,
    required this.mealsCount,
    required this.workoutCount,
    required this.hydration,
    required this.mood,
    required this.workoutMinutes,
  });

  final int? meditationMinutes;
  final int? breathingSessions;
  final int? mealsCount;
  final int? workoutCount;
  final int? hydration;
  final int? mood;
  final int? workoutMinutes;

  factory Summary.fromJson(Map<String, dynamic> json){
    return Summary(
      meditationMinutes: json["meditationMinutes"],
      breathingSessions: json["breathingSessions"],
      mealsCount: json["mealsCount"],
      workoutCount: json["workoutCount"],
      hydration: json["hydration"],
      mood: json["mood"],
      workoutMinutes: json["workoutMinutes"],
    );
  }

}
