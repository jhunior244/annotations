import 'package:hellor_world/model/Anotacao.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AnotacaoHelper {
  static final String nomeTabela = "anotacao";
  static final AnotacaoHelper _eventoHelper = AnotacaoHelper._internal();
  Database _database;

  factory AnotacaoHelper(){
    return _eventoHelper;
  }

  AnotacaoHelper._internal(){}

  get database async {
    if(_database != null){
      return _database;
    } else {
      _database = await inicialiarDataBase();
      return _database;
    }
  }

  _onCreate(Database database, int version) async{
    String sql = "CREATE TABLE $nomeTabela (id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "anotacao TEXT, dataProximaRevisao DATETIME, coeficienteProximaRevisao INTEGER, "
        "coeficienteRevisaoAnterior INTEGER, "
        "idEvento INTEGER); "
        "ALTER TABLE anotacao ADD CONSTRAINT fk_AnotacaoEvento FOREIGN KEY idEvento "
        "REFERENCES evento ON DELETE CASCADE;";
    await database.execute(sql);
  }

  inicialiarDataBase() async {
    final caminhoDataBase = await getDatabasesPath();
    final localDataBase = join(caminhoDataBase, "banco_anotacoes_gerais.db");

    var database = await openDatabase(localDataBase, version: 1, onCreate: _onCreate);

    return database;
  }

  Future<int> salvarAnotacao(Anotacao anotacao) async{
    var dataBase = await database;

    int id = await dataBase.insert(nomeTabela, anotacao.toMap());
    return id;
  }

  Future<int> atualizarAnotacao(Anotacao anotacao) async{
    Database dataBase = await database;

    int id = await dataBase.update(nomeTabela, anotacao.toMap(),
    where: "id = ?",
      whereArgs: [anotacao.id]
    );
    return id;
  }

  listarAnotacao() async {
    var formatter = new DateFormat('yyyy-MM-dd');

    DateTime dataNow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toLocal();
    dataNow = Jiffy(dataNow).add(days: 1);
    String teste = formatter.format(dataNow);
    var dataBase = await database;

    String sql = "SELECT * FROM $nomeTabela WHERE dataProximaRevisao BETWEEN '2000-01-01' AND '$teste'";
    List listaAnotacao = await dataBase.rawQuery(sql);
    return listaAnotacao;
  }

  Future<int> removerAnotacao( int id ) async {
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