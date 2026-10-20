class GetNourishmentSuggestionsModel {
  GetNourishmentSuggestionsModel({
    this.responseCode,
    this.responseMessage,
    this.data,
  });

  final int? responseCode;
  final String? responseMessage;
  final List<SuggestionBody>? data;

  factory GetNourishmentSuggestionsModel.fromJson(Map<String, dynamic> json){
    return GetNourishmentSuggestionsModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? [] : List<SuggestionBody>.from(json["data"]!.map((x) => SuggestionBody.fromJson(x))),
    );
  }

}

class SuggestionBody {
  SuggestionBody({
    required this.title,
    required this.description,
    required this.benefits,
  });

  final String? title;
  final String? description;
  final String? benefits;

  factory SuggestionBody.fromJson(Map<String, dynamic> json){
    return SuggestionBody(
      title: json["title"],
      description: json["description"],
      benefits: json["benefits"],
    );
  }

}
