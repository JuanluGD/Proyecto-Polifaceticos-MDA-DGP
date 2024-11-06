import 'package:proyecto/Admin.dart';
import 'package:proyecto/Student.dart';
import 'package:proyecto/bd.dart';

Future<bool> loginAdmin(String dni, String password) async{

	bool correct = false;

	correct = await ColegioDatabase.instance.loginAdmin(dni, password);

	return correct;
}


Future<bool> loginStudent(String dni, String password) async{
	
	bool correct = false;

	correct = await ColegioDatabase.instance.loginStudent(dni, password);

	return correct;
}

Future<bool> registerStudent(String dni, name, String surname1, String surname2,
	String password, String photo, String typePassword, int interfaceIMG,
	int interfacePIC, int interfaceTXT) async{
	
	bool correct = false;
	Student student = Student(password: password, name: name, dni: dni, surname1: surname1,
			surname2: surname2, photo: photo, typePassword: typePassword, interfaceIMG: interfaceIMG,
			interfacePIC: interfacePIC, interfaceTXT: interfaceTXT);

	correct = await ColegioDatabase.instance.registerStudent(student);

	return correct;
}

Future<bool> asignLoginType(String dni, String typePassword) async {

	bool result = await ColegioDatabase.instance.asignLoginType(typePassword, dni);

	return result;
}


Future<bool> modifyNameStudent(String dni, String newName) async{

	bool result = await ColegioDatabase.instance.modifyStudent(dni, "name", newName);

	return result;
}

Future<bool> modifyPasswordStudnt(String dni, String newPassword) async{

	bool result = await ColegioDatabase.instance.modifyStudent(dni, "password", newPassword);

	return result;
}
