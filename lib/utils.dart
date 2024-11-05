
import 'package:proyecto/Admin.dart';
import 'package:proyecto/Student.dart';
import 'package:proyecto/bd.dart';

Future<bool> iniciarSesionAdministrador(String name, String user, String password, int DNI, String last_name1,
									 String last_name2, String photo) async{
	
	bool correcto = false;
	Administrador admin = Administrador(user: user, password: password, name: name, DNI: DNI, last_name1: last_name1, 
								last_name2: last_name2, photo: photo);

	correcto = await ColegioDatabase.instance.comprobarAdministrador(admin);

	return correcto;
}

Future<bool> iniciarSesionEstudiante(String user, String password) async{
	
	bool correcto = false;
	Estudiante est = Estudiante(user: user, password: password, name: "name", DNI: 0, last_name1: "0", 
								last_name2: "0", photo: "0", tipoPasswd: "0", interfazIMG: false, 
								interfazPIC: false, interfazTXT: false);

	correcto = await ColegioDatabase.instance.comprobarEstudiantes(est);

	return correcto;
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
