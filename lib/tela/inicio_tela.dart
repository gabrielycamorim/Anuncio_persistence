import 'dart:ui';
import 'package:app_anuncio/anuncio/anuncio.dart';
import 'package:app_anuncio/helpers/anuncio_helper.dart';

import 'package:app_anuncio/tela/cadastroAnuncio_tela.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class TelaInicio extends StatefulWidget {
  TelaInicio({Key key}) : super(key: key);

  @override
  _TelaInicioState createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  List<Anuncio> _lista = List();

  //FilePersistence _filePersistence = FilePersistence();
  AnuncioHelper _anuncioHelper = AnuncioHelper();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _anuncioHelper.getAll().then((data) {
      setState(() {
        if (data != null) _lista = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Venda de livros"),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: _lista.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(_lista[index].toString()),
            direction: DismissDirection.horizontal,
            background: Container(
              color: Colors.greenAccent,
              child: Align(
                alignment: Alignment(-0.9, 0.0),
                child: Icon(
                  CommunityMaterialIcons.file_edit,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              child: Align(
                alignment: Alignment(0.9, 0.0),
                child: Icon(
                  CommunityMaterialIcons.trash_can,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),

            onDismissed: (direction) =>
            {
              if(direction == DismissDirection.endToStart){
                _anuncioHelper.deletaAnuncio(_lista[index]).then((data) {
                  setState(() {
                    _lista.removeAt(index);

                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("Anuncio excluido!", style: TextStyle(
                            fontSize: 18, color: Colors.redAccent),)));
                  });
                }
                )
              }
            },


             confirmDismiss: (direction) async {
               if (direction == DismissDirection.startToEnd) {
                 Anuncio editAnuncio = await Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (context) =>
                             CadastroTela(anuncio: _lista[index])));
                 if (editAnuncio != null) {
                   await _anuncioHelper.editAnuncio(editAnuncio);
                   setState(() {
                     _lista.removeAt(index);
                     _lista.insert(index, editAnuncio);
                     //_filePersistence.saveData(_lista);
                     _scaffoldKey.currentState.showSnackBar(
                         SnackBar(content: Text("Anuncio editado!",
                             style: TextStyle(
                                 fontSize: 18, color: Colors.greenAccent))));
                   });
                 }
                 return false;
               }
               return true;
             },



            child: ListTile(
              leading: _lista[index].image != null ? (
                  ClipOval(child: Image.file(
                    _lista[index].image, width: 90, height: 60,)
                  )) : Container(
                width: 90,
                height: 60,
              ),

              title: Text(
                _lista[index].anuncioTit,
                style: TextStyle(
                    fontSize: 30,
                    decoration: _lista[index].done
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),

              subtitle: Text(
                _lista[index].anuncioDes.toString() + " Preço: R\$" +
                    _lista[index].anuncioPre.toString(),
                style: TextStyle(fontSize: 18),
              ),

              trailing: Icon( //CommunityMaterialIcons.cart, size: 50,
                _lista[index].done ? Icons.done : Icons.shopping_cart, size: 50,
                color: _lista[index].done ? Colors.green : Colors.grey,),
              onTap: () async {
                Anuncio item = _lista[index];
                item.done = !item.done;
                await _anuncioHelper.editAnuncio(item);
                setState(() {
                  _lista[index] = item;
                });
              },
              onLongPress: () async {
                showBottomSheet(context: context, builder: (context) {
                  return Container(child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(leading: Icon(IcoFontIcons.envelope),
                        title: Text("Compartilhar por e-mail"),
                        onTap: () async {
                          Navigator.pop(context);
                          final Uri params = Uri(
                              scheme: 'mailto',
                              path: "gabrielyamorim1@gmail.com",
                              queryParameters: {
                                'subject': 'Teste e-mail',
                                "body": _lista[index].done
                                    ? "A tarefa ${ _lista[index]
                                    .anuncioTit} foi concluida"
                                    :
                                "A tarefa ${_lista[index]
                                    .anuncioTit} nao foi concluida"
                              }
                          );
                          final url = params.toString();
                          print(url);
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            print("Ocorreu um erro, tente novamente");
                          }
                        },
                      ),
                      ListTile(leading: Icon(IcoFontIcons.uiMessaging),
                        title: Text("Compartilhar por SMS"),
                        onTap: () async {
                          Navigator.pop(context);

                          final Uri params = Uri(
                              scheme: 'sms',
                              path: "+55 64 99204-2928",
                              queryParameters: {

                                'body': _lista[index].done
                                    ? "A tarefa ${ _lista[index]
                                    .anuncioTit} foi concluida"
                                    :
                                "A tarefa ${_lista[index]
                                    .anuncioTit} nao foi concluida"
                              });
                          final url = params.toString();
                          print(url);
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            print("Ocorreu um erro, tente novamente");
                          }
                        },
                      ),
                      ListTile(leading: Icon(IcoFontIcons.whatsapp),
                        title: Text("Compartilhar por Whatsapp"),
                        onTap: () async {
                          Navigator.pop(context);

                          var whatsUrl = "whatsapp://send?phone=+556492042928&text=${_lista[index]
                              .done ? "a tarefa ${ _lista[index].anuncioTit} "
                              "foi concluida" : "a tarefa ${ _lista[index]
                              .anuncioTit} nao foi concluida "}";

                          if (await canLaunch(whatsUrl)) {
                            await launch(whatsUrl);
                          } else {
                            print("Ocorreu um erro, tente novamente");
                          }
                        },
                      ),
                      ListTile(leading: Icon(IcoFontIcons.error),
                        title: Text("Voltar"),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )

                    ],),
                  );
                });
              },
            ),

          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey,
          );
        },
      ),




      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          Anuncio anuncioPro = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => CadastroTela()));

           if (anuncioPro != null) {
            Anuncio salvarAnuncio = await _anuncioHelper.saveAnuncio(anuncioPro);
            setState(() {
              _lista.add(salvarAnuncio);
              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Anuncio salvo!", style: TextStyle(fontSize: 18, color: Colors.blueAccent))));
            });
          }
       },
      ),

  );
  }
}

