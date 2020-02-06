import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Anotacao {
  int id;
  String anotacao;
  String dataProximaRevisao;
  int coeficienteRevisaoAnterior;
  int coeficienteProximaRevisao;
  int idEvento;
  String tituloEvento;

  Anotacao(this.anotacao, this.dataProximaRevisao, this.coeficienteRevisaoAnterior, this.coeficienteProximaRevisao, this.idEvento);

  Anotacao.fromMap(Map map){
    this.id = map["id"];
    this.anotacao = map["anotacao"];
    this.dataProximaRevisao = _toDateBR(map["dataProximaRevisao"]);
    this.idEvento = map["idEvento"];
    this.coeficienteProximaRevisao = map["coeficienteProximaRevisao"];
    this.coeficienteRevisaoAnterior = map["coeficienteRevisaoAnterior"];
  }

  String _toDateBR(String data){
    if(data == null){
      return null;
    }
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat.yMMMMd("pt_BR");
    String dataFormatada = formatador.format(DateTime.parse(data));
    return dataFormatada;
  }

  Map toMap(){
    Map<String, dynamic> map = {
      "anotacao": this.anotacao,
      "coeficienteProximaRevisao": this.coeficienteProximaRevisao,
      "coeficienteRevisaoAnterior": this.coeficienteRevisaoAnterior,
      "dataProximaRevisao": this.dataProximaRevisao,
      "idEvento": this.idEvento,
    };

    if(this.id != null){
      map["id"] = this.id;
    }
    return map;
  }
}