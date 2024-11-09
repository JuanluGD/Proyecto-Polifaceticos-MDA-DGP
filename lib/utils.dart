import 'dart:io';

import 'package:proyecto/ImgCode.dart';
import 'package:proyecto/Student.dart';
import 'package:proyecto/bd.dart';

String user = 'admin';
String password = 'admin';

bool loginAdmin(String user, String password){
  return user == 'admin' && password == 'admin';
}

Future<bool> loginStudent(String user, String password) async{
	return await ColegioDatabase.instance.loginStudent(user, password);
}

Future<bool> login(String user, String password) async{
  if(user == "admin"){
    return loginAdmin(user, password);
  }
  else {
    return await loginStudent(user, password);
  }
}

Future<bool> registerStudent(String user, name, String surname, String password, 
  String image, String typePassword, int interfaceIMG,
	int interfacePIC, int interfaceTXT) async{

  if (user == "admin") {
    return false;
  }
  
	Student student = Student(password: password, name: name, user: user, surname:surname, 
    image: image, typePassword: typePassword, interfaceIMG: interfaceIMG,
		interfacePIC: interfacePIC, interfaceTXT: interfaceTXT);

	return await ColegioDatabase.instance.registerStudent(student);

}

Future<bool> asignLoginType(String user, String typePassword) async {
	return await ColegioDatabase.instance.asignLoginType(user, typePassword);;
}


Future<bool> modifyNameStudent(String user, String newName) async{
	return await ColegioDatabase.instance.modifyStudent(user, "name", newName);
}

Future<bool> modifyPasswordStudent(String user, String newPassword) async{
	return await ColegioDatabase.instance.modifyStudent(user, "password", newPassword);
}

Future<bool> modifyCompleteStudent(String user, String name, String? surname, String password, 
  String photo, String typePassword, int interfaceIMG, int interfacePIC, int interfaceTXT) async{
  return await ColegioDatabase.instance.modifyCompleteStudent(user, name, surname, password, photo, typePassword, interfaceIMG, interfacePIC, interfaceTXT);
}

Future<bool> userIsValid(String user) async{
  return await ColegioDatabase.instance.userIsValid(user);
}

bool userFormat(String texto) {
  final regex = RegExp(r'^[a-zA-Z0-9]+$');
  return regex.hasMatch(texto);
}

// Funncion que convierte los pictogramas seleccionads en la cntraseña
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