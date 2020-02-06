import 'package:hellor_world/model/Evento.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
        _database = await inicializarDataBase();
        return _database;
      }
  }

  _onCreate(Database database, int version) async{
    String sql = "CREATE TABLE $nomeTabela (id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "titulo VARCHAR, data DATETIME)";
    await database.execute(sql);
    sql = "CREATE TABLE anotacao (id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "anotacao TEXT, dataProximaRevisao DATETIME, coeficienteProximaRevisao INTEGER, "
        "coeficienteRevisaoAnterior INTEGER, "
        "idEvento INTEGER); "
        "ALTER TABLE anotacao ADD CONSTRAINT fk_AnotacaoEvento FOREIGN KEY idEvento "
        "REFERENCES evento ON DELETE CASCADE;";
    await database.execute(sql);
  }

  inicializarDataBase() async {
    final caminhoDataBase = await getDatabasesPath();
    final localDataBase = join(caminhoDataBase, "banco_anotacoes_gerais.db");

    var database = await openDatabase(localDataBase, version: 1, onCreate: _onCreate);

    return database;
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
/*
class Singleton {
  static final Singleton _singleton = Singleton._internal();
  	factory Singleton(){
      print("Singleton");
      return _singleton;
    }
    Singleton._internal(){
    	print("_internal");
  	}
}
void main() {

  var i1 = Singleton();
  print("***");
  var i2 = Singleton();

  print( i1 == i2 );

}


* */