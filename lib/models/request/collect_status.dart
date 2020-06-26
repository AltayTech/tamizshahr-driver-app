class CollectStatus {
  final String estimated;
  final String exact;

  CollectStatus({this.estimated, this.exact});

  factory CollectStatus.fromJson(Map<String, dynamic> parsedJson) {

      return CollectStatus(
        estimated: parsedJson['estimated'],
        exact: parsedJson['exact'],
      );
  }
  Map<String, dynamic> toJson() {


    return {
      'estimated' : estimated,
      'exact' : exact,
    };
  }
}
