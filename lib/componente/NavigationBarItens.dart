import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bottom_navigation_badge/bottom_navigation_badge.dart';

class NavigationBarItens {

  BottomNavigationBadge badger = new BottomNavigationBadge(
      backgroundColor: Colors.red,
      badgeShape: BottomNavigationBadgeShape.circle,
      textColor: Colors.white,
      position: BottomNavigationBadgePosition.topRight,
      textSize: 8);

  List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
        title: Text(
          "Inicio",
          style: TextStyle(fontSize: 20),
        ),
        icon: Icon(Icons.home)
    ),
    BottomNavigationBarItem(title: Text(
      "Novo",
      style: TextStyle(
          fontSize: 20),
    ),
        icon: Icon(Icons.add_circle)),
    BottomNavigationBarItem(title: Text(
      "Revisar",
      style: TextStyle(
          fontSize: 20),
    ),
        icon: Icon(Icons.notifications))
  ];

  get itensNavivation {
    return _items;
  }

  List<BottomNavigationBarItem> atualizaAnotacoesARevisar(int totalPendentes){
    if(totalPendentes == 0){
        _items = badger.removeBadge(_items, 2);
    } else {
      _items = badger.setBadge(_items, totalPendentes.toString(), 2);
    }
    return _items;
  }

}