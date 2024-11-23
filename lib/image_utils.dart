import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:proyecto/bd.dart';
import 'classes/ImgCode.dart';

// Método para seleccionar la imagen
Future<File?> pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

// Método para guardar la imagen
Future<void> saveImage(File image, String imgName, String dir) async {
  try {
    final directory = Directory(dir);

    // Crea la carpeta si no existe
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final fileName = imgName;
    final String newPath = path.join(directory.path, fileName);

    // Copia la imagen a la ruta relativa
    final File localImage = await image.copy(newPath);
    print('Imagen guardada en: ${localImage.path}');
    
  } catch (e) {
    print("Error al guardar la imagen: $e");
  }
}

Future<void> deleteImage(String path) async {
  try {
    final file = File(path);
    await file.delete();
    print('Imagen eliminada: $path');
  } catch (e) {
    print("Error al eliminar la imagen: $e");
  }
}

// Método para seleccionar elementos de una lista de imágenes de contraseña
List<ImgCode> toggleSelection(List<ImgCode> selectionImgCode, ImgCode imgCode, int max, BuildContext context) {
  if (selectionImgCode.contains(imgCode)) {
    selectionImgCode.remove(imgCode);
  } else {
    if (selectionImgCode.length < max) {
      selectionImgCode.add(imgCode);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Máximo de $max elementos seleccionados.")),
      );
    }
  }

  return List.from(selectionImgCode);
}


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

/*
    Función
    @Nombre --> getImgCodeFromFolder
    @Funcion --> Devuelve los códigos de las imagenes de una carpeta
    @Argumentos
        - folder: nombre de la carpeta que contiene las imágenes
*/
Future<List<ImgCode>> getImgCodeFromFolder(String folder) async {
  return await ColegioDatabase.instance.getImgCodeFromFolder(folder);
}

// TOMATE
Future<int?> getImagePasswdCount(String user) async {
  return await ColegioDatabase.instance.getSpacesPasswordCount(user);
}
