
import 'package:proyecto/Administrador.dart';
import 'package:proyecto/Estudiante.dart';
import 'package:proyecto/bd.dart';

Future<bool> iniciarSesionAdministrador(String user, String password) async{
	
	bool correcto = false;
	Administrador admin = Administrador(user: user, password: password);

	correcto = await ColegioDatabase.instance.comprobarAdministrador(admin);

	return correcto;
}

Future<bool> iniciarSesionEstudiante(String name, String user, String password) async{
	
	bool correcto = false;
	Estudiante est = Estudiante(name: name, user: user, password: password);

	correcto = await ColegioDatabase.instance.comprobarEstudiantes(est);

	return correcto;
}

Future<bool> registrarEstudiante(String name, String user, String password, String loginType) async{
	
	bool correcto = false;
	Estudiante est = Estudiante(name: name, user: user, password: password, loginType: loginType);

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
