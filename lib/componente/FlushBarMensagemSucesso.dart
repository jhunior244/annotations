import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlushBarMensagemSucesso {
  void show(BuildContext context, String mensagem){
    Flushbar(
        margin: EdgeInsets.only(bottom: 70, left: 15, right: 15),
        message: mensagem,
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        dismissDirection: FlushbarDismissDirection.HORIZONTAL
    )..show(context);
  }
}


