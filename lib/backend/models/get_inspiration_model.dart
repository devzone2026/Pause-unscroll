class GetInspirationModel {
  GetInspirationModel({
    this.responseCode,
    this.responseMessage,
    this.data,
  });

  final int? responseCode;
  final String? responseMessage;
  final List<InspirationBody>? data;

  factory GetInspirationModel.fromJson(Map<String, dynamic> json){
    return GetInspirationModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? [] : List<InspirationBody>.from(json["data"]!.map((x) => InspirationBody.fromJson(x))),
    );
  }

}

class InspirationBody {
  InspirationBody({
    required this.category,
    required this.text,
    required this.id,
  });

  final String? category;
  final String? text;
  final String? id;

  factory InspirationBody.fromJson(Map<String, dynamic> json){
    return InspirationBody(
      category: json["category"],
      text: json["text"],
      id: json["_id"],
    );
  }

}
