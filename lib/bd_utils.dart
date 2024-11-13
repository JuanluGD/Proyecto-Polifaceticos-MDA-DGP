import 'package:proyecto/Student.dart';
import 'package:proyecto/bd.dart';
import 'ImgCode.dart';

String user = 'admin';
String password = 'admin';


/*
    Función
    @Nombre --> loginAdmin
    @Funcion --> Comprueba que los datos introducidos correspondan al administrador
    @Argumentos
        - user: usuario introducido
        - password: contraseña introducida
*/
bool loginAdmin(String user, String password) {
  return user == 'admin' && password == 'admin';
}

/*
    Función
    @Nombre --> loginStudent
    @Funcion --> Comprueba que los datos introducidos correspondan a algun alumno registrado
    @Argumentos
        - user: el usuario del alumno
        - password: contraseña del alumno
*/
Future<bool> loginStudent(String user, String password) async {
	return await ColegioDatabase.instance.loginStudent(user, password);
}

/*
    Función
    @Nombre --> login
    @Funcion --> Comprueba que los datos introducidos correspondan o bien al administrador 
                 o bien a algun alumno registrado en el sistema
    @Argumentos
        - user: usuario introducido
        - password: contraseña introducida
*/
Future<bool> login(String user, String password) async {
  if(user == "admin"){
    return loginAdmin(user, password);
  }
  else {
    return await loginStudent(user, password);
  }
}


/*
    Función
    @Nombre --> registerStudent
    @Funcion --> Registra un alumno en la base de datos
    @Argumentos
        - user: usuario del alumno que será registrado
        - name: nombre
        - surname: apellido
        - password: contraseña
        - image: foto del alumno
        - typePassword: tipo de contraseña que usará el alumno para iniciar al sesión
        - interfaceIMG: determina si el alumno usará la interfaz basada en imágenes
        - interfacePIC: determina si el alumno usará la interfaz basada en pictogramas
        - intefaceTXT: determina si el alumno usará la interfaz basada en texto

*/
Future<bool> registerStudent(String user, name, String surname, String password, 
  String image, String typePassword, int interfaceIMG,
	int interfacePIC, int interfaceTXT) async {

  if (user == "admin") {
    return false;
  }
  
	Student student = Student(password: password, name: name, user: user, surname:surname, 
    image: image, typePassword: typePassword, interfaceIMG: interfaceIMG,
		interfacePIC: interfacePIC, interfaceTXT: interfaceTXT);

	return await ColegioDatabase.instance.registerStudent(student);

}


/*
    Función
    @Nombre --> asignLoginType
    @Funcion --> asigna a un alumno concreto un tipo de inicio de sesión
    @Argumentos
        - user: usuario del alumno al que se le realizará la modificación
        - typePassword: tipo de inicio de sesión que será asignado al alumno
*/
Future<bool> asignLoginType(String user, String typePassword) async {
	return await ColegioDatabase.instance.asignLoginType(user, typePassword);
}

/*
    Función
    @Nombre --> createStudentImgCodePassword
    @Funcion --> Permite asignar a un alumno las imágenes que usará para iniciar sesión
    @Argumentos
        - user: el usuario del alumno al que se le asignarán las imágenes
        - images: las imágenes que usará dicho usuario para iniciar sesión
*/
Future<void> createStudentImgCodePassword(String user, List<ImgCode> images) async {
  await ColegioDatabase.instance.insertDecryptEntries(user, images);
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


/*
    Función
    @Nombre --> modifyNameStudent
    @Funcion --> Modifica el nombre de un estudiante concreto
    @Argumentos
        - user: usuario del alumno cuyo nombre será modificado
        - newName: el nuevo nombre del alumno
*/
Future<bool> modifyNameStudent(String user, String newName) async {
	return await ColegioDatabase.instance.modifyStudent(user, "name", newName);
}

/*
    Función
    @Nombre --> modifyPasswordStudent
    @Funcion --> Modifica la contraseña de un estudiante concreto
    @Argumentos
        - user: usuario del alumno cuya contraseña será modificada
        - newPassword: la nueva contraseña del alumno
*/
Future<bool> modifyPasswordStudent(String user, String newPassword) async {
	return await ColegioDatabase.instance.modifyStudent(user, "password", newPassword);
}

/*
    Método
    @Nombre --> modifyCompleteStudent
    @Funcion --> Actualiza todos los datos de un alumno registrado en la aplicación
    @Argumentos
        - user: usuario del alumno al que se le realizará las modificaciónes
        - name: nombre
        - surname: apellido
        - password: contraseña
        - photo: foto del alumno
        - typePassword: tipo de contraseña que usará el alumno para iniciar al sesión
        - interfaceIMG: determina si el alumno usará la interfaz basada en imágenes
        - interfacePIC: determina si el alumno usará la interfaz basada en pictogramas
        - intefaceTXT: determina si el alumno usará la interfaz basada en texto

*/
Future<bool> modifyCompleteStudent(String user, String name, String? surname, String password, 
  String photo, String typePassword, int interfaceIMG, int interfacePIC, int interfaceTXT) async {
  return await ColegioDatabase.instance.modifyCompleteStudent(user, name, surname, password, photo, typePassword, interfaceIMG, interfacePIC, interfaceTXT);
}


/*
    Método
    @Nombre --> userIsValid
    @Funcion --> Comprueba que un usuario en concreto exista en la aplicación
    @Argumentos
        - user: el usuario del alumno
*/
Future<bool> userIsValid(String user) async {
  return await ColegioDatabase.instance.userIsValid(user);
}


/*
    Método
    @Nombre --> userFormat
    @Funcion --> Comprueba que un nombre de usuario esté en un formato correcto
    @Argumentos
        - texto: el usuario cuyo formato será comprobado
*/
bool userFormat(String texto) {
  final regex = RegExp(r'^[a-zA-Z0-9]+$');
  return regex.hasMatch(texto);
}

