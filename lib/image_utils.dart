import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';

import 'ImgCode.dart';

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
