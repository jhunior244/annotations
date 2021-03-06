import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hellor_world/componente/FlushBarMensagemSucesso.dart';
import 'package:hellor_world/helper/AnotacaoHelper.dart';
import 'package:hellor_world/helper/EventoHelper.dart';
import 'package:hellor_world/model/Anotacao.dart';
import 'package:hellor_world/model/Evento.dart';
import 'package:intl/intl.dart';

class TelaInicio extends StatefulWidget {
  @override
  _TelaInicioState createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {

  final notifications = FlutterLocalNotificationsPlugin();
  var _eventoHelper = EventoHelper();
  var _anotacaoHelper = AnotacaoHelper();
  var _habilitaBotaoSalvar = false;
  int _idEvento;
  List<Evento> _listaEvento = List<Evento>();
  TextEditingController _controllerAnotacao = TextEditingController();

  @override
  void initState() {
    _listaEventos();
    _habilitaBotaoSalvar = false;
  }

  void _calculaHabilitaSalvar() {
    if (_controllerAnotacao.text != null && _controllerAnotacao.text != "") {
      setState(() {
        _habilitaBotaoSalvar = true;
      });
    } else {
      setState(() {
        _habilitaBotaoSalvar = false;
      });
    }
  }

  void setIdEvento(int idEvento) {
    _idEvento = idEvento;
  }

  _listaEventos() async {
    List listaRetornada = await _eventoHelper.listarEventos();

    List<Evento> eventosConvertidos = List<Evento>();
    for (var item in listaRetornada) {
      Evento evento = Evento.fromMap(item);
      eventosConvertidos.add(evento);
    }

    setState(() {
      _listaEvento = eventosConvertidos;
    });
    eventosConvertidos = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(//para a lista ocupar todoo espaco disponivel
          child: ListView.builder(
              itemCount: _listaEvento.length,
              itemBuilder: (context, index){
                final evento = _listaEvento[index];
                return Card(
                  color: Colors.white70,
                  child: ListTile(
                    title: Text(evento.titulo),
                    subtitle: Text("${evento.data}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            setIdEvento(evento.id);
                            showDialog(
                                context: context,
                                builder: (context){
                                  return StatefulBuilder(
                                    builder: (context, setState){
                                      return AlertDialog(
                                        content: TextField(
                                          textInputAction: TextInputAction.newline,
                                          autofocus: true,
                                          keyboardType: TextInputType.text,
                                          minLines: 5,
                                          maxLines: 5,
                                          decoration: InputDecoration(
                                              labelText: "Nova Anotação: ${evento.titulo}",
                                              labelStyle: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.indigo
                                              )
                                          ),
                                          style: TextStyle(fontSize: 20),
                                          controller: _controllerAnotacao,
                                          onChanged: (String valor){
                                            setState(() {
                                              _calculaHabilitaSalvar();
                                            });
                                          },
                                        ),
                                        actions: <Widget>[
                                          RaisedButton(
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                                "Voltar"
                                            ),
                                          ),
                                          RaisedButton(
                                            disabledColor: Colors.grey,
                                            color: Colors.indigo,
                                            onPressed: _habilitaBotaoSalvar ? () =>
                                                Anotacao.vazio().salvarAnotacao(context, evento, _controllerAnotacao.text) : null,
                                            child: Text(
                                                "Salvar"
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.add_circle,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setIdEvento(evento.id);
                            showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    title: Text(
                                        "Deseja excluir o Evento: ${evento.titulo}?"
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: (){
                                          _eventoHelper.removerEvento(evento.id);
                                          _listaEventos();
                                          Navigator.pop(context);
                                          FlushBarMensagemSucesso().show(context, "Evento excluido!");
                                        },
                                        child: Text("Sim"),
                                      ),
                                      FlatButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Não"),
                                      )
                                    ],
                                  );
                                }
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
          ),
        ),
      ],
    );
  }
}
