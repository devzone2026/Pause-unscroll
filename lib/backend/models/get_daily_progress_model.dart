class GetDailyProgressModel {
  GetDailyProgressModel({
    this.responseCode,
    this.responseMessage,
    this.data,
  });

  final int? responseCode;
  final String? responseMessage;
  final Data? data;

  factory GetDailyProgressModel.fromJson(Map<String, dynamic> json){
    return GetDailyProgressModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.hydration,
    required this.mood,
    required this.workoutMinutes,
    required this.meditationTime,
  });

  final int? hydration;
  final int? mood;
  final int? workoutMinutes;
  final int? meditationTime;

  int hydrationIntake = 0;
  int localMeditationTime = 0;
  int localMoodTime = 0;
  int localWorkoutTime = 0;


  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      hydration: json["hydration"],
      mood: json["mood"],
      workoutMinutes: json["workoutMinutes"],
      meditationTime: json["meditationTime"],
    );
  }

}
