class Pasmand {
  final int id;
  final String post_title;

  Pasmand({this.id, this.post_title});

  factory Pasmand.fromJson(Map<String, dynamic> parsedJson) {

      return Pasmand(
        id: parsedJson['ID']!=null? parsedJson['ID']:0,
        post_title: parsedJson['post_title']!=null? parsedJson['post_title']:'',
      );
  }
  Map<String, dynamic> toJson() {


    return {
      'ID' : id,
      'post_title' : post_title,
    };
  }
}
