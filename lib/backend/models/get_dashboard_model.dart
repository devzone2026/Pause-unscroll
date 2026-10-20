class GetDashboardModel {
  GetDashboardModel({
    this.responseCode,
    this.responseMessage,
    this.data,
  });

  final int? responseCode;
  final String? responseMessage;
  final Data? data;

  factory GetDashboardModel.fromJson(Map<String, dynamic> json){
    return GetDashboardModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.wellnessScore,
    required this.streaks,
    required this.todaySnapshot,
    required this.dailyQuote,
  });

  final int? wellnessScore;
  final Streaks? streaks;
  final TodaySnapshot? todaySnapshot;
  final DailyQuote? dailyQuote;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      wellnessScore: json["wellnessScore"],
      streaks: json["streaks"] == null ? null : Streaks.fromJson(json["streaks"]),
      todaySnapshot: json["todaySnapshot"] == null ? null : TodaySnapshot.fromJson(json["todaySnapshot"]),
      dailyQuote: json["dailyQuote"] == null ? null : DailyQuote.fromJson(json["dailyQuote"]),
    );
  }

}

class DailyQuote {
  DailyQuote({
    required this.text,
    required this.category,
  });

  final String? text;
  final String? category;

  factory DailyQuote.fromJson(Map<String, dynamic> json){
    return DailyQuote(
      text: json["text"],
      category: json["category"],
    );
  }

}

class Streaks {
  Streaks({
    required this.hydration,
    required this.journaling,
  });

  final int? hydration;
  final int? journaling;

  factory Streaks.fromJson(Map<String, dynamic> json){
    return Streaks(
      hydration: json["hydration"],
      journaling: json["journaling"],
    );
  }

}

class TodaySnapshot {
  TodaySnapshot({
    required this.hydration,
    required this.meditationMinutes,
    required this.mood,
    required this.workoutDuration,
  });

  final int? hydration;
  final int? meditationMinutes;
  final int? mood;
  final String? workoutDuration;

  factory TodaySnapshot.fromJson(Map<String, dynamic> json){
    return TodaySnapshot(
      hydration: json["hydration"],
      meditationMinutes: json["meditationMinutes"],
      mood: json["mood"],
      workoutDuration: json["workoutDuration"],
    );
  }

}
