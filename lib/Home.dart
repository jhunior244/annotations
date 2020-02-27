import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hellor_world/componente/NavigationBarItens.dart';
import 'package:hellor_world/helper/AnotacaoHelper.dart';
import 'package:hellor_world/tela/TelaAdicionaEvento.dart';
import 'package:hellor_world/tela/TelaInicio.dart';
import 'package:hellor_world/tela/TelaListaAnotacao.dart';

import 'model/Anotacao.dart';

class Home extends StatefulWidget {
  Home({ Key key }) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  final notifications = FlutterLocalNotificationsPlugin();
  final anotacaoHelper = AnotacaoHelper();
  List<BottomNavigationBarItem> itemsNavigationBar = NavigationBarItens().itensNavivation;

  int _indiceAtual = 0;

  @override
  initState() {
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
    setState(() {
     atualizaItemNavigationBar();
    });
    _schedule();
  }

  void atualizaItemNavigationBar() async {

    int total = await anotacaoHelper.totalAnotacoesARevisar();
      setState(() {
        itemsNavigationBar =
            NavigationBarItens().atualizaAnotacoesARevisar(total);
      });
  }

  Future _schedule() async {
    int total = await anotacaoHelper.totalAnotacoesARevisar();
    if(total > 0){
      var horaNotificacao = Time(23, 40, 0);
      var androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your other channel id',
          'your other channel name', 'your other channel description');
      var iOSPlatformChannelSpecifics =
      IOSNotificationDetails();
      NotificationDetails platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await notifications.showDailyAtTime(
          0,
          'Anotações',
          'Você tem ' + total.toString() +  ' anotações para revisar.',
          horaNotificacao,
          platformChannelSpecifics);
    }
  }

  Future onSelectNotification(String payload) {
    setState(() {
      _indiceAtual = 2;
    });
    _schedule();
  }

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
        items: itemsNavigationBar,
      ),
    );
  }
}
