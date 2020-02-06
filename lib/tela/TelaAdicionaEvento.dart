import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hellor_world/helper/EventoHelper.dart';
import 'package:hellor_world/model/Evento.dart';
import 'package:hellor_world/tela/TelaInicio.dart';
import 'package:intl/intl.dart';

class TelaAdicionaEvento extends StatefulWidget {
  @override
  _TelaAdicionaEventoState createState() => _TelaAdicionaEventoState();
}

class _TelaAdicionaEventoState extends State<TelaAdicionaEvento> {

  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        locale: Locale("pt"),
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _calculaHabilitaSalvar();
      });
  }

  //antes alteracoes

  var _eventoHelper = EventoHelper();
  var telaInicio = TelaInicio();

  TextEditingController _controllerTitulo = TextEditingController();
  TextEditingController _controllerData = TextEditingController();
  final formater = new DateFormat.yMd();

  bool _habilitaBotaoSalvar;
  String titulo;

  @override
  void initState() {
    _habilitaBotaoSalvar = false;
  }

  void _calculaHabilitaSalvar(){
    try{
      titulo = _controllerTitulo.text;
      if(selectedDate != null && titulo != null && titulo != "" &&
          selectedDate.year > 2000 && selectedDate.year < 2200){
        _habilitaBotaoSalvar = true;
      } else {
        _habilitaBotaoSalvar = false;
      }
    }catch (Exc) {
      _habilitaBotaoSalvar = false;
    }
  }

  void _salvarEvento(BuildContext context) async{
      Evento evento = Evento(titulo, selectedDate.toString());
      int resultado = await _eventoHelper.salvarEvento(evento);
      _controllerTitulo.clear();
      _controllerData.clear();
      FocusScope.of(context).requestFocus(FocusNode());
     show(context);
  }

  void show(BuildContext context){
    Flushbar(
        margin: EdgeInsets.only(bottom: 70, left: 15, right: 15),
        message: "Evento adicionado!",
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        dismissDirection: FlushbarDismissDirection.HORIZONTAL
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Título evento",
                    labelStyle: TextStyle(fontSize: 15, color: Colors.indigo)),
                style: TextStyle(fontSize: 23),
                controller: _controllerTitulo,
                onChanged: (String valor){
                  setState(() {
                    _calculaHabilitaSalvar();
                  });
                },
              )
          ),
          Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      _selectDate(context);
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment:  MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            Evento.toDateBR(selectedDate.toString()),
                            style: TextStyle(
                              fontSize: 23
                            ),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: Colors.indigo,
                            size: 35,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
          ),
          Padding(
            padding: EdgeInsets.all(45),
            child: RaisedButton(
              onPressed: _habilitaBotaoSalvar ? () => _salvarEvento(context) : null,
              textColor: Colors.white,
              color: Colors.green,
              child: Container(
                child: Text(
                  "Salvar",
                  style: TextStyle(
                      fontSize: 25
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
