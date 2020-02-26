import 'package:hellor_world/helper/DataBaseHelper.dart';
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
      _database = await DataBaseHelper().database;
      return _database;
    }
  }

  Future<int> salvarAnotacao(Anotacao anotacao) async{
    var dataBase = await database;

    int id = await dataBase.insert(nomeTabela, anotacao.toMap());
    print(id);
    return id;
  }

  void atualizarAnotacao(Anotacao anotacao) async{
    Database dataBase = await database;

    int teste = await dataBase.update(
        nomeTabela,
        anotacao.toMap(),
        where: "id = ?",
        whereArgs: [anotacao.id]
    );
  }

  listarAnotacao() async {
    var formatter = new DateFormat('yyyy-MM-dd');

//    DateTime dataNow = DateTime(DateTime.now()).toLocal();
//    dataNow = Jiffy(dataNow).add(days: 1);
    String atual = DateTime.now().toIso8601String();
    var dataBase = await database;

    String sql = "SELECT DISTINCT "
        "anotacao.id as id, anotacao.anotacao, anotacao.dataProximaRevisao, anotacao.idEvento as idEvento, "
        "anotacao.coeficienteProximaRevisao, anotacao.coeficienteRevisaoAnterior, evento.titulo as tituloEvento "
        "FROM $nomeTabela inner join evento "
        "on $nomeTabela.idEvento = evento.id "
        "WHERE $nomeTabela.dataProximaRevisao BETWEEN '2000-01-01' AND '$atual' "
        "OR julianday(evento.data) = julianday('now', '+7 days') "
        "OR julianday(evento.data) = julianday('now', '+5 days') "
        "OR julianday(evento.data) = julianday('now', '+3 days') "
        "OR julianday(evento.data) = julianday('now', '+2 days') "
        "OR julianday(evento.data) = julianday('now', '+1 days')";

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
