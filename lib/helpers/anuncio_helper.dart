import 'package:app_anuncio/anuncio/anuncio.dart';
import 'package:app_anuncio/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class AnuncioHelper{
  static final String nomeLabel = "tabela";
  static final String idColumn = "id";
  static final String tituloColumn = "titulo";
  static final String descricaoColumn = "descricao";
  static final String precoColumn = "preco";
  static final String doneColumn = "done";

  static String get createScript{
    return "CREATE TABLE $nomeLabel($idColumn INTEGER PRIMARY KEY AUTOINCREMENT,"+ "$tituloColumn TEXT NOT NULL, $descricaoColumn TEXT NOT NULL, $precoColumn TEXT NOT NULL, $doneColumn INTEGER);";
  }
  Future<Anuncio> saveAnuncio(Anuncio anuncio) async {
        Database db = await DatabaseHelper().db;
        anuncio.id = await db.insert(nomeLabel, anuncio.toMap());
        return anuncio;

  }
  Future<Anuncio> getById(int id) async{
    Database db = await DatabaseHelper().db;
    List<Map> anuncioMaps = await db.query(nomeLabel, columns: [idColumn, tituloColumn, descricaoColumn, precoColumn, doneColumn], where: "$idColumn = ?", whereArgs: [id]);
   return Anuncio.fromMap(anuncioMaps.first);
  }
  Future<List<Anuncio>> getAll() async{
    Database db = await DatabaseHelper().db;
    List<Map> anuncioMaps = await db.query(nomeLabel, columns: [idColumn, tituloColumn, descricaoColumn, precoColumn, doneColumn]);
    List<Anuncio> listAnuncio = List<Anuncio>();
    //List<Anuncio> anuncios = [];

    for(Map map in anuncioMaps){
      listAnuncio.add(Anuncio.fromMap(map));
    }
    return listAnuncio;
  }
  Future<int> editAnuncio(Anuncio anuncio) async{
    Database db = await DatabaseHelper().db;
     return await db.update(nomeLabel, anuncio.toMap(), where: "$idColumn = ?", whereArgs: [anuncio.id]);
  }

  Future deletaAnuncio(Anuncio anuncio) async{
    Database db = await  DatabaseHelper().db;
    db.delete(nomeLabel, where: "$idColumn = ?", whereArgs: [anuncio.id]);
  }
}