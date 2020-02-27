import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hellor_world/Home.dart';
import 'package:hellor_world/componente/FlushBarMensagemSucesso.dart';
import 'package:hellor_world/componente/SliceTexto.dart';
import 'package:hellor_world/helper/AnotacaoHelper.dart';
import 'package:hellor_world/main.dart';
import 'package:hellor_world/model/Anotacao.dart';

class TelaListaAnotacao extends StatefulWidget {
  final Home home = Home();

  @override
  _TelaListaAnotacaoState createState() => _TelaListaAnotacaoState();
}

class _TelaListaAnotacaoState extends State<TelaListaAnotacao> {

  var _anotacaoHelper = AnotacaoHelper();
  List<Anotacao> listaAnotacao = List<Anotacao>();
  bool _revisto = false;

  @override
  void initState() {
    _listaAnotacoes();
  }

  _listaAnotacoes() async{
    List<Anotacao> listaRetornada = await _anotacaoHelper.listarAnotacao();

    setState(() {
      listaAnotacao = listaRetornada;
    });
    listaRetornada = null;
    key.currentState.atualizaItemNavigationBar();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: listaAnotacao.length,
              itemBuilder: (context, index){
                final anotacao = listaAnotacao[index];
                return Card(
                  color: Colors.white70,
                  child: ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                           return StatefulBuilder(
                             builder: (context, setState){
                               return AlertDialog(
                                 title: Text(anotacao.tituloEvento),
                                 content: SingleChildScrollView(
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.stretch,
                                     children: <Widget>[
                                       Text(anotacao.anotacao)
                                     ],
                                   ),
                                 ),
                                 actions: <Widget>[
                                   Text("Marcar como revisto"),
                                   Checkbox(
                                     onChanged: (bool valor){
                                       setState(() {
                                         _revisto = valor;
                                       });
                                     },
                                     value: _revisto,
                                   ),
                                   ButtonTheme(
                                       minWidth: 20.0,
                                       height: 25.0,
                                       child: RaisedButton(
                                         child: Text("OK"),
                                         color: Colors.blue,
                                         onPressed: (){
                                           if(_revisto){
                                            Anotacao.vazio().calculaProximaRevisao(anotacao);
                                             _revisto = false;
                                            _listaAnotacoes();
                                           }
                                            Navigator.pop(context);
                                         },
                                       )
                                   )
                                 ],
                               );
                             },
                           );
                          }
                      );
                    },
                    title: Text(anotacao.tituloEvento),
                    subtitle: Text(SliceTexto().sliceAnotacao(anotacao.anotacao, 30)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            showDialog(
                                context: context,
                              builder: (context) {
                                  return AlertDialog(
                                    title: Text("Deseja apagar esta anotação?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: (){
                                          _anotacaoHelper.removerAnotacao(anotacao.id);
                                          _listaAnotacoes();
                                          Navigator.pop(context);
                                          FlushBarMensagemSucesso().show(context, "Anotação excluída!");
                                        },
                                        child: Text("Sim"),
                                      ),
                                      FlatButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Não"),
                                      )
                                    ],
                                  );
                              },
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
          ),
        )
      ],
    );
  }
}

