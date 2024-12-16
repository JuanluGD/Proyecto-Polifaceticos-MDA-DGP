import 'package:proyecto/classes/Classroom.dart';
import 'package:proyecto/classes/Menu.dart';
import 'package:proyecto/classes/Order.dart';
import 'package:proyecto/classes/Student.dart';
import 'package:proyecto/bd.dart';
import 'package:proyecto/classes/Task.dart';
import 'classes/Execute.dart';
import 'classes/ImgCode.dart';
import 'classes/Step.dart';

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
  @Nombre --> insertStudent
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
Future<bool> insertStudent(String user, name, String surname, String password, 
  String image, String typePassword, int interfaceIMG,
	int interfacePIC, int interfaceTXT) async {

  if (user == "admin") {
    return false;
  }
  
	Student student = Student(password: password, name: name, user: user, surname:surname, 
    image: image, typePassword: typePassword, interfaceIMG: interfaceIMG,
		interfacePIC: interfacePIC, interfaceTXT: interfaceTXT);

	return await ColegioDatabase.instance.insertStudent(student);

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
  String date = '${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  Order order = Order(date: date, quantity: quantity, menuName: menuName, classroomName: classroomName);
  return await ColegioDatabase.instance.insertOrders(order);
}

/*
  Método
  @Nombre --> insertObjectOrder
  @Funcion --> Permite insertar un pedido en la base de datos
  @Argumentos
    - order: pedido a insertar
*/
Future<bool> insertObjectOrder(Order order) async {
  return await ColegioDatabase.instance.insertOrders(order);
}

