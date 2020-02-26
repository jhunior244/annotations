import 'package:flutter/cupertino.dart';
import 'package:hellor_world/componente/FlushBarMensagemSucesso.dart';
import 'package:hellor_world/helper/AnotacaoHelper.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import 'Evento.dart';

class Anotacao {
  int id;
  String anotacao;
  String dataProximaRevisao;
  int coeficienteRevisaoAnterior;
  int coeficienteProximaRevisao;
  int idEvento;
  String tituloEvento;

  Anotacao.vazio();

  Anotacao(this.anotacao, this.dataProximaRevisao, this.coeficienteRevisaoAnterior, this.coeficienteProximaRevisao, this.idEvento);

  Anotacao.fromMap(Map map){
    this.id = map["id"];
    this.anotacao = map["anotacao"];
    this.dataProximaRevisao = _toDateBR(map["dataProximaRevisao"]);
    this.idEvento = map["idEvento"];
    this.coeficienteProximaRevisao = map["coeficienteProximaRevisao"];
    this.coeficienteRevisaoAnterior = map["coeficienteRevisaoAnterior"];
    this.tituloEvento = map["tituloEvento"];
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

  void calculaProximaRevisao(Anotacao anotacao){

    var _anotacaoHelper = AnotacaoHelper();
    var formatter = new DateFormat('yyyy-MM-dd');

    DateTime dataNow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toLocal();

    String dataProximaRevisao = "";

    dataProximaRevisao = Jiffy(dataNow).add(days: anotacao.coeficienteProximaRevisao + anotacao.coeficienteRevisaoAnterior).toString();
    anotacao.dataProximaRevisao = dataProximaRevisao;
    int auxCoefRevAnterior = anotacao.coeficienteRevisaoAnterior;
    anotacao.coeficienteRevisaoAnterior = anotacao.coeficienteProximaRevisao;
    anotacao.coeficienteProximaRevisao += auxCoefRevAnterior;
    print(anotacao.dataProximaRevisao);
    _anotacaoHelper.atualizarAnotacao(anotacao);
  }

  void salvarAnotacao(BuildContext context, Evento evento, String anotacaoTexto) async {

    var _anotacaoHelper = AnotacaoHelper();

    DateTime dataNow = DateTime(DateTime
        .now()
        .year, DateTime
        .now()
        .month, DateTime
        .now()
        .day).toLocal();
    Anotacao anotacao = Anotacao(
        anotacaoTexto, dataNow.toString(), 1, 1, evento.id);
    int resultado = await _anotacaoHelper.salvarAnotacao(anotacao);
    Navigator.pop(context);
    FlushBarMensagemSucesso().show(context, "Anotação criada!");
  }
}