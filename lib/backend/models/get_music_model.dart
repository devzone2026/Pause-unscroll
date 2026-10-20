
class GetMusicModel {
  GetMusicModel({
    this.responseCode,
    this.responseMessage,
    this.data,
  });

  final int? responseCode;
  final String? responseMessage;
  final List<MusicBody>? data;

  factory GetMusicModel.fromJson(Map<String, dynamic> json){
    return GetMusicModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? [] : List<MusicBody>.from(json["data"]!.map((x) => MusicBody.fromJson(x))),
    );
  }

}

class MusicBody {
  MusicBody({
    this.id,
    this.title,
    this.duration,
    this.audioUrl,
  });

  final String? id;
  final String? title;
  final String? duration;
  final String? audioUrl;

  bool demoPlay = false;

  factory MusicBody.fromJson(Map<String, dynamic> json){
    return MusicBody(
      id: json["id"],
      title: json["title"],
      duration: json["duration"],
      audioUrl: json["audioUrl"],
    );
  }

}
