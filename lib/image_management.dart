// Funncion que convierte los pictogramas seleccionads en la cntraseña
import 'dart:io';

import 'package:proyecto/ImgCode.dart';
import 'package:proyecto/bd.dart';

/*
  Función
  @Nombre --> imageCodeToPassword
  @Funcion --> Convierte los pictogramas seleccionados en la contraseña
  @Argumentos
    - pictograms: lista de pictogramas seleccionados
*/
Future<String> imageCodeToPassword(List<ImgCode> pictograms) async {
  String password = "";
  for (int i = 0; i < pictograms.length; i++){
    password += await ColegioDatabase.instance.getCodeImgCode(pictograms[i].path);
    password += ' ';
  }
  return password;
}

/*
  Función
  @Nombre --> passwordToImageCode
  @Funcion --> Convierte la contraseña en una lista de pictogramas
  @Argumentos
    - passwd: contraseña
*/
Future<List<ImgCode>> passwordToImageCode(String passwd) async {
  final codes = passwd.split(' ');

  List<ImgCode> imgCodes = [];

  for (String code in codes) {
    final imgCode = await ColegioDatabase.instance.getImgCodeFromCode(code);
    if (imgCode != null) {
      imgCodes.add(imgCode);
    }
  }

  return imgCodes;
}

/*
  Función
  @Nombre --> insertImgCode
  @Funcion --> Inserta un pictograma en la base de datos
  @Argumentos
    - path: ruta del pictograma a insertar
*/
Future<bool> insertImgCode(String path) async {
  String code = "";
  if (path.contains("picto_claves")) {
    code = path.split("/").last + "_picto";
  }
  else {
    code = path.split("/").last + "_img";
  }
  return await ColegioDatabase.instance.insertImgCode(path, code);
}

/*
  Función
  @Nombre --> rewritePath
  @Funcion --> Reescribe la ruta de un pictograma
  @Argumentos
    - path: ruta del pictograma a reescribir
*/
Future<String> rewritePath(String path) async {
  String new_path = path;
  int index = await ColegioDatabase.instance.imgCodePathCount(new_path);

  return new_path += index.toString();
}

/*
  Función
  @Nombre --> removeSpacing
  @Funcion --> Elimina los espacios de un texto
  @Argumentos
    - text: texto al que se le eliminarán los espacios
*/
String removeSpacing(String text) {
  return text.replaceAll(' ', '_');
}

/*
  Función
  @Nombre --> pathExists
  @Funcion --> Comprueba si un archivo existe en un directorio
  @Argumentos
    - path: ruta del archivo a comprobar
    - directory: directorio en el que se buscará el archivo
*/
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