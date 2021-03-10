import 'dart:io';

class Anuncio {
  String anuncioTit;
  int id;
  String anuncioDes;
  double anuncioPre;
  bool done = false;
  File image;


  Anuncio({this.anuncioTit, this.anuncioDes, this.anuncioPre,  this.image});

  Anuncio.fromMap(Map map){
    this.id = map['id'];
    this.anuncioTit = map['text'];
    this.anuncioDes = map['text'];
    this.anuncioPre = double.parse(map['text']);
    this.done = map['done'] == 1 ? true :false;
  }

  Map toMap(){
    Map<String, dynamic> map = {
      'id': this.id,
      'titulo': this.anuncioTit,
      'descricao': this.anuncioDes,
      'preco': this.anuncioPre,
      'done': this.done ? 1 : 0
    };
    return map;
  }
  @override
  String  toString(){
    return "Anuncio(id: $id, text: $anuncioTit, textD: $anuncioDes, textPre: $anuncioPre,done: $done)";
  }



}
