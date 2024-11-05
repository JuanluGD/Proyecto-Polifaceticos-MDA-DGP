
import 'package:proyecto/Admin.dart';
import 'package:proyecto/Student.dart';
import 'package:proyecto/bd.dart';

Future<bool> loginAdmin(String DNI, String name, String lastName1,
									 String lastName2, String password, String photo) async{
	
	bool correct = false;
	Admin admin = Admin(password: password, name: name, DNI: DNI, lastName1: lastName1,
			lastName2: lastName2, photo: photo);

	correct = await ColegioDatabase.instance.checkAdmin(admin);

	return correct;
}

Future<bool> loginStudent(String DNI, String password) async{
	
	bool correct = false;
	Student student = Student(password: password, name: "name", DNI: 0, last_name1: "0",
								last_name2: "0", photo: "0", tipoPasswd: "0", interfazIMG: false, 
								interfazPIC: false, interfazTXT: false);

	correct = await ColegioDatabase.instance.checkStudent(student);

	return correct;
}

Future<bool> registrarEstudiante(String name, String user, String password, int DNI, String last_name1,
									 String last_name2, String photo, String tipoPasswd, bool interfazIMG,
									 bool interfazPIC, bool interfazTXT) async{
	
	bool correcto = false;
	Estudiante est = Estudiante(user: user, password: password, name: name, DNI: DNI, last_name1: last_name1, 
								last_name2: last_name2, photo: photo, tipoPasswd: tipoPasswd, interfazIMG: interfazIMG, 
								interfazPIC: interfazPIC, interfazTXT: interfazTXT);

	correcto = await ColegioDatabase.instance.registrarEstudiante(est);

	return correcto;
}

Future<bool> asignarLoginType(String user, String loginType) async {

	bool resultado = await ColegioDatabase.instance.asignarLoginType(loginType, user);

	return resultado;
}

Future<bool> modificarUserEstudiante(String user, String nuevoUser) async{

	bool resultado = await ColegioDatabase.instance.modificarDatoEstudiante(user, "user", nuevoUser);

	return resultado;
}

Future<bool> modificarNameEstudiante(String user, String nuevoName) async{

	bool resultado = await ColegioDatabase.instance.modificarDatoEstudiante(user, "name", nuevoName);

	return resultado;
}

Future<bool> modificarPasswordEstudiante(String user, String nuevoPassword) async{

	bool resultado = await ColegioDatabase.instance.modificarDatoEstudiante(user, "password", nuevoPassword);

	return resultado;
}
