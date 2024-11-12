// Funncion que convierte los pictogramas seleccionads en la cntraseña
import 'dart:io';

import 'package:proyecto/ImgCode.dart';
import 'package:proyecto/bd.dart';

Future<String> imageCodeToPassword(List<ImgCode> pictograms) async {
  String password = "";
  for (int i = 0; i < pictograms.length; i++){
    password += await ColegioDatabase.instance.getCodeImgCode(pictograms[i].path);
  }
  return password;
}

Future<bool> insertImgCode(String path) async {
  String code = "";
  if (path.contains("picto_claves")) {
    code = path.split("/").last + "_picto";
  }
  else{
    code = path.split("/").last + "_img";
  }
  return await ColegioDatabase.instance.insertImgCode(path, code);
}

Future<String> rewritePath(String path) async {
  String new_path = path;
  int index = await ColegioDatabase.instance.imgCodePathCount(new_path);

  return new_path += index.toString();
}

String removeSpacing(String text) {
  return text.replaceAll(' ', '_');
}

Future<bool> pathExists(String path, String directory) async{
  final dir = Directory(directory);
  bool exist= false;
    // Comprobamos si el directorio existe
  if (!await dir.exists()) {
    print('El directorio no existe');
    exist = false;
  }
    // Listamos los archivos del directorio
  var archivos = await dir.list(recursive: true).toList();

  for (var archivo in archivos) {
    if (archivo.path == path) {
      exist = true;
    }
    else {
      exist = false;
    }
  }
  return exist;
}