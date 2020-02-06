import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Evento {
  int id;
  String titulo;
  String data;

  Evento(this.titulo, this.data);

  Evento.fromMap(Map map){
    this.id = map["id"];
    this.titulo = map["titulo"];
    this.data = toDateBR(map["data"]);
  }

  static String toDateBR(String data){
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat.yMMMMd("pt_BR");
    String dataFormatada = formatador.format(DateTime.parse(data));
    return dataFormatada;
  }

  Map toMap(){
    Map<String, dynamic> map = {
      "titulo": this.titulo,
      "data": this.data,
    };

    if(this.id != null){
      map["id"] = this.id;
    }
    return map;
  }
}