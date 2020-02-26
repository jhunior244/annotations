import 'package:hellor_world/helper/DataBaseHelper.dart';
import 'package:hellor_world/model/Anotacao.dart';
import 'package:hellor_world/model/Evento.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;


class EventoHelper {
  static final String nomeTabela = "evento";
  static final EventoHelper _eventoHelper = EventoHelper._internal();
  Database _database;

  factory EventoHelper(){
    return _eventoHelper;
  }

  EventoHelper._internal(){}

  get database async {
      if(_database != null){
        return _database;
      } else {
        _database = await DataBaseHelper().database;
        return _database;
      }
  }

  Future<int> salvarEvento(Evento evento) async{
    var dataBase = await database;

    int id = await dataBase.insert(nomeTabela, evento.toMap());
    return id;
  }

  listarEventos() async {
    var dataBase = await database;
    String sql = "SELECT * FROM $nomeTabela ORDER BY data ASC";
    List listaEventos = await dataBase.rawQuery(sql);
    return listaEventos;
  }

  obtem(int id) async {
    Database dataBase = await database;
    List lista = await dataBase.query(
        nomeTabela,
        where: "id = $id"
    );
    return lista;
  }

  Future<int> removerEvento( int id ) async {

    var bancoDados = await database;
    return await bancoDados.delete(
        nomeTabela,
        where: "id = ?",
        whereArgs: [id]
    );
  }

}