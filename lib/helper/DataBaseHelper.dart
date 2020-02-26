import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;


class DataBaseHelper {
  static final DataBaseHelper _dataBaseHelper = DataBaseHelper._internal();
  Database _database;

  factory DataBaseHelper(){
    return _dataBaseHelper;
  }

  DataBaseHelper._internal(){}

  get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await inicialiarDataBase();
      return _database;
    }
  }

  inicialiarDataBase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final localDataBase = join(documentsDirectory.path, "annotations.db");

    var database = await openDatabase(localDataBase, version: 1, onCreate: _onCreate);

    return database;
  }

  _onCreate(Database database, int version) async{
    String sql = "CREATE TABLE IF NOT EXISTS evento (id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "titulo VARCHAR, data DATETIME);";
    await database.execute(sql);
        sql = "CREATE TABLE IF NOT EXISTS anotacao (id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "anotacao TEXT, dataProximaRevisao DATETIME, coeficienteProximaRevisao INTEGER, "
        "coeficienteRevisaoAnterior INTEGER, "
        "idEvento INTEGER, "
        "FOREIGN KEY(idEvento) REFERENCES evento(id));";
    await database.execute(sql);
  }

}
//  Future showOngoingNotification(
//      FlutterLocalNotificationsPlugin notifications, {
//        @required String title,
//        @required String body,
//        int id = 0,
//      }) =>
//      _showNotification(notifications,
//          title: title, body: body, id: id, type: _ongoing);
//
//  Future _showNotification(
//      FlutterLocalNotificationsPlugin notifications, {
//        @required String title,
//        @required String body,
//        @required NotificationDetails type,
//        int id = 0,
//      }) =>
//      notifications.show(id, title, body, type);
//
//  NotificationDetails get _ongoing {
//    final androidChannelSpecifics = AndroidNotificationDetails(
//      'your channel id',
//      'your channel name',
//      'your channel description',
//      importance: Importance.Max,
//      priority: Priority.High,
//      ongoing: false,
//      autoCancel: true,
//    );
//    final iOSChannelSpecifics = IOSNotificationDetails();
//    return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
//  }
