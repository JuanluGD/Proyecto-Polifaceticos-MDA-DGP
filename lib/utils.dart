
import 'package:proyecto/Administrador.dart';
import 'package:proyecto/bd.dart';

Future<bool> iniciarSesionAdministrador(String user, String password) async{
	
	bool correcto = false;
	Administrador admin = Administrador(id:0, user: user, password: password);

	correcto = await ColegioDatabase.instance.comprobarAdministrador(admin);

	return correcto;
}