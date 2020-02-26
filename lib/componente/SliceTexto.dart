class SliceTexto {
  String sliceAnotacao(String anotacao, int tamanhoMaximo){
    if(anotacao == null){
      return "";
    } else if(anotacao.length <= 3){
      return anotacao;
    }
    if(anotacao.contains("\n", 0)){
      anotacao = anotacao.replaceAll(new RegExp(r'\n'), " ");
    }
    if(anotacao.length >= tamanhoMaximo){
      return anotacao.substring(0, tamanhoMaximo - 3) + "...";
    }
    return anotacao;
  }
}