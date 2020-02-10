import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = new IOSInitializationSettings();

    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

  void _calculaHabilitaSalvar(){
    if(_controllerAnotacao.text != null && _controllerAnotacao.text != ""){
      setState(() {
        _habilitaBotaoSalvar = true;
      });
    } else {
      setState(() {
        _habilitaBotaoSalvar = false;
      });
    }
  }

  void setIdEvento(int idEvento){
    _idEvento = idEvento;
  }

  void _salvarAnotacao(BuildContext context, Evento evento) async{

    DateTime dataNow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toLocal();
    Anotacao anotacao = Anotacao(_controllerAnotacao.text, dataNow.toString(), 1, 1, evento.id);
    int resultado = await _anotacaoHelper.salvarAnotacao(anotacao);
    Navigator.pop(context);
    show(context, "Anotação criada!");

  }

  _listaEventos() async{
    List listaRetornada = await _eventoHelper.listarEventos();

    List<Evento> eventosConvertidos = List<Evento>();
    for (var item in listaRetornada){
      Evento evento = Evento.fromMap(item);
      eventosConvertidos.add(evento);
    }

    setState(() {
      _listaEvento = eventosConvertidos;
    });
    eventosConvertidos = null;
  }

  void show(BuildContext context, String mensagem){
    Flushbar(
      margin: EdgeInsets.only(bottom: 70, left: 15, right: 15),
      message: mensagem,
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
        dismissDirection: FlushbarDismissDirection.HORIZONTAL
    )..show(context);
    _controllerAnotacao.clear();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
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
                                              onPressed: _habilitaBotaoSalvar ? () => _salvarAnotacao(context, evento) : null,
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
                                            show(context, "Evento excluido!!");
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
          )
        ],
      );
  }
}