/*
  Método
  @Nombre --> insertListOrders
  @Funcion --> Permite insertar una lista de pedidos en la base de datos
  @Argumentos
    - orSders: lista de pedidos
*/
Future<bool> insertListOrders(List<Order> orders) async{
  for (Order order in orders) {
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
  String date = '${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  Order? order = await ColegioDatabase.instance.getOrder(date, menuName, classroomName);
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
  try {
    Order? order = await ColegioDatabase.instance.getOrder(date, menuName, classroomName);
    return order?.quantity ?? 0; // Si no hay orden, retorna 0.
  } catch (e) {
    return 0; // Retorna 0 si ocurre algún error.
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
Future<Order?> getOrder(String date, String classroomName, String menuName) async {
  return await ColegioDatabase.instance.getOrder(date, menuName, classroomName);
}

/*
  @Nombre --> getOrders
  @Funcion --> Obtiene todas las ordenes de la base de datos del dia actual.
*/
Future<List<Order>> getOrdersByDate() async {
  DateTime now = DateTime.now();
  String date = '${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  return await ColegioDatabase.instance.getOrdersByDate(date);
}

/*
  @Nombre --> classCompleted
  @Funcion --> Marca una clase como completada.
  @Argumentos
    - classroom: aula que se marcará como completada.
*/
Future<void> classCompleted(Classroom classroom) async {
  DateTime now = DateTime.now();
  String date = '${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
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
  @Nombre --> hasMenuTask
  @Función --> Comprueba si un alumno tiene la tarea del menú asignada
  @Argumentos
    - user: usuario del alumno
*/
Future<bool> hasMenuTaskToday() async {
  return await ColegioDatabase.instance.hasMenuTaskToday();
}

/*
  Método
  @Nombre --> menuIsValid
  @Funcion --> Comprueba que un menú en concreto exista en la aplicación
  @Argumentos
      - name: el nombre del menú
*/
Future<bool> menuIsValid(String name) async {
  return await ColegioDatabase.instance.menuIsValid(name);
}

////////////////////////////////////////////////////////////////////////////////////////////////
///  GESTIÓN DE TAREAS ///

/*
  Método
  @Nombre --> insertTask
  @Funcion --> Inserta una nueva tarea en la base de datos
  @Argumentos
      - name: el nombre de la tarea
      - description: la descripción de la tarea
      - pictogram: el pictograma asociado a la tarea
      - image: la imagen asociada a la tarea
      - descriptive_text: texto descriptivo adicional de la tarea
*/
Future<bool> insertTask(String name, String description, String pictogram, String image, String? descriptive_text) async {
  return await ColegioDatabase.instance.insertTask(name, description, pictogram, image, descriptive_text);
}

/*
  Método
  @Nombre --> modifyTaskName
  @Funcion --> Modifica el nombre de una tarea existente en la base de datos
  @Argumentos
      - id: el identificador de la tarea
      - newName: el nuevo nombre de la tarea
*/
Future<bool> modifyTaskName(int id, String newName) async {
  return await ColegioDatabase.instance.modifyTask(id, "name", newName);
}

/*
  Método
  @Nombre --> modifyTaskDescription
  @Funcion --> Modifica la descripción de una tarea existente en la base de datos
  @Argumentos
      - id: el identificador de la tarea
      - newDescription: la nueva descripción de la tarea
*/
Future<bool> modifyTaskDescription(int id, String newDescription) async {
  return await ColegioDatabase.instance.modifyTask(id, "description", newDescription);
}

/*
  Método
  @Nombre --> modifyTaskPictogram
  @Funcion --> Modifica el pictograma de una tarea existente en la base de datos
  @Argumentos
      - id: el identificador de la tarea
      - newPictogram: el nuevo pictograma de la tarea
*/
Future<bool> modifyTaskPictogram(int id, String newPictogram) async {
  return await ColegioDatabase.instance.modifyTask(id, "pictogram", newPictogram);
}

/*
  Método
  @Nombre --> modifyTaskImage
  @Funcion --> Modifica la imagen de una tarea existente en la base de datos
  @Argumentos
      - id: el identificador de la tarea
      - newImage: la nueva imagen de la tarea
*/
Future<bool> modifyTaskImage(int id, String newImage) async {
  return await ColegioDatabase.instance.modifyTask(id, "image", newImage);
}

/*
  Método
  @Nombre --> modifyTaskDescriptiveText
  @Funcion --> Modifica el texto descriptivo de una tarea existente en la base de datos
  @Argumentos
      - id: el identificador de la tarea
      - newDescriptiveText: el nuevo texto descriptivo de la tarea
*/
Future<bool> modifyTaskDescriptiveText(int id, String newDescriptiveText) async {
  return await ColegioDatabase.instance.modifyTask(id, "descriptive_text", newDescriptiveText);
}

/*
  Método
  @Nombre --> modifyCompleteTask
  @Funcion --> Modifica todos los atributos de una tarea existente en la base de datos
  @Argumentos
      - id: el identificador de la tarea
      - name: el nuevo nombre de la tarea
      - description: la nueva descripción de la tarea
      - pictogram: el nuevo pictograma de la tarea
      - image: la nueva imagen de la tarea
      - descriptive_text: el nuevo texto descriptivo de la tarea
*/
Future<bool> modifyCompleteTask(int id, String name, String description, String pictogram, String image, String? descriptive_text) async {
  return await ColegioDatabase.instance.modifyCompleteTask(id, name, description, pictogram, image, descriptive_text);
}

/*
  Método
  @Nombre --> deleteTask
  @Funcion --> Elimina una tarea de la base de datos
  @Argumentos
      - id: el identificador de la tarea a eliminar
*/
Future<bool> deleteTask(int id) async {
  return await ColegioDatabase.instance.deleteTask(id);
}

/*
  Método
  @Nombre --> getTask
  @Funcion --> Obtiene una tarea específica de la base de datos por su identificador
  @Argumentos
      - id: el identificador de la tarea
*/
Future<Task?> getTask(int id) async {
  return await ColegioDatabase.instance.getTask(id);
}

/*
  Método
  @Nombre --> getTaskByName
  @Funcion --> Obtiene una tarea específica de la base de datos por su nombre
  @Argumentos
      - name: el nombre de la tarea
*/
Future<Task?> getTaskByName(String name) async {
  return await ColegioDatabase.instance.getTaskByName(name);
}

/*
  Método
  @Nombre --> searchTasks
  @Funcion --> Busca tareas en la base de datos que coincidan con un texto
  @Argumentos
      - text: el texto a buscar en las tareas
*/
Future<List<Task>> searchTasks(String text) async {
  return await ColegioDatabase.instance.searchTasks(text);
}

/*
  Método
  @Nombre --> getAllTasks
  @Funcion --> Obtiene todas las tareas almacenadas en la base de datos
  @Argumentos
      - (Ninguno)
*/
Future<List<Task>> getAllTasks() async {
  return await ColegioDatabase.instance.getAllTasks();
}

/*
  Método
  @Nombre --> taskIsValid
  @Funcion --> Comprueba si una tarea con un nombre específico existe en la base de datos
  @Argumentos
      - name: el nombre de la tarea
*/
Future<bool> taskIsValid(String name) async {
  return await ColegioDatabase.instance.taskIsValid(name);
}

////////////////////////////////////////////////////////////////////////////////////////////////
///  GESTIÓN DE PASOS ///

/*
  Método
  @Nombre --> insertStep
  @Funcion --> Inserta un nuevo paso en una tarea específica en la base de datos
  @Argumentos
      - task_id: el identificador de la tarea a la que pertenece el paso
      - description: la descripción del paso
      - pictogram: el pictograma asociado al paso
      - image: la imagen asociada al paso
      - descriptive_text: texto descriptivo adicional del paso (opcional)
*/
Future<bool> insertStep(int task_id, String description, String pictogram, String image, String? descriptive_text) async {
  List<Step> steps = await ColegioDatabase.instance.getAllStepsFromTask(task_id);
  int id = steps.length;
  Step step = Step(id: id, task_id: task_id, description: description, pictogram: pictogram, image: image, descriptive_text: descriptive_text);
  return await ColegioDatabase.instance.insertStep(step);
}

/*
  Método
  @Nombre --> modifyStepName
  @Funcion --> Modifica el nombre de un paso específico en la base de datos
  @Argumentos
      - id: el identificador del paso
      - task_id: el identificador de la tarea a la que pertenece el paso
      - newName: el nuevo nombre del paso
*/
Future<bool> modifyStepName(int id, int task_id, String newName) async {
  return await ColegioDatabase.instance.modifyStep(id, task_id, "name", newName);
}

/*
  Método
  @Nombre --> modifyStepDescription
  @Funcion --> Modifica la descripción de un paso específico en la base de datos
  @Argumentos
      - id: el identificador del paso
      - task_id: el identificador de la tarea a la que pertenece el paso
      - newDescription: la nueva descripción del paso
*/
Future<bool> modifyStepDescription(int id, int task_id, String newDescription) async {
  return await ColegioDatabase.instance.modifyStep(id, task_id, "description", newDescription);
}

/*
  Método
  @Nombre --> modifyStepPictogram
  @Funcion --> Modifica el pictograma de un paso específico en la base de datos
  @Argumentos
      - id: el identificador del paso
      - task_id: el identificador de la tarea a la que pertenece el paso
      - newPictogram: el nuevo pictograma del paso
*/
Future<bool> modifyStepPictogram(int id, int task_id, String newPictogram) async {
  return await ColegioDatabase.instance.modifyStep(id, task_id, "pictogram", newPictogram);
}

/*
  Método
  @Nombre --> modifyStepImage
  @Funcion --> Modifica la imagen de un paso específico en la base de datos
  @Argumentos
      - id: el identificador del paso
      - task_id: el identificador de la tarea a la que pertenece el paso
      - newImage: la nueva imagen del paso
*/
Future<bool> modifyStepImage(int id, int task_id, String newImage) async {
  return await ColegioDatabase.instance.modifyStep(id, task_id, "image", newImage);
}

/*
  Método
  @Nombre --> modifyStepDescriptiveText
  @Funcion --> Modifica el texto descriptivo de un paso específico en la base de datos
  @Argumentos
      - id: el identificador del paso
      - task_id: el identificador de la tarea a la que pertenece el paso
      - newDescriptiveText: el nuevo texto descriptivo del paso
*/
Future<bool> modifyStepDescriptiveText(int id, int task_id, String newDescriptiveText) async {
  return await ColegioDatabase.instance.modifyStep(id, task_id, "descriptive_text", newDescriptiveText);
}

/*
  Método
  @Nombre --> deleteStep
  @Funcion --> Elimina un paso específico de una tarea en la base de datos
  @Argumentos
      - id: el identificador del paso a eliminar
      - task_id: el identificador de la tarea a la que pertenece el paso
*/
Future<bool> deleteStep(int id, int task_id) async {
  return await ColegioDatabase.instance.deleteStep(id, task_id);
}

/*
  Método
  @Nombre --> getStep
  @Funcion --> Obtiene un paso específico de una tarea desde la base de datos
  @Argumentos
      - id: el identificador del paso
      - task_id: el identificador de la tarea a la que pertenece el paso
*/
Future<Step?> getStep(int id, int task_id) async {
  return await ColegioDatabase.instance.getStep(id, task_id);
}

/*
  Método
  @Nombre --> getAllStepsFromTask
  @Funcion --> Obtiene todos los pasos de una tarea específica desde la base de datos
  @Argumentos
      - idTask: el identificador de la tarea
*/
Future<List<Step>> getAllStepsFromTask(int idTask) async {
  return await ColegioDatabase.instance.getAllStepsFromTask(idTask);
}

/*
  Método
  @Nombre --> incrementStep
  @Funcion --> Incrementa el identificador de un paso específico en la base de datos
  @Argumentos
      - id: el identificador del paso
      - task_id: el identificador de la tarea a la que pertenece el paso
*/
Future<bool> incrementStep(int id, int task_id) async {
  return await ColegioDatabase.instance.incrementId(id, task_id);
}

/*
  Método
  @Nombre --> decrementStep
  @Funcion --> Decrementa el identificador de un paso específico en la base de datos
  @Argumentos
      - id: el identificador del paso
      - task_id: el identificador de la tarea a la que pertenece el paso
*/
Future<bool> decrementStep(int id, int task_id) async {
  return await ColegioDatabase.instance.decrementId(id, task_id);
}

////////////////////////////////////////////////////////////////////////////////////////////////
///  GESTIÓN DE EXECUTE ///

/*
  Método
  @Nombre --> insertExecute
  @Funcion --> Inserta una nueva ejecución en la base de datos
  @Argumentos
      - task_id: el identificador de la tarea asociada
      - user: el usuario que realiza la ejecución
      - status: el estado de la ejecución
      - date: la fecha de la ejecución
*/
Future<bool> insertExecute(int task_id, String user, int status, String date) async {
  Execute execute = Execute(task_id: task_id, user: user, status: status, date: date);
  return await ColegioDatabase.instance.insertExecute(execute);
}

/*
  Método
  @Nombre --> modifyExecuteDate
  @Funcion --> Modifica la fecha de una ejecución existente en la base de datos
  @Argumentos
      - execute: la ejecución a modificar
      - date: la nueva fecha para la ejecución
*/
Future<bool> modifyExecuteDate(Execute execute, String date) async {
  return await ColegioDatabase.instance.modifyExecuteDate(execute, date);
}

/*
  Método
  @Nombre --> modifyExecuteStatus
  @Funcion --> Modifica el estado de una ejecución existente en la base de datos
  @Argumentos
      - execute: la ejecución a modificar
      - status: el nuevo estado para la ejecución
*/
Future<bool> modifyExecuteStatus(Execute execute, int status) async {
  return await ColegioDatabase.instance.modifyExecuteStatus(execute, status);
}

/*
  Método
  @Nombre --> deleteExecute
  @Funcion --> Elimina una ejecución específica de la base de datos
  @Argumentos
      - execute: la ejecución a eliminar
*/
Future<bool> deleteExecute(Execute execute) async {
  return await ColegioDatabase.instance.deleteExecute(execute);
}

/*
  Método
  @Nombre --> getExecute
  @Funcion --> Obtiene una ejecución específica de la base de datos
  @Argumentos
      - id_task: el identificador de la tarea asociada
      - user: el usuario que realizó la ejecución
      - date: la fecha de la ejecución
*/
Future<Execute?> getExecute(int id_task, String user, String date) async {
  return await ColegioDatabase.instance.getExecute(id_task, user, date);
}

/*
  Método
  @Nombre --> getStudentExecutes
  @Funcion --> Obtiene todas las ejecuciones realizadas por un estudiante
  @Argumentos
      - user: el usuario (estudiante) cuyas ejecuciones se quieren obtener
*/
Future<List<Execute>> getStudentExecutes(String user) async {
  return await ColegioDatabase.instance.getStudentExecutes(user);
}

/*
  Método
  @Nombre --> getStudentToDo
  @Funcion --> Obtiene las ejecuciones pendientes de un estudiante
  @Argumentos
      - user: el usuario (estudiante) cuyas ejecuciones pendientes se quieren obtener
*/
Future<List<Execute>> getStudentToDo(String user) async {
  return await ColegioDatabase.instance.getStudentToDo(user);
}