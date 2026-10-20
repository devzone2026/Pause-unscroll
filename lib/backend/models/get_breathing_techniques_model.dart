class GetBreathingTechniquesModel {
  GetBreathingTechniquesModel({
    this.responseCode,
    this.responseMessage,
    this.data,
  });

  final int? responseCode;
  final String? responseMessage;
  final List<BreathTechBody>? data;

  factory GetBreathingTechniquesModel.fromJson(Map<String, dynamic> json){
    return GetBreathingTechniquesModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? [] : List<BreathTechBody>.from(json["data"]!.map((x) => BreathTechBody.fromJson(x))),
    );
  }

}

class BreathTechBody {
  BreathTechBody({
    this.id,
    this.name,
    this.inhale,
    this.hold,
    this.exhale,
    this.description,
  });

  final String? id;
  final String? name;
  final int? inhale;
  final int? hold;
  final int? exhale;
  final String? description;

  factory BreathTechBody.fromJson(Map<String, dynamic> json){
    return BreathTechBody(
      id: json["id"],
      name: json["name"],
      inhale: json["inhale"],
      hold: json["hold"],
      exhale: json["exhale"],
      description: json["description"],
    );
  }

}
