import 'package:proyecto/classes/Classroom.dart';
import 'package:proyecto/classes/Menu.dart';
import 'package:proyecto/classes/Orders.dart';
import 'package:proyecto/classes/Student.dart';
import 'package:proyecto/bd.dart';
import 'classes/ImgCode.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////
///  LOGIN Y REGISTRO DE USUARIOS ///
String userAdmin = 'admin';
String passwordAdmin = 'admin';

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
  @Nombre --> deleteStudent
  @Funcion --> Permite eliminar un alumno de la base de datos
  @Argumentos
    - user: usuario del alumno que será eliminado
*/
Future<bool> deleteStudent(String user) async {
  return await ColegioDatabase.instance.deleteStudent(user);
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
  Método
  @Nombre --> deleteStudentImgCodePassword
  @Funcion --> Permite eliminar la relación entre un alumno y sus imágenes
  @Argumentos
    - user: el usuario del alumno
*/
Future<void> deleteStudentImgCodePassword(String user) async {
  await ColegioDatabase.instance.deleteDecryptEntries(user);
}


/*
  Método
  @Nombre --> getImgCodesByStudent
  @Funcion --> Permite obtener todas las imágenes asociadas a un alumno
  @Argumentos
    - user: el usuario del alumno del que se obtendrán las imágenes
*/
Future<List<ImgCode>> getStudentMenuPassword(String user) async {
  return await ColegioDatabase.instance.getImgCodesByStudent(user);
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

///////////////////////////////////////////////////////////////////////////////////////////////////
///  GESTIÓN DE ALUMNOS ///
/// 
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
  @Nombre --> modifyUserStudent
  @Funcion --> Modifica el usuario de un estudiante concreto 
  @Argumentos
    - user: usuario del alumno cuyo nombre será modificado
    - newUser: el nuevo usuario del alumno
*/
Future<bool> modifyUserStudent(String user, String newUser) async {
  return await ColegioDatabase.instance.modifyStudent(user, "user", newUser);
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
  Función
  @Nombre --> modifyTypePasswordStudent
  @Funcion --> Modifica el tipo de contraseña de un estudiante concreto
  @Argumentos
    - user: usuario del alumno cuya contraseña será modificada
    - newTypePassword: el nuevo tipo de contraseña del alumno
*/
Future<bool> modifyTypePasswordStudent(String user, String newTypePassword) async {
	return await ColegioDatabase.instance.modifyStudent(user, "typePassword", newTypePassword);
}

/*
  Función
  @Nombre --> modifyInterfaceStudent
  @Función --> Modifica la interfaz de un estudiante concreto
  @Argumentos
    - user: usuario del alumno cuya interfaz será modificada
    - interfaceIMG: determina si el alumno usará la interfaz basada en imágenes
    - interfacePIC: determina si el alumno usará la interfaz basada en pictogramas
    - intefaceTXT: determina si el alumno usará la interfaz basada en texto
*/

Future<bool> modifyInterfaceStudent(String user, int interfaceIMG, int interfacePIC, int interfaceTXT) async {
  return await ColegioDatabase.instance.modifyInterfaceStudent(user, interfaceIMG, interfacePIC, interfaceTXT);
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

Future<Student?> getStudent(String user) async {
  return await ColegioDatabase.instance.getStudent(user);
}

/*
  Función
  @Nombre --> getAllStudents
  @Funcion --> Devuelve todos los estudiantes registrados en la aplicación
*/
Future<List<Student>> getAllStudents() async {
	return await ColegioDatabase.instance.getAllStudents();
}

////////////////////////////////////////////////////////////////////////////////////////////////
///  GESTIÓN DE MENÚS ///
/*
  Método
  @Nombre --> insertMenu
  @Funcion --> Permite insertar un menú en la base de datos
  @Argumentos
    - name: nombre del menú
    - pictogram: pictograma asociado al menú
    - image: imagen asociada al menú
*/
Future<bool> insertMenu(String name, String pictogram, String image) async {
  Menu menu = Menu(name: name, pictogram: pictogram, image: image);
  return await ColegioDatabase.instance.insertMenu(menu);
}

/*
  Método
  @Nombre --> modifyMenuName
  @Funcion --> Modifica el nombre de un menú concreto
  @Argumentos
    - name: nombre del menú que será modificado
    - newName: el nuevo nombre del menú
*/
Future<bool> modifyMenuName(String name, String newName) async {
  return await ColegioDatabase.instance.modifyMenu(name, "name", newName);
}

/*
  Método
  @Nombre --> modifyMenuPictogram
  @Funcion --> Modifica el pictograma asociado a un menú concreto
  @Argumentos
    - name: nombre del menú al que se le modificará el pictograma
    - newPictogram: el nuevo pict
*/
Future<bool> modifyMenuPictogram(String name, String newPictogram) async {
  return await ColegioDatabase.instance.modifyMenu(name, "pictogram", newPictogram);
}

/*
  Método
  @Nombre --> modifyMenuImage
  @Funcion --> Modifica la imagen asociada a un menú concreto
  @Argumentos
    - name: nombre del menú al que se le modificará la imagen
    - newImage: la nueva imagen
*/
Future<bool> modifyMenuImage(String name, String newImage) async {
  return await ColegioDatabase.instance.modifyMenu(name, "image", newImage);
}

/*
  Método
  @Nombre --> modifyCompleteMenu
  @Funcion --> Actualiza todos los datos de un menú registrado en la aplicación
  @Argumentos
    - name: nombre del menú
    - newName: nuevo nombre del menú
    - newPictogram: nuevo pictograma asociado al menú
    - newImage: nueva imagen asociada al menú
*/
Future<bool> modifyCompleteMenu(String name, String newName, String newPictogram, String newImage) async {
  return await ColegioDatabase.instance.modifyCompleteMenu(name, newName, newPictogram, newImage);
}

/*
  Método
  @Nombre --> deleteMenu
  @Funcion --> Permite eliminar un menú de la base de datos
  @Argumentos
    - name: nombre del menú que será eliminado
*/
Future<bool> deleteMenu(String name) async {
  return await ColegioDatabase.instance.deleteMenu(name);
}

/*
  Método
  @Nombre --> getAllMenus
  @Funcion --> Devuelve todos los menús registrados en la aplicación
*/
Future<List<Menu>> getAllMenus() async {
  return await ColegioDatabase.instance.getAllMenus();
}

/*
  Método
  @Nombre --> getMenu
  @Funcion --> Devuelve un menú concreto
  @Argumentos
    - name: nombre del menú que será devuelto
*/
Future<Menu?> getMenu(String name) async {
  return await ColegioDatabase.instance.getMenu(name);
}
////////////////////////////////////////////////////////////////////////////////////////////////
///  GESTIÓN DE AULAS ///

/*
  Método
  @Nombre --> insertClassroom
  @Funcion --> Permite insertar un aula en la base de datos
  @Argumentos
    - name: nombre del aula
*/
Future<bool> insertClassroom(String name, String image) async {
  Classroom classroom = Classroom(name: name, image: image);
  return await ColegioDatabase.instance.insertClassroom(classroom);
}

/*
  Método
  @Nombre --> modifyClassroom
  @Funcion --> Modifica el nombre de un aula concreta
  @Argumentos
    - name: nombre del aula que será modificado
    - newName: el nuevo nombre del aula
*/
Future<bool> modifyClassroom(String name, String newName) async {
  return await ColegioDatabase.instance.modifyClassroom(name, newName);
}

/*
  Método
  @Nombre --> deleteClassroom
  @Funcion --> Permite eliminar un aula de la base de datos
  @Argumentos
    - name: nombre del aula que será eliminado
*/
Future<bool> deleteClassroom(String name) async {
  return await ColegioDatabase.instance.deleteClassroom(name);
}

/*
  Método
  @Nombre --> getAllClassrooms
  @Funcion --> Devuelve todas las aulas registradas en la aplicación
*/
Future<List<Classroom>> getAllClassrooms() async {
  return await ColegioDatabase.instance.getAllClassrooms();
}

/*
  Método
  @Nombre --> getClassroom
  @Funcion --> Devuelve un aula concreta
  @Argumentos
    - name: nombre del aula que será devuelto
*/
Future<Classroom?> getClassroom(String name) async {
  return await ColegioDatabase.instance.getClassroom(name);
}

////////////////////////////////////////////////////////////////////////////////////////////////
///  GESTIÓN DE PEDIDOS ///
/*
  Método
  @Nombre --> insertOrders
  @Funcion --> Permite insertar un pedido en la base de datos
  @Argumentos
    - quantity: cantidad de menús pedidos
    - menuName: nombre del menú
    - classroomName: nombre del aula
*/
Future<bool> insertOrders(int quantity, String menuName, String classroomName) async {
  DateTime now = DateTime.now();
  String date = now.day.toString() + "/" + now.month.toString() + "/" + now.year.toString();
  Orders order = Orders(date: date, quantity: quantity, menuName: menuName, classroomName: classroomName);
  return await ColegioDatabase.instance.insertOrders(order);
}

/*
  Método
  @Nombre --> insertObjectOrder
  @Funcion --> Permite insertar un pedido en la base de datos
  @Argumentos
    - order: pedido a insertar
*/
Future<bool> insertObjectOrder(Orders order) async {
  return await ColegioDatabase.instance.insertOrders(order);
}

/*
  Método
  @Nombre --> insertListOrders
  @Funcion --> Permite insertar una lista de pedidos en la base de datos
  @Argumentos
    - orSders: lista de pedidos
*/
Future<bool> insertListOrders(List<Orders> orders) async{
  for (Orders order in orders) {
    if (!await ColegioDatabase.instance.insertOrders(order)) {
      return false;
    }
  }
  return true;
}

/*
  Método
  @Nombre --> modifyOrders
  @Funcion --> Modifica un pedido concreto
  @Argumentos
    - menuName: nombre del menú
    - classroomName: nombre del aula
    - newQuantity
*/
Future<bool> modifyOrders(String menuName, String classroomName, int newQuantity) async {
  DateTime now = DateTime.now();
  String date = now.day.toString() + "/" + now.month.toString() + "/" + now.year.toString();
  Orders? order = await ColegioDatabase.instance.getOrder(date, menuName, classroomName);
  if (order == null) {
    return false;
  }
  return await ColegioDatabase.instance.modifyOrders(order, newQuantity);
}

/*
@Nombre --> getQuantity
@Funcion --> Obtiene la cantidad asociada a una orden.
@Argumentos
  - date: fecha de la orden
  - classroomName: nombre del aula
  - menuName: nombre del menú
*/
Future<int> getQuantity(String date, String classroomName, String menuName) async {
  Orders? order = await ColegioDatabase.instance.getOrder(date, menuName, classroomName);
  if(order == null){
    return 0;
  } else {
    return order.quantity;
  }
}


/*
@Nombre --> getOrder
@Funcion --> Obtiene una orden.
@Argumentos
  - date: fecha de la orden
  - classroomName: nombre del aula de la orden.
  - menuName: nombre del menú de la orden.
*/
Future<Orders?> getOrder(String date, String classroomName, String menuName) async {
  return await ColegioDatabase.instance.getOrder(date, menuName, classroomName);
}

Future<void> classCompleted(Classroom classroom) async{
  DateTime now = DateTime.now();
  String date = now.day.toString() + "/" + now.month.toString() + "/" + now.year.toString();
  classroom.task_completed = await ColegioDatabase.instance.classCompleted(classroom, date);
}



////////////////////////////////////////////////////////////////////////////////////////////////
///  GESTIÓN DE TAREA MENU ///
/*
  Método
  @Nombre --> setMenuTask
  @Funcion --> Permite asignar la tarea del menu a un alumno
  @Argumentos
    - user: usuario del alumno al que se le asignará la tarea
*/
Future<bool> setMenuTask(String user) async {
  return await ColegioDatabase.instance.setMenuTask(user);
}

/*
  Método
  @Nombre --> removetMenuTask
  @Funcion --> Permite eliminar la tarea del menu de un alumno
  @Argumentos
    - user: usuario del alumno al que se le eliminará la tarea
*/
Future<bool> removeMenuTask(String user) async {
  return await ColegioDatabase.instance.removeMenuTask(user);
}

/*
  Método
  @Nombre --> getStudentWithMenuTask
  @Funcion --> Devuelve el alumno al que se le ha asignado la tarea del menú
*/
Future<List<String>?> getStudentsWithMenuTask() async {
  return await ColegioDatabase.instance.getStudentsWithMenuTask();
}

/*
  Método
  @Nombre --> asignMenuTask
  @Funcion --> Permite asignar la tarea del menú a un alumno y elimina la tarea de
                cualquier otro alumno que la tuviera asignada
  @Argumentos
    - user: usuario del alumno al que se le asignará la tarea
*/
Future<bool> asignMenuTask(String user) async {
  List<String>? students = await getStudentsWithMenuTask();
  for (String student in students!) {
    removeMenuTask(student);
  }
  return await setMenuTask(user);
}

/*
  Método
  @Nombre --> hasMenuTask
  @Función --> Comprueba si un alumno tiene la tarea del menú asignada
  @Argumentos
    - user: usuario del alumno
*/
Future<bool> hasMenuTask(String user) async {
  return await ColegioDatabase.instance.hasMenuTask(user);
}