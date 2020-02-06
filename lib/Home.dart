import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hellor_world/model/Evento.dart';
import 'package:hellor_world/tela/TelaAdicionaEvento.dart';
import 'package:hellor_world/tela/TelaInicio.dart';
import 'package:hellor_world/tela/TelaListaAnotacao.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _indiceAtual = 0;
  List<Evento> lista = [];


  @override
  Widget build(BuildContext context) {

    List<Widget> telas = [
      TelaInicio(),
      TelaAdicionaEvento(),
      TelaListaAnotacao(),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Anotações Gerais",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: telas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.indigo,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.white,
        currentIndex: _indiceAtual,
        onTap: (indice){
          setState(() {
            _indiceAtual = indice;
          });
        },
        items: [
          BottomNavigationBarItem(
              title: Text(
                "Inicio",
                style: TextStyle(fontSize: 20),
              ),
              icon: Icon(Icons.home)),
          BottomNavigationBarItem(
              title: Text(
                "Novo",
                style: TextStyle(
                    fontSize: 20),
              ),
              icon: Icon(Icons.add_circle)),
          BottomNavigationBarItem(
              title: Text(
                "Revisar",
                style: TextStyle(
                    fontSize: 20),
              ),
              icon: Icon(Icons.notification_important)),
        ],
      ),
    );
  }
}
