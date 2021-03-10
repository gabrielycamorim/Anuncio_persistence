import 'dart:convert';
import 'dart:io';
import 'package:app_anuncio/anuncio/anuncio.dart';
import 'package:path_provider/path_provider.dart';


class FilePersistence {
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    String _localPath = directory.path;
    return File('$_localPath/anuncioLista.json');
  }

  Future saveData(List<Anuncio> anuncios) async {
    final localFile = await _getLocalFile();
    List anuncioLista = [];

    anuncios.forEach((element) {
      anuncioLista.add(element.toMap());
    });

    String data = json.encode(anuncioLista);
    return localFile.writeAsString(data);
  }
  Future<List<Anuncio>> getData() async{
    try{
      final localFile = await _getLocalFile();
      List anuncioLista = [];
      List<Anuncio> anuncios =[];

      String content = await localFile.readAsString();
      anuncioLista = json.decode(content);

      anuncioLista.forEach((element){
        anuncios.add(Anuncio.fromMap(element));
      });

      return anuncios;

    } catch(e){
      print(e);
      return null;
    }
  }
}