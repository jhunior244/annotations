import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hellor_world/helper/AnotacaoHelper.dart';
import 'package:hellor_world/helper/EventoHelper.dart';
import 'package:hellor_world/model/Anotacao.dart';
import 'package:hellor_world/model/Evento.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class TelaListaAnotacao extends StatefulWidget {
  @override
  _TelaListaAnotacaoState createState() => _TelaListaAnotacaoState();
}

class _TelaListaAnotacaoState extends State<TelaListaAnotacao> {

  var _anotacaoHelper = AnotacaoHelper();
  var _eventoHelper = EventoHelper();
  List<Anotacao> _listaAnotacao = List<Anotacao>();
  bool _revisto = false;

  @override
  void initState() {
    _listaAnotacoes();
  }

  _listaAnotacoes() async{
    List listaRetornada = await _anotacaoHelper.listarAnotacao();

    List<Anotacao> anotacoesConvertidos = List<Anotacao>();
    for (var item in listaRetornada){
      Anotacao anotacao = Anotacao.fromMap(item);
      List lista = await _eventoHelper.obtem(anotacao.idEvento);
      if(lista.isNotEmpty){
        Evento evento = Evento.fromMap(lista[0]);
        anotacao.tituloEvento = evento.titulo;
        anotacoesConvertidos.add(anotacao);
      }
    }

    setState(() {
      _listaAnotacao = anotacoesConvertidos;
    });
    anotacoesConvertidos = null;
  }

  void show(BuildContext context, String mensagem){
    Flushbar(
        margin: EdgeInsets.only(bottom: 70, left: 15, right: 15),
        message: mensagem,
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        dismissDirection: FlushbarDismissDirection.HORIZONTAL
    )..show(context);
  }

  String sliceAnotacao(String anotacao){
    if(anotacao == null){
      return "";
    }
    if(anotacao.contains("\n", 0)){
      anotacao = anotacao.replaceAll(new RegExp(r'\n'), " ");
    }
    if(anotacao.length >= 30){
      return anotacao.substring(0, 27) + "...";
    }

    return anotacao;
  }

  void _calculaProximaRevisao(Anotacao anotacao){

    var formatter = new DateFormat('yyyy-MM-dd');

    DateTime dataNow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toLocal();

    String dataProximaRevisao = "";

    dataProximaRevisao = Jiffy(dataNow).add(days: anotacao.coeficienteProximaRevisao + anotacao.coeficienteRevisaoAnterior).toString();
    anotacao.dataProximaRevisao = formatter.format(DateTime.parse(dataProximaRevisao));
    int auxCoefRevAnterior = anotacao.coeficienteRevisaoAnterior;
    anotacao.coeficienteRevisaoAnterior = anotacao.coeficienteProximaRevisao;
    anotacao.coeficienteProximaRevisao += auxCoefRevAnterior;
    _anotacaoHelper.atualizarAnotacao(anotacao);
    _listaAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: _listaAnotacao.length,
              itemBuilder: (context, index){
                final anotacao = _listaAnotacao[index];
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
                                             _calculaProximaRevisao(anotacao);
                                             _revisto = false;
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
                    subtitle: Text(sliceAnotacao(anotacao.anotacao)),
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
                                          show(context, "Anotação excluída!");
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

